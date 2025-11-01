import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { serveStatic } from 'hono/cloudflare-workers'
import type { Bindings, Competency, CompetencyModel, AIGenerationRequest } from './types'

const app = new Hono<{ Bindings: Bindings }>()

// CORS 활성화 (API 전용)
app.use('/api/*', cors())

// 정적 파일 제공
app.use('/static/*', serveStatic({ root: './public' }))

// ============================================================================
// API Routes
// ============================================================================

// 역량 모델 목록 조회
app.get('/api/competency-models', async (c) => {
  try {
    const db = c.env.DB
    if (!db) {
      return c.json({ success: true, data: [], message: 'Database not configured' })
    }
    const { results } = await db.prepare(`
      SELECT * FROM competency_models ORDER BY created_at DESC
    `).all()
    return c.json({ success: true, data: results })
  } catch (error) {
    console.error('Error:', error)
    return c.json({ success: false, data: [], error: 'Database error' }, 500)
  }
})

// 역량 모델 생성
app.post('/api/competency-models', async (c) => {
  const db = c.env.DB
  const body = await c.req.json<CompetencyModel>()
  
  const result = await db.prepare(`
    INSERT INTO competency_models (name, type, description, target_level)
    VALUES (?, ?, ?, ?)
  `).bind(body.name, body.type, body.description, body.target_level).run()
  
  return c.json({ success: true, id: result.meta.last_row_id })
})

// 역량 키워드 검색 (먼저 정의해야 함!)
app.get('/api/competencies/search', async (c) => {
  try {
    const db = c.env.DB
    
    // D1이 설정되지 않은 경우 빈 결과 반환
    if (!db) {
      return c.json({ 
        success: true, 
        data: [],
        message: 'Database not configured. Please set up D1 database binding.' 
      })
    }
    
    const query = c.req.query('q') || ''
    
    const { results } = await db.prepare(`
      SELECT c.*, cm.name as model_name, cm.type as model_type
      FROM competencies c
      JOIN competency_models cm ON c.model_id = cm.id
      WHERE c.keyword LIKE ? OR c.description LIKE ?
      ORDER BY c.created_at DESC
    `).bind(`%${query}%`, `%${query}%`).all()
    
    return c.json({ success: true, data: results })
  } catch (error) {
    console.error('Search error:', error)
    return c.json({ 
      success: false, 
      error: 'Database error',
      message: error instanceof Error ? error.message : 'Unknown error',
      data: []
    }, 500)
  }
})

// 특정 모델의 역량 키워드 조회
app.get('/api/competencies/:modelId', async (c) => {
  try {
    const db = c.env.DB
    if (!db) {
      return c.json({ success: true, data: [], message: 'Database not configured' })
    }
    const modelId = c.req.param('modelId')
    
    const { results } = await db.prepare(`
      SELECT c.*, cm.name as model_name, cm.type as model_type
      FROM competencies c
      JOIN competency_models cm ON c.model_id = cm.id
      WHERE c.model_id = ?
      ORDER BY c.created_at DESC
    `).bind(modelId).all()
    
    return c.json({ success: true, data: results })
  } catch (error) {
    console.error('Error:', error)
    return c.json({ success: false, data: [], error: 'Database error' }, 500)
  }
})

// 역량 키워드 추가
app.post('/api/competencies', async (c) => {
  const db = c.env.DB
  const body = await c.req.json<Competency>()
  
  const result = await db.prepare(`
    INSERT INTO competencies (model_id, keyword, description)
    VALUES (?, ?, ?)
  `).bind(body.model_id, body.keyword, body.description).run()
  
  return c.json({ success: true, id: result.meta.last_row_id })
})

// 저장된 문항 조회 API
app.post('/api/ai/get-saved-questions', async (c) => {
  try {
    const db = c.env.DB
    if (!db) {
      return c.json({ success: true, data: null })
    }
    
    const body = await c.req.json<{ competency_keywords: string[] }>()
    
    const savedData = {
      behavioral_indicators: [] as any[],
      questions: [] as any[]
    }
    
    // 각 역량별로 저장된 행동지표와 문항 조회
    for (const keyword of body.competency_keywords) {
      // 역량 ID 조회
      const { results: compResults } = await db.prepare(`
        SELECT id FROM competencies WHERE keyword = ? LIMIT 1
      `).bind(keyword).all()
      
      if (compResults && compResults.length > 0) {
        const competencyId = compResults[0].id
        
        // 행동지표 조회
        const { results: indicators } = await db.prepare(`
          SELECT indicator_text FROM behavioral_indicators 
          WHERE competency_id = ?
        `).bind(competencyId).all()
        
        if (indicators && indicators.length > 0) {
          savedData.behavioral_indicators.push({
            competency: keyword,
            indicators: indicators.map((ind: any) => ind.indicator_text)
          })
        }
        
        // 진단문항 조회
        const { results: questions } = await db.prepare(`
          SELECT question_text, question_type FROM assessment_questions 
          WHERE competency_id = ?
        `).bind(competencyId).all()
        
        if (questions && questions.length > 0) {
          savedData.questions.push(...questions.map((q: any) => ({
            competency: keyword,
            question_text: q.question_text,
            question_type: q.question_type
          })))
        }
      }
    }
    
    // 모든 역량에 대한 데이터가 있으면 반환
    if (savedData.behavioral_indicators.length === body.competency_keywords.length) {
      return c.json({ success: true, data: savedData })
    }
    
    return c.json({ success: true, data: null })
  } catch (error) {
    console.error('Error fetching saved questions:', error)
    return c.json({ success: true, data: null })
  }
})

// AI 문항 생성 API
app.post('/api/ai/generate-questions', async (c) => {
  const db = c.env.DB
  const apiKey = c.env.OPENAI_API_KEY
  const body = await c.req.json<AIGenerationRequest>()
  
  // 데모 모드: API 키가 없으면 샘플 데이터 반환
  if (!apiKey || apiKey === 'your-openai-api-key-here') {
    const demoData = {
      behavioral_indicators: body.competency_keywords.map(keyword => ({
        competency: keyword,
        indicators: [
          `${keyword} 관련 업무를 체계적으로 수행합니다`,
          `${keyword}을 활용하여 팀 목표 달성에 기여합니다`,
          `${keyword} 역량을 지속적으로 개발하고 향상시킵니다`
        ]
      })),
      questions: body.competency_keywords.flatMap(keyword => [
        {
          competency: keyword,
          question_text: `나는 ${keyword} 역량을 효과적으로 발휘한다`,
          question_type: body.question_type
        },
        {
          competency: keyword,
          question_text: `나는 ${keyword}과 관련된 업무를 자신있게 수행할 수 있다`,
          question_type: body.question_type
        },
        {
          competency: keyword,
          question_text: `나는 ${keyword} 역량 개발을 위해 노력하고 있다`,
          question_type: body.question_type
        },
        {
          competency: keyword,
          question_text: `동료들은 나의 ${keyword} 역량을 인정한다`,
          question_type: body.question_type
        },
        {
          competency: keyword,
          question_text: `나는 ${keyword}을 활용하여 조직 성과에 기여한다`,
          question_type: body.question_type
        }
      ]),
      guide: `🔍 진단 안내\n\n본 진단은 ${body.competency_keywords.join(', ')} 역량을 평가하기 위한 ${body.question_type === 'self' ? '자가진단' : body.question_type === 'multi' ? '다면평가' : '설문조사'}입니다.\n\n✅ 목적:\n- 현재 역량 수준 파악\n- 강점과 개발영역 확인\n- 개인 성장 방향 설정\n\n⚠️ 유의사항:\n- 솔직하고 객관적으로 응답해주세요\n- 최근 6개월 동안의 경험을 바탕으로 평가하세요\n- 모든 문항에 빠짐없이 응답해주세요\n\n📋 프로세스:\n1. 진단 실시 (약 10-15분 소요)\n2. 결과 분석 및 리포트 생성\n3. AI 코칭 및 개발 계획 수립\n\n⚙️ 데모 모드: 실제 AI 생성을 원하시면 .dev.vars 파일에 OpenAI API 키를 설정하세요.`
    }
    
    return c.json({ success: true, data: demoData, demo: true })
  }
  
  // OpenAI API 호출
  const prompt = `당신은 조직 역량 진단 전문가입니다. 다음 역량들에 대한 진단 문항을 생성해주세요.

역량 키워드: ${body.competency_keywords.join(', ')}
대상 직급: ${body.target_level}
진단 유형: ${body.question_type}

각 역량마다 다음을 생성해주세요:
1. 행동 지표 (Behavioral Indicators) 3개
2. 진단 문항 5개

응답 형식 (JSON):
{
  "behavioral_indicators": [
    {
      "competency": "역량명",
      "indicators": ["지표1", "지표2", "지표3"]
    }
  ],
  "questions": [
    {
      "competency": "역량명",
      "question_text": "문항 내용",
      "question_type": "${body.question_type}"
    }
  ],
  "guide": "진단 안내문 (목적, 유의사항, 프로세스 포함)"
}`

  try {
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`
      },
      body: JSON.stringify({
        model: 'gpt-4o-mini',
        messages: [
          { role: 'system', content: '당신은 조직 역량 진단 및 인재개발 전문가입니다.' },
          { role: 'user', content: prompt }
        ],
        temperature: 0.7,
        response_format: { type: 'json_object' }
      })
    })
    
    if (!response.ok) {
      const error = await response.text()
      return c.json({ success: false, error: `OpenAI API 오류: ${error}` }, 500)
    }
    
    const data = await response.json() as any
    const content = JSON.parse(data.choices[0].message.content)
    
    // DB에 저장 (있으면)
    if (db) {
      try {
        for (const behavioralItem of content.behavioral_indicators || []) {
          // 역량 ID 조회
          const { results: compResults } = await db.prepare(`
            SELECT id FROM competencies WHERE keyword = ? LIMIT 1
          `).bind(behavioralItem.competency).all()
          
          if (compResults && compResults.length > 0) {
            const competencyId = compResults[0].id
            
            // 행동지표 저장
            for (const indicator of behavioralItem.indicators || []) {
              try {
                await db.prepare(`
                  INSERT INTO behavioral_indicators (competency_id, indicator_text)
                  VALUES (?, ?)
                `).bind(competencyId, indicator).run()
              } catch (insertError) {
                console.error('Error inserting indicator:', insertError)
                // 중복 등의 오류는 무시하고 계속 진행
              }
            }
          }
        }
        
        // 진단문항 저장
        for (const question of content.questions || []) {
          // 역량 ID 조회
          const { results: compResults } = await db.prepare(`
            SELECT id FROM competencies WHERE keyword = ? LIMIT 1
          `).bind(question.competency).all()
          
          if (compResults && compResults.length > 0) {
            const competencyId = compResults[0].id
            
            try {
              await db.prepare(`
                INSERT INTO assessment_questions (competency_id, question_text, question_type)
                VALUES (?, ?, ?)
              `).bind(competencyId, question.question_text, question.question_type).run()
            } catch (insertError) {
              console.error('Error inserting question:', insertError)
              // 중복 등의 오류는 무시하고 계속 진행
            }
          }
        }
      } catch (dbError) {
        console.error('Error saving to database:', dbError)
        // DB 저장 실패해도 생성된 데이터는 반환
      }
    }
    
    return c.json({ success: true, data: content })
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500)
  }
})

// 진단 세션 생성
app.post('/api/assessment-sessions', async (c) => {
  const db = c.env.DB
  const body = await c.req.json()
  
  const result = await db.prepare(`
    INSERT INTO assessment_sessions (session_name, session_type, target_level, status)
    VALUES (?, ?, ?, ?)
  `).bind(body.session_name, body.session_type, body.target_level, 'draft').run()
  
  return c.json({ success: true, id: result.meta.last_row_id })
})

// 진단 세션 목록 조회
app.get('/api/assessment-sessions', async (c) => {
  const db = c.env.DB
  const { results } = await db.prepare(`
    SELECT * FROM assessment_sessions ORDER BY created_at DESC
  `).all()
  return c.json({ success: true, data: results })
})

// 세션-역량 매핑
app.post('/api/session-competencies', async (c) => {
  const db = c.env.DB
  const body = await c.req.json()
  
  const result = await db.prepare(`
    INSERT INTO session_competencies (session_id, competency_id)
    VALUES (?, ?)
  `).bind(body.session_id, body.competency_id).run()
  
  return c.json({ success: true, id: result.meta.last_row_id })
})

// 진단 문항 목록 조회 (진단 실행용)
app.get('/api/assessment-questions', async (c) => {
  const db = c.env.DB
  const { results } = await db.prepare(`
    SELECT 
      aq.id,
      aq.question_text,
      aq.question_type,
      aq.scale_type,
      c.keyword as competency,
      c.description as competency_description,
      cm.name as model_name
    FROM assessment_questions aq
    JOIN competencies c ON aq.competency_id = c.id
    JOIN competency_models cm ON c.model_id = cm.id
    ORDER BY cm.name, c.keyword, aq.id
  `).all()
  
  return c.json({ success: true, data: results, count: results.length })
})

// 문항 저장 (키워드 기반)
app.post('/api/assessment-questions-save', async (c) => {
  const db = c.env.DB
  const body = await c.req.json()
  
  // 역량 키워드로 competency_id 찾기
  const competency = await db.prepare(`
    SELECT id FROM competencies WHERE keyword = ?
  `).bind(body.competency_keyword).first()
  
  if (!competency) {
    return c.json({ success: false, error: '역량을 찾을 수 없습니다' }, 404)
  }
  
  const result = await db.prepare(`
    INSERT INTO assessment_questions (competency_id, question_text, question_type)
    VALUES (?, ?, ?)
  `).bind(competency.id, body.question_text, body.question_type).run()
  
  return c.json({ success: true, id: result.meta.last_row_id })
})

// 진단 응답 저장
app.post('/api/assessment-responses', async (c) => {
  const db = c.env.DB
  const body = await c.req.json()
  
  // 먼저 해당 문항 ID를 찾거나 생성
  let questionId = body.question_id
  
  if (!questionId) {
    // 문항 텍스트로 검색
    const existingQuestion = await db.prepare(`
      SELECT id FROM assessment_questions WHERE question_text = ?
    `).bind(body.question_text).first()
    
    if (existingQuestion) {
      questionId = existingQuestion.id
    } else {
      // 역량으로 competency_id 찾기
      const competency = await db.prepare(`
        SELECT id FROM competencies WHERE keyword = ?
      `).bind(body.competency).first()
      
      if (competency) {
        const newQuestion = await db.prepare(`
          INSERT INTO assessment_questions (competency_id, question_text, question_type)
          VALUES (?, ?, ?)
        `).bind(competency.id, body.question_text, 'self').run()
        
        questionId = newQuestion.meta.last_row_id
      }
    }
  }
  
  const result = await db.prepare(`
    INSERT INTO assessment_responses (session_id, respondent_id, question_id, response_value)
    VALUES (?, ?, ?, ?)
  `).bind(body.session_id, body.respondent_id, questionId, body.response_value).run()
  
  return c.json({ success: true, id: result.meta.last_row_id })
})

// 진단 일괄 제출 (새로운 API)
app.post('/api/submit-assessment', async (c) => {
  const db = c.env.DB
  const body = await c.req.json()
  
  try {
    // 1. 세션 생성 (이미 있으면 재사용)
    let sessionId = body.session_id
    if (!sessionId) {
      const sessionName = body.respondent_info?.name 
        ? `${body.respondent_info.name}의 진단 (${new Date().toLocaleDateString('ko-KR')})`
        : `익명 진단 (${new Date().toLocaleDateString('ko-KR')})`
      
      const sessionResult = await db.prepare(`
        INSERT INTO assessment_sessions (session_name, session_type, target_level, status, start_date)
        VALUES (?, 'self', ?, 'completed', datetime('now'))
      `).bind(sessionName, body.respondent_info?.level || '').run()
      sessionId = sessionResult.meta.last_row_id
    }
    
    // 2. 응답자 등록 또는 조회
    const respondentInfo = body.respondent_info
    let respondentId = null
    
    if (respondentInfo && respondentInfo.email) {
      // 기존 응답자 확인
      const existing = await db.prepare(`
        SELECT id FROM respondents WHERE email = ?
      `).bind(respondentInfo.email).first()
      
      if (existing) {
        respondentId = existing.id
      } else {
        // 새 응답자 등록
        const respondentResult = await db.prepare(`
          INSERT INTO respondents (name, email, department, position)
          VALUES (?, ?, ?, ?)
        `).bind(
          respondentInfo.name || '익명',
          respondentInfo.email,
          respondentInfo.department || '',
          respondentInfo.position || ''
        ).run()
        respondentId = respondentResult.meta.last_row_id
      }
    }
    
    // 3. 각 응답 저장
    const responses = body.responses || []
    const savedResponses = []
    
    for (const resp of responses) {
      // 문항 ID 찾기 또는 생성
      let questionId = resp.question_id
      
      if (!questionId) {
        // 역량으로 competency_id 찾기
        const competency = await db.prepare(`
          SELECT id FROM competencies WHERE keyword = ?
        `).bind(resp.competency).first()
        
        if (competency) {
          // 문항이 이미 있는지 확인
          const existingQuestion = await db.prepare(`
            SELECT id FROM assessment_questions 
            WHERE competency_id = ? AND question_text = ?
          `).bind(competency.id, resp.question_text).first()
          
          if (existingQuestion) {
            questionId = existingQuestion.id
          } else {
            // 새 문항 생성
            const questionResult = await db.prepare(`
              INSERT INTO assessment_questions (competency_id, question_text, question_type)
              VALUES (?, ?, 'self')
            `).bind(competency.id, resp.question_text).run()
            questionId = questionResult.meta.last_row_id
          }
        }
      }
      
      if (questionId) {
        // 응답 저장
        const responseResult = await db.prepare(`
          INSERT INTO assessment_responses (session_id, respondent_id, question_id, response_value)
          VALUES (?, ?, ?, ?)
        `).bind(sessionId, respondentId, questionId, resp.response).run()
        
        savedResponses.push({
          id: responseResult.meta.last_row_id,
          question_id: questionId,
          response: resp.response
        })
      }
    }
    
    return c.json({ 
      success: true, 
      session_id: sessionId,
      respondent_id: respondentId,
      saved_count: savedResponses.length,
      message: '진단이 성공적으로 제출되었습니다!'
    })
  } catch (error: any) {
    console.error('Submit assessment error:', error)
    return c.json({ 
      success: false, 
      error: error.message 
    }, 500)
  }
})

// 최근 제출 데이터 확인 (디버그용)
app.get('/api/debug/recent-submissions', async (c) => {
  const db = c.env.DB
  
  try {
    // 최근 세션
    const sessions = await db.prepare(`
      SELECT * FROM assessment_sessions 
      ORDER BY created_at DESC 
      LIMIT 5
    `).all()
    
    // 최근 응답자
    const respondents = await db.prepare(`
      SELECT * FROM respondents 
      ORDER BY created_at DESC 
      LIMIT 5
    `).all()
    
    // 최근 응답
    const responses = await db.prepare(`
      SELECT ar.*, aq.question_text, r.name as respondent_name
      FROM assessment_responses ar
      LEFT JOIN assessment_questions aq ON ar.question_id = aq.id
      LEFT JOIN respondents r ON ar.respondent_id = r.id
      ORDER BY ar.created_at DESC 
      LIMIT 20
    `).all()
    
    return c.json({
      success: true,
      data: {
        sessions: sessions.results,
        respondents: respondents.results,
        responses: responses.results
      }
    })
  } catch (error: any) {
    return c.json({ 
      success: false, 
      error: error.message 
    }, 500)
  }
})

// 응답자 등록
app.post('/api/respondents', async (c) => {
  const db = c.env.DB
  const body = await c.req.json()
  
  // 기존 응답자 확인
  const existing = await db.prepare(`
    SELECT id FROM respondents WHERE email = ?
  `).bind(body.email).first()
  
  if (existing) {
    return c.json({ success: true, id: existing.id, message: '기존 응답자' })
  }
  
  const result = await db.prepare(`
    INSERT INTO respondents (name, email, department, position, level)
    VALUES (?, ?, ?, ?, ?)
  `).bind(body.name, body.email, body.department, body.position, body.level).run()
  
  return c.json({ success: true, id: result.meta.last_row_id })
})

// 응답자 목록
app.get('/api/respondents', async (c) => {
  const db = c.env.DB
  const { results } = await db.prepare(`
    SELECT * FROM respondents ORDER BY created_at DESC
  `).all()
  return c.json({ success: true, data: results })
})

// 응답자별 결과 분석
app.get('/api/analysis/:respondentId', async (c) => {
  const db = c.env.DB
  const respondentId = c.req.param('respondentId')
  
  // 응답자 정보
  const respondent = await db.prepare(`
    SELECT * FROM respondents WHERE id = ?
  `).bind(respondentId).first()
  
  if (!respondent) {
    return c.json({ success: false, error: '응답자를 찾을 수 없습니다' }, 404)
  }
  
  // 전체 응답 데이터 조회
  const { results: responses } = await db.prepare(`
    SELECT 
      ar.response_value,
      aq.question_text,
      aq.question_type,
      c.keyword as competency,
      c.description as competency_description
    FROM assessment_responses ar
    JOIN assessment_questions aq ON ar.question_id = aq.id
    JOIN competencies c ON aq.competency_id = c.id
    WHERE ar.respondent_id = ?
    ORDER BY c.keyword, ar.created_at
  `).bind(respondentId).all()
  
  if (!responses || responses.length === 0) {
    return c.json({ success: false, error: '응답 데이터가 없습니다' }, 404)
  }
  
  // 역량별 점수 계산
  const competencyScores: Record<string, any> = {}
  
  responses.forEach((r: any) => {
    if (!competencyScores[r.competency]) {
      competencyScores[r.competency] = {
        competency: r.competency,
        description: r.competency_description,
        scores: [],
        questions: []
      }
    }
    competencyScores[r.competency].scores.push(r.response_value)
    competencyScores[r.competency].questions.push({
      question_text: r.question_text,
      response_value: r.response_value
    })
  })
  
  // 통계 계산
  const analysis = Object.values(competencyScores).map((comp: any) => {
    const scores = comp.scores
    const avg = scores.reduce((a: number, b: number) => a + b, 0) / scores.length
    const max = Math.max(...scores)
    const min = Math.min(...scores)
    
    // 표준편차 계산
    const variance = scores.reduce((sum: number, val: number) => 
      sum + Math.pow(val - avg, 2), 0) / scores.length
    const stdDev = Math.sqrt(variance)
    
    return {
      competency: comp.competency,
      description: comp.description,
      average: parseFloat(avg.toFixed(2)),
      max,
      min,
      stdDev: parseFloat(stdDev.toFixed(2)),
      count: scores.length,
      questions: comp.questions
    }
  })
  
  // 전체 평균
  const overallAvg = analysis.reduce((sum, a) => sum + a.average, 0) / analysis.length
  
  // 강점/개선영역 식별
  const sortedByScore = [...analysis].sort((a, b) => b.average - a.average)
  const strengths = sortedByScore.slice(0, Math.ceil(sortedByScore.length / 3))
  const improvements = sortedByScore.slice(-Math.ceil(sortedByScore.length / 3))
  
  return c.json({
    success: true,
    data: {
      respondent,
      analysis,
      summary: {
        totalQuestions: responses.length,
        totalCompetencies: analysis.length,
        overallAverage: parseFloat(overallAvg.toFixed(2)),
        highestScore: sortedByScore[0],
        lowestScore: sortedByScore[sortedByScore.length - 1],
        strengths: strengths.map(s => s.competency),
        improvements: improvements.map(i => i.competency)
      }
    }
  })
})

// AI 인사이트 생성
// AI 인사이트 조회 API
app.get('/api/analysis/:respondentId/insights', async (c) => {
  try {
    const db = c.env.DB
    if (!db) {
      return c.json({ success: true, insights: null })
    }
    
    const respondentId = c.req.param('respondentId')
    
    // 저장된 인사이트 조회 (coaching_sessions 테이블 활용)
    const { results } = await db.prepare(`
      SELECT session_data FROM coaching_sessions 
      WHERE respondent_id = ? 
      AND session_data LIKE '%overall%'
      ORDER BY updated_at DESC
      LIMIT 1
    `).bind(respondentId).all()
    
    if (results && results.length > 0 && results[0].session_data) {
      try {
        const insights = JSON.parse(results[0].session_data as string)
        // 유효한 인사이트인지 확인
        if (insights.overall && insights.strengths && insights.improvements && insights.recommendations) {
          return c.json({ success: true, insights, cached: true })
        }
      } catch (parseError) {
        console.error('Error parsing insights:', parseError)
      }
    }
    
    return c.json({ success: true, insights: null })
  } catch (error) {
    console.error('Error fetching insights:', error)
    return c.json({ success: true, insights: null })
  }
})

app.post('/api/analysis/:respondentId/insights', async (c) => {
  const db = c.env.DB
  const apiKey = c.env.OPENAI_API_KEY
  const respondentId = c.req.param('respondentId')
  const body = await c.req.json()
  
  let insights
  let isDemo = false
  
  // 데모 모드 또는 실제 AI 사용
  if (!apiKey || apiKey === 'your-openai-api-key-here') {
    // 데모 인사이트
    insights = {
      overall: `${body.respondent.name}님의 전체 평균 점수는 ${body.summary.overallAverage}점으로, 전반적으로 우수한 역량 수준을 보이고 있습니다.`,
      strengths: `특히 ${body.summary.strengths.join(', ')} 역량에서 강점을 보이고 있습니다. 이러한 강점을 더욱 발전시켜 조직의 핵심 인재로 성장할 수 있습니다.`,
      improvements: `${body.summary.improvements.join(', ')} 역량은 개선이 필요한 영역입니다. 체계적인 학습과 실무 경험을 통해 향상시킬 수 있습니다.`,
      recommendations: [
        '강점 역량을 활용한 프로젝트 참여 기회 확대',
        '개선 영역에 대한 맞춤형 교육 프로그램 수강',
        '멘토링을 통한 실무 노하우 습득',
        '정기적인 피드백 세션으로 지속적 성장'
      ]
    }
    isDemo = true
  } else {
    // 실제 AI 인사이트 생성
    const prompt = `당신은 조직 역량 진단 전문가입니다. 다음 진단 결과를 분석하고 인사이트를 제공해주세요.

응답자: ${body.respondent.name} (${body.respondent.position})
전체 평균: ${body.summary.overallAverage}점
강점 역량: ${body.summary.strengths.join(', ')}
개선 영역: ${body.summary.improvements.join(', ')}

역량별 상세:
${body.analysis.map((a: any) => `- ${a.competency}: ${a.average}점 (${a.count}개 문항)`).join('\n')}

다음 JSON 형식으로 정확히 응답해주세요:
{
  "overall": "전반적인 역량 수준 평가 (2-3문장)",
  "strengths": "강점 역량 분석 및 활용 방안 (2-3문장)",
  "improvements": "개선 영역 분석 및 발전 방향 (2-3문장)",
  "recommendations": [
    "구체적인 실행 가능한 추천사항 1",
    "구체적인 실행 가능한 추천사항 2",
    "구체적인 실행 가능한 추천사항 3",
    "구체적인 실행 가능한 추천사항 4"
  ]
}

각 항목은 한국어로 작성하고, 실용적이고 구체적인 내용으로 작성해주세요.`

    try {
      const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey}`
        },
        body: JSON.stringify({
          model: 'gpt-4o-mini',
          messages: [
            { role: 'system', content: '당신은 조직 역량 진단 및 인재개발 전문가입니다.' },
            { role: 'user', content: prompt }
          ],
          temperature: 0.7,
          response_format: { type: 'json_object' }
        })
      })
      
      if (!response.ok) {
        throw new Error('OpenAI API 오류')
      }
      
      const data = await response.json() as any
      const rawInsights = JSON.parse(data.choices[0].message.content)
      
      // OpenAI 응답 형식을 프론트엔드 형식으로 변환
      insights = {
        overall: rawInsights.overall?.evaluation || rawInsights.overall || '분석 결과가 없습니다.',
        strengths: rawInsights.strengths?.analysis || rawInsights.strengths || '강점 분석 결과가 없습니다.',
        improvements: rawInsights.improvements?.analysis || rawInsights.improvements || '개선 영역 분석 결과가 없습니다.',
        recommendations: rawInsights.recommendations || []
      }
    } catch (error: any) {
      return c.json({ success: false, error: error.message }, 500)
    }
  }
  
  // DB에 인사이트 저장 (있으면)
  if (db) {
    try {
      const insightsJson = JSON.stringify(insights)
      
      // coaching_sessions 테이블에 인사이트 저장
      // respondent_id가 존재하는지 확인 필요 없음 (ON DELETE CASCADE)
      await db.prepare(`
        INSERT INTO coaching_sessions 
        (respondent_id, session_data, created_at, updated_at)
        VALUES (?, ?, datetime('now'), datetime('now'))
      `).bind(
        respondentId,
        insightsJson
      ).run()
    } catch (dbError) {
      console.error('Failed to save insights to DB:', dbError)
      // DB 저장 실패해도 인사이트는 반환
    }
  }
  
  return c.json({ success: true, insights, demo: isDemo })
})

// 저장된 대화 내용 조회 API
app.get('/api/ai/coaching-history/:assistantType', async (c) => {
  try {
    const db = c.env.DB
    if (!db) {
      return c.json({ success: true, messages: [] })
    }
    
    const assistantType = c.req.param('assistantType')
    
    // coaching_sessions 테이블에서 해당 어시스턴트 타입의 최근 대화 조회
    const { results } = await db.prepare(`
      SELECT session_data, updated_at FROM coaching_sessions 
      WHERE session_data LIKE ?
      ORDER BY updated_at DESC
      LIMIT 1
    `).bind(`%"assistantType":"${assistantType}"%`).all()
    
    if (results && results.length > 0 && results[0].session_data) {
      try {
        const sessionData = JSON.parse(results[0].session_data as string)
        if (sessionData.assistantType === assistantType && sessionData.messages) {
          return c.json({ 
            success: true, 
            messages: sessionData.messages,
            lastUpdate: results[0].updated_at
          })
        }
      } catch (parseError) {
        console.error('Error parsing session data:', parseError)
      }
    }
    
    return c.json({ success: true, messages: [] })
  } catch (error) {
    console.error('Error fetching coaching history:', error)
    return c.json({ success: true, messages: [] })
  }
})

// 대화 내용 저장 API
app.post('/api/ai/coaching-save', async (c) => {
  try {
    const db = c.env.DB
    if (!db) {
      return c.json({ success: true, message: 'Database not configured' })
    }
    
    const body = await c.req.json()
    const { assistantType, messages, respondentId } = body
    
    const sessionData = JSON.stringify({
      assistantType,
      messages,
      savedAt: new Date().toISOString()
    })
    
    // coaching_sessions 테이블에 저장
    await db.prepare(`
      INSERT INTO coaching_sessions 
      (respondent_id, session_data, created_at, updated_at)
      VALUES (?, ?, datetime('now'), datetime('now'))
    `).bind(
      respondentId || 1,
      sessionData
    ).run()
    
    return c.json({ success: true })
  } catch (error) {
    console.error('Error saving coaching session:', error)
    return c.json({ success: false, error: 'Failed to save session' }, 500)
  }
})

// AI 코칭 API
app.post('/api/ai/coaching', async (c) => {
  const apiKey = c.env.OPENAI_API_KEY
  const body = await c.req.json()
  
  // 데모 모드: API 키가 없으면 샘플 응답 반환
  if (!apiKey || apiKey === 'your-openai-api-key-here') {
    const lastMessage = body.messages[body.messages.length - 1]
    const demoResponse = `안녕하세요! AI 역량 개발 코치입니다. 

"${lastMessage.content}" 에 대해 말씀드리겠습니다.

역량 개발은 지속적인 과정입니다. 다음과 같은 방법을 추천드립니다:

1. **자기 평가**: 현재 수준을 객관적으로 파악하세요
2. **목표 설정**: SMART 목표를 설정하세요 (구체적, 측정가능, 달성가능, 관련있는, 시한있는)
3. **실천 계획**: 작은 단계부터 시작하여 꾸준히 실행하세요
4. **피드백**: 동료나 상사로부터 정기적인 피드백을 받으세요
5. **학습**: 관련 도서, 강의, 멘토링을 활용하세요

추가로 궁금하신 점이 있으시면 언제든 질문해주세요!

⚙️ 데모 모드: 실제 AI 코칭을 원하시면 .dev.vars 파일에 OpenAI API 키를 설정하세요.`
    
    return c.json({ 
      success: true, 
      message: demoResponse,
      demo: true
    })
  }
  
  try {
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`
      },
      body: JSON.stringify({
        model: 'gpt-4o-mini',
        messages: body.messages,
        temperature: 0.7
      })
    })
    
    if (!response.ok) {
      const error = await response.text()
      return c.json({ success: false, error: `OpenAI API 오류: ${error}` }, 500)
    }
    
    const data = await response.json() as any
    
    return c.json({ 
      success: true, 
      message: data.choices[0].message.content 
    })
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500)
  }
})

// ============================================================================
// Frontend Routes
// ============================================================================

app.get('/', (c) => {
  // CSP 헤더 설정 - unsafe-eval과 unsafe-inline 허용
  c.header('Content-Security-Policy', 
    "default-src 'self'; " +
    "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.tailwindcss.com https://cdn.jsdelivr.net; " +
    "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; " +
    "font-src 'self' https://cdn.jsdelivr.net; " +
    "img-src 'self' data: https:; " +
    "connect-src 'self';"
  )
  
  return c.html(`
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AI 역량 진단 플랫폼</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
        <link href="/static/style.css?v=7" rel="stylesheet">
    </head>
    <body class="bg-gray-50">
        <!-- Navigation -->
        <nav class="bg-white shadow-sm">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-16">
                    <div class="flex items-center">
                        <i class="fas fa-brain text-blue-600 text-2xl mr-3"></i>
                        <h1 class="text-xl font-bold text-gray-800">AI 역량 진단 플랫폼</h1>
                    </div>
                    <div class="flex items-center space-x-4">
                        <button onclick="showTab('assess', this)" class="nav-btn px-4 py-2 rounded-lg hover:bg-blue-50 bg-blue-100 text-blue-700">
                            <i class="fas fa-clipboard-list mr-2"></i>진단 설계
                        </button>
                        <button onclick="showTab('analytics', this)" class="nav-btn px-4 py-2 rounded-lg hover:bg-blue-50">
                            <i class="fas fa-chart-bar mr-2"></i>결과 분석
                        </button>
                        <button onclick="showTab('action', this)" class="nav-btn px-4 py-2 rounded-lg hover:bg-blue-50">
                            <i class="fas fa-rocket mr-2"></i>실행 지원
                        </button>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <!-- ASSESS Tab -->
            <div id="tab-assess" class="tab-content">
                <div class="bg-white rounded-lg shadow p-6 mb-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-4">
                        <i class="fas fa-clipboard-list text-blue-600 mr-2"></i>
                        Phase 1: 진단 설계
                    </h2>
                    
                    <!-- 역량 키워드 검색 -->
                    <div class="mb-6">
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            역량 키워드 검색 및 선택
                        </label>
                        <div class="flex gap-2">
                            <input 
                                type="text" 
                                id="competency-search" 
                                placeholder="예: 커뮤니케이션, 리더십, 전략적사고"
                                class="flex-1 rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                                onkeypress="if(event.key === 'Enter') searchCompetencies()"
                            >
                            <button onclick="searchCompetencies()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                <i class="fas fa-search mr-2"></i>검색
                            </button>
                        </div>
                    </div>

                    <!-- 검색 결과 및 선택된 역량 -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                        <div>
                            <h3 class="text-sm font-medium text-gray-700 mb-2">검색 결과</h3>
                            <div id="search-results" class="border rounded-lg p-4 min-h-[200px] max-h-[300px] overflow-y-auto">
                                <p class="text-gray-400 text-sm">역량을 검색하세요</p>
                            </div>
                        </div>
                        <div>
                            <h3 class="text-sm font-medium text-gray-700 mb-2">선택된 역량</h3>
                            <div id="selected-competencies" class="border rounded-lg p-4 min-h-[200px] max-h-[300px] overflow-y-auto">
                                <p class="text-gray-400 text-sm">역량을 선택하세요</p>
                            </div>
                        </div>
                    </div>

                    <!-- AI 문항 생성 옵션 -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">역량 수준</label>
                            <select id="target-level" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                                <option value="junior">사원급</option>
                                <option value="middle">중간관리자급</option>
                                <option value="manager">팀장급</option>
                                <option value="executive">임원급 이상</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">진단 방식</label>
                            <select id="question-type" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                                <option value="self">자가진단</option>
                                <option value="multi">다면평가</option>
                                <option value="survey">설문조사</option>
                            </select>
                        </div>
                        <div class="flex items-end">
                            <button onclick="generateQuestions()" class="w-full px-4 py-2 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-lg hover:from-blue-700 hover:to-purple-700">
                                <i class="fas fa-magic mr-2"></i>AI 문항 생성
                            </button>
                        </div>
                    </div>

                    <!-- 생성 결과 -->
                    <div id="generation-result" class="hidden">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">생성된 진단 문항</h3>
                        <div id="generation-content" class="bg-gray-50 rounded-lg p-4"></div>
                    </div>
                </div>
                
                <!-- Phase 2: 진단 설정 -->
                <div class="bg-white rounded-lg shadow p-6 mb-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-6">
                        <i class="fas fa-cog text-green-600 mr-2"></i>
                        Phase 2: 진단 설정
                    </h2>
                    
                    <!-- Step 1: 응답자 기본 정보 -->
                    <div id="respondent-info-section" class="mb-8">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">
                            <span class="bg-blue-600 text-white rounded-full w-6 h-6 inline-flex items-center justify-center mr-2 text-sm">1</span>
                            응답자 정보 입력
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">이름 *</label>
                                <input 
                                    type="text" 
                                    id="exec-name" 
                                    placeholder="홍길동"
                                    class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                                    required
                                >
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">이메일 *</label>
                                <input 
                                    type="email" 
                                    id="exec-email" 
                                    placeholder="hong@example.com"
                                    class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                                    required
                                >
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">부서</label>
                                <input 
                                    type="text" 
                                    id="exec-department" 
                                    placeholder="전략기획팀"
                                    class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                                >
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">직급</label>
                                <select id="exec-level" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                                    <option value="junior">사원/대리</option>
                                    <option value="senior">과장/차장</option>
                                    <option value="manager">팀장 이상</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Step 2: 응답 척도 설정 -->
                    <div id="scale-settings-section" class="mb-8">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">
                            <span class="bg-blue-600 text-white rounded-full w-6 h-6 inline-flex items-center justify-center mr-2 text-sm">2</span>
                            응답 척도 설정
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">척도 유형 *</label>
                                <select id="scale-type" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" onchange="updateScaleLabels()">
                                    <option value="single">1점 (O, X)</option>
                                    <option value="3-point">3점 척도</option>
                                    <option value="5-point" selected>5점 척도</option>
                                    <option value="6-point">6점 척도</option>
                                    <option value="7-point">7점 척도</option>
                                    <option value="10-point">10점 척도</option>
                                </select>
                            </div>
                        </div>
                        
                        <!-- 척도 레이블 설정 -->
                        <div id="scale-labels-container" class="bg-gray-50 rounded-lg p-4">
                            <p class="text-sm text-gray-600 mb-3">각 척도 숫자에 대한 의미를 설정하세요</p>
                            <div id="scale-labels-grid" class="grid grid-cols-1 gap-3">
                                <!-- 동적으로 생성됨 -->
                            </div>
                        </div>
                    </div>

                    <!-- Step 3: 진단 문항 디스플레이 설정 -->
                    <div id="display-settings-section" class="mb-8">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">
                            <span class="bg-blue-600 text-white rounded-full w-6 h-6 inline-flex items-center justify-center mr-2 text-sm">3</span>
                            진단 문항 디스플레이 설정
                        </h3>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-3">한 화면에 표시할 문항 수</label>
                            <div class="grid grid-cols-6 md:grid-cols-11 gap-2">
                                <button onclick="setQuestionDisplay(1)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    1개
                                </button>
                                <button onclick="setQuestionDisplay(2)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    2개
                                </button>
                                <button onclick="setQuestionDisplay(3)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    3개
                                </button>
                                <button onclick="setQuestionDisplay(4)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    4개
                                </button>
                                <button onclick="setQuestionDisplay(5)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    5개
                                </button>
                                <button onclick="setQuestionDisplay(6)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    6개
                                </button>
                                <button onclick="setQuestionDisplay(7)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    7개
                                </button>
                                <button onclick="setQuestionDisplay(8)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    8개
                                </button>
                                <button onclick="setQuestionDisplay(9)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    9개
                                </button>
                                <button onclick="setQuestionDisplay(10)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    10개
                                </button>
                                <button onclick="setQuestionDisplay(-1)" class="display-option-btn h-12 bg-white border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-colors font-medium text-gray-700 hover:text-blue-600">
                                    전체
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 진단지 구성하기 버튼 -->
                    <div class="flex justify-center mb-6">
                        <button 
                            id="compose-assessment-btn"
                            onclick="composeAssessment()" 
                            class="px-8 py-3 bg-gradient-to-r from-purple-600 to-blue-600 text-white rounded-lg hover:from-purple-700 hover:to-blue-700 text-lg font-semibold disabled:opacity-50 disabled:cursor-not-allowed" 
                            disabled
                        >
                            <i class="fas fa-file-alt mr-2"></i>진단지 구성하기
                        </button>
                    </div>

                    <!-- 역량 진단하기 영역 -->
                    <div id="assessment-preview" class="hidden mb-6">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">
                            <i class="fas fa-clipboard-check text-green-600 mr-2"></i>역량 진단하기
                        </h3>
                        <div id="preview-content" class="bg-gray-50 rounded-lg p-6 border border-gray-200">
                            <!-- 동적으로 생성됨 -->
                        </div>
                    </div>
                </div>
            </div>

            <!-- ANALYTICS Tab -->
            <div id="tab-analytics" class="tab-content hidden">
                <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-4">
                        <i class="fas fa-chart-bar text-green-600 mr-2"></i>
                        결과 분석
                    </h2>
                    
                    <!-- 응답자 목록 -->
                    <div class="mb-6">
                        <h3 class="text-lg font-semibold text-gray-800 mb-3">응답자 목록</h3>
                        <div id="respondents-list" class="space-y-2">
                            <p class="text-gray-400 text-sm">로딩 중...</p>
                        </div>
                    </div>
                    
                    <!-- 결과 리포트 영역 -->
                    <div id="analysis-report" class="hidden"></div>
                </div>
            </div>

            <!-- ACTION Tab -->
            <div id="tab-action" class="tab-content hidden">
                <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-6">
                        <i class="fas fa-rocket text-orange-600 mr-2"></i>
                        실행 지원
                    </h2>
                    
                    <!-- AI 어시스턴트 선택 -->
                    <div id="assistant-selection" class="mb-6">
                        <p class="text-gray-600 mb-4">원하시는 AI 어시스턴트를 선택하여 대화를 시작하세요</p>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                            <!-- AI 컨설팅 -->
                            <button onclick="selectAssistant('consulting')" class="assistant-card group p-6 bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-200 rounded-xl hover:shadow-lg transition-all duration-300 hover:scale-105">
                                <div class="text-center">
                                    <div class="w-16 h-16 bg-blue-600 rounded-full flex items-center justify-center mx-auto mb-3 group-hover:scale-110 transition-transform">
                                        <i class="fas fa-briefcase text-white text-2xl"></i>
                                    </div>
                                    <h3 class="font-bold text-gray-800 mb-2">AI 컨설팅</h3>
                                    <p class="text-sm text-gray-600">전략적 관점에서 조직 역량 개발 방향 제시</p>
                                </div>
                            </button>
                            
                            <!-- AI 코칭 -->
                            <button onclick="selectAssistant('coaching')" class="assistant-card group p-6 bg-gradient-to-br from-green-50 to-green-100 border-2 border-green-200 rounded-xl hover:shadow-lg transition-all duration-300 hover:scale-105">
                                <div class="text-center">
                                    <div class="w-16 h-16 bg-green-600 rounded-full flex items-center justify-center mx-auto mb-3 group-hover:scale-110 transition-transform">
                                        <i class="fas fa-comments text-white text-2xl"></i>
                                    </div>
                                    <h3 class="font-bold text-gray-800 mb-2">AI 코칭</h3>
                                    <p class="text-sm text-gray-600">질문과 대화를 통한 자기주도적 역량 개발</p>
                                </div>
                            </button>
                            
                            <!-- AI 멘토링 -->
                            <button onclick="selectAssistant('mentoring')" class="assistant-card group p-6 bg-gradient-to-br from-purple-50 to-purple-100 border-2 border-purple-200 rounded-xl hover:shadow-lg transition-all duration-300 hover:scale-105">
                                <div class="text-center">
                                    <div class="w-16 h-16 bg-purple-600 rounded-full flex items-center justify-center mx-auto mb-3 group-hover:scale-110 transition-transform">
                                        <i class="fas fa-user-tie text-white text-2xl"></i>
                                    </div>
                                    <h3 class="font-bold text-gray-800 mb-2">AI 멘토링</h3>
                                    <p class="text-sm text-gray-600">경험 공유와 실무 조언으로 성장 가속화</p>
                                </div>
                            </button>
                            
                            <!-- AI 티칭 -->
                            <button onclick="selectAssistant('teaching')" class="assistant-card group p-6 bg-gradient-to-br from-orange-50 to-orange-100 border-2 border-orange-200 rounded-xl hover:shadow-lg transition-all duration-300 hover:scale-105">
                                <div class="text-center">
                                    <div class="w-16 h-16 bg-orange-600 rounded-full flex items-center justify-center mx-auto mb-3 group-hover:scale-110 transition-transform">
                                        <i class="fas fa-chalkboard-teacher text-white text-2xl"></i>
                                    </div>
                                    <h3 class="font-bold text-gray-800 mb-2">AI 티칭</h3>
                                    <p class="text-sm text-gray-600">체계적인 학습과 실습으로 역량 강화</p>
                                </div>
                            </button>
                        </div>
                    </div>
                    
                    <!-- 대화 영역 (초기 숨김) -->
                    <div id="chat-area" class="hidden">
                        <!-- 선택된 어시스턴트 헤더 -->
                        <div id="assistant-header" class="bg-gradient-to-r from-blue-600 to-blue-700 rounded-t-xl p-4 flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <div id="assistant-avatar" class="w-12 h-12 bg-white rounded-full flex items-center justify-center">
                                    <i class="fas fa-robot text-blue-600 text-xl"></i>
                                </div>
                                <div>
                                    <h3 id="assistant-name" class="font-bold text-white text-lg">AI 어시스턴트</h3>
                                    <p id="assistant-status" class="text-blue-100 text-sm">온라인</p>
                                </div>
                            </div>
                            <button onclick="resetAssistant()" class="text-white hover:bg-white/20 rounded-lg px-3 py-2 transition-colors">
                                <i class="fas fa-times mr-1"></i>다른 어시스턴트 선택
                            </button>
                        </div>
                        
                        <!-- 채팅 컨테이너 -->
                        <div id="chat-container" class="border-x border-gray-300 p-6 h-[500px] overflow-y-auto bg-gray-50">
                            <div class="text-gray-500 text-sm text-center py-8">
                                대화를 시작하세요
                            </div>
                        </div>
                        
                        <!-- 입력 영역 -->
                        <div class="bg-white border border-gray-300 rounded-b-xl p-4">
                            <div class="flex gap-3">
                                <input 
                                    type="text" 
                                    id="chat-input" 
                                    placeholder="메시지를 입력하세요..."
                                    class="flex-1 rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 px-4 py-3"
                                    onkeypress="if(event.key === 'Enter') sendChatMessage()"
                                >
                                <button onclick="sendChatMessage()" class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors shadow-lg hover:shadow-xl">
                                    <i class="fas fa-paper-plane mr-2"></i>전송
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/axios@1.6.0/dist/axios.min.js"></script>
        <script src="/static/app.js?v=25"></script>
    </body>
    </html>
  `)
})

export default app
