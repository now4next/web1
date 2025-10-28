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
  const db = c.env.DB
  const { results } = await db.prepare(`
    SELECT * FROM competency_models ORDER BY created_at DESC
  `).all()
  return c.json({ success: true, data: results })
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
  const db = c.env.DB
  const query = c.req.query('q') || ''
  
  const { results } = await db.prepare(`
    SELECT c.*, cm.name as model_name, cm.type as model_type
    FROM competencies c
    JOIN competency_models cm ON c.model_id = cm.id
    WHERE c.keyword LIKE ? OR c.description LIKE ?
    ORDER BY c.created_at DESC
  `).bind(`%${query}%`, `%${query}%`).all()
  
  return c.json({ success: true, data: results })
})

// 특정 모델의 역량 키워드 조회
app.get('/api/competencies/:modelId', async (c) => {
  const db = c.env.DB
  const modelId = c.req.param('modelId')
  
  const { results } = await db.prepare(`
    SELECT c.*, cm.name as model_name, cm.type as model_type
    FROM competencies c
    JOIN competency_models cm ON c.model_id = cm.id
    WHERE c.model_id = ?
    ORDER BY c.created_at DESC
  `).bind(modelId).all()
  
  return c.json({ success: true, data: results })
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
app.post('/api/analysis/:respondentId/insights', async (c) => {
  const apiKey = c.env.OPENAI_API_KEY
  const respondentId = c.req.param('respondentId')
  const body = await c.req.json()
  
  // 데모 모드 또는 실제 AI 사용
  if (!apiKey || apiKey === 'your-openai-api-key-here') {
    // 데모 인사이트
    const demoInsights = {
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
    return c.json({ success: true, insights: demoInsights, demo: true })
  }
  
  // 실제 AI 인사이트 생성
  const prompt = `당신은 조직 역량 진단 전문가입니다. 다음 진단 결과를 분석하고 인사이트를 제공해주세요.

응답자: ${body.respondent.name} (${body.respondent.position})
전체 평균: ${body.summary.overallAverage}점
강점 역량: ${body.summary.strengths.join(', ')}
개선 영역: ${body.summary.improvements.join(', ')}

역량별 상세:
${body.analysis.map((a: any) => `- ${a.competency}: ${a.average}점 (${a.count}개 문항)`).join('\n')}

다음 항목에 대해 구체적이고 실용적인 인사이트를 제공해주세요:
1. overall: 전반적인 역량 수준 평가
2. strengths: 강점 역량 분석 및 활용 방안
3. improvements: 개선 영역 분석 및 발전 방향
4. recommendations: 구체적인 실행 가능한 추천사항 (배열)

JSON 형식으로 응답해주세요.`

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
    const insights = JSON.parse(data.choices[0].message.content)
    
    return c.json({ success: true, insights, demo: false })
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500)
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
  return c.html(`
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AI 역량 진단 플랫폼</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        <link href="/static/style.css?v=2" rel="stylesheet">
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
                        <button onclick="showTab('assess')" class="nav-btn px-4 py-2 rounded-lg hover:bg-blue-50">
                            <i class="fas fa-clipboard-list mr-2"></i>진단 설계
                        </button>
                        <button onclick="showTab('execute')" class="nav-btn px-4 py-2 rounded-lg hover:bg-blue-50">
                            <i class="fas fa-pen-to-square mr-2"></i>진단 실행
                        </button>
                        <button onclick="showTab('analytics')" class="nav-btn px-4 py-2 rounded-lg hover:bg-blue-50">
                            <i class="fas fa-chart-bar mr-2"></i>분석
                        </button>
                        <button onclick="showTab('action')" class="nav-btn px-4 py-2 rounded-lg hover:bg-blue-50">
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
                        Phase 1: 진단 설계 및 실행
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
                            <label class="block text-sm font-medium text-gray-700 mb-2">대상 직급</label>
                            <select id="target-level" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                                <option value="all">전체</option>
                                <option value="junior">사원/대리</option>
                                <option value="senior">과장/차장</option>
                                <option value="manager">팀장 이상</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">진단 유형</label>
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
            </div>

            <!-- EXECUTE Tab (진단 실행) -->
            <div id="tab-execute" class="tab-content hidden">
                <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-6">
                        <i class="fas fa-pen-to-square text-purple-600 mr-2"></i>
                        진단 실행
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
                                <label class="block text-sm font-medium text-gray-700 mb-2">직위</label>
                                <input 
                                    type="text" 
                                    id="exec-position" 
                                    placeholder="과장"
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

                    <!-- Step 2: 진단 문항 디스플레이 설정 -->
                    <div id="display-settings-section" class="mb-8">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">
                            <span class="bg-blue-600 text-white rounded-full w-6 h-6 inline-flex items-center justify-center mr-2 text-sm">2</span>
                            진단 문항 디스플레이 설정
                        </h3>
                        <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-4">
                            <div class="flex items-start">
                                <i class="fas fa-info-circle text-blue-600 mt-1 mr-3"></i>
                                <div>
                                    <p class="text-sm text-blue-800 mb-2">
                                        <strong>한 화면에 표시할 문항 수를 선택하세요</strong>
                                    </p>
                                    <ul class="text-xs text-blue-700 space-y-1">
                                        <li>• <strong>1개씩</strong>: 집중력 향상, 한 문항씩 신중하게 응답</li>
                                        <li>• <strong>5개씩</strong>: 적절한 속도감, 역량별 그룹 단위 응답</li>
                                        <li>• <strong>10개씩</strong>: 빠른 진행, 여러 문항 비교하며 응답</li>
                                        <li>• <strong>전체</strong>: 모든 문항을 한눈에 보고 응답</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
                            <button onclick="setQuestionDisplay(1)" class="display-btn px-4 py-3 border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-all">
                                <div class="text-center">
                                    <div class="text-2xl font-bold text-gray-700">1개씩</div>
                                    <div class="text-xs text-gray-500 mt-1">집중 모드</div>
                                </div>
                            </button>
                            <button onclick="setQuestionDisplay(5)" class="display-btn px-4 py-3 border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-all">
                                <div class="text-center">
                                    <div class="text-2xl font-bold text-gray-700">5개씩</div>
                                    <div class="text-xs text-gray-500 mt-1">표준 모드</div>
                                </div>
                            </button>
                            <button onclick="setQuestionDisplay(10)" class="display-btn px-4 py-3 border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-all">
                                <div class="text-center">
                                    <div class="text-2xl font-bold text-gray-700">10개씩</div>
                                    <div class="text-xs text-gray-500 mt-1">빠른 모드</div>
                                </div>
                            </button>
                            <button onclick="setQuestionDisplay(-1)" class="display-btn px-4 py-3 border-2 border-gray-300 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition-all">
                                <div class="text-center">
                                    <div class="text-2xl font-bold text-gray-700">전체</div>
                                    <div class="text-xs text-gray-500 mt-1">전체 보기</div>
                                </div>
                            </button>
                        </div>
                        
                        <div id="selected-display" class="mt-4 text-center text-sm text-gray-600">
                            선택된 디스플레이: <span class="font-semibold text-blue-600">미선택</span>
                        </div>
                    </div>

                    <!-- Step 3: 진단 시작 버튼 -->
                    <div class="flex justify-center">
                        <button onclick="startAssessment()" class="px-8 py-3 bg-gradient-to-r from-blue-600 to-purple-600 text-white text-lg rounded-lg hover:from-blue-700 hover:to-purple-700 shadow-lg disabled:opacity-50 disabled:cursor-not-allowed" disabled id="start-assessment-btn">
                            <i class="fas fa-play mr-2"></i>진단 시작
                        </button>
                    </div>

                    <!-- 진단 문항 영역 (동적 생성) -->
                    <div id="assessment-questions-area" class="mt-8 hidden">
                        <div class="border-t pt-6">
                            <div class="flex justify-between items-center mb-6">
                                <h3 class="text-lg font-semibold text-gray-800">
                                    진단 문항
                                </h3>
                                <div class="text-sm text-gray-600">
                                    <span id="current-progress">0</span> / <span id="total-questions">0</span> 문항
                                </div>
                            </div>
                            
                            <!-- 문항 컨테이너 -->
                            <div id="questions-container" class="space-y-6">
                                <!-- 동적으로 생성됨 -->
                            </div>

                            <!-- 네비게이션 버튼 -->
                            <div class="flex justify-between mt-8">
                                <button onclick="previousPage()" id="prev-btn" class="px-6 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed" disabled>
                                    <i class="fas fa-chevron-left mr-2"></i>이전
                                </button>
                                <button onclick="nextPage()" id="next-btn" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed">
                                    다음<i class="fas fa-chevron-right ml-2"></i>
                                </button>
                                <button onclick="submitAssessment()" id="submit-btn" class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 hidden">
                                    <i class="fas fa-check mr-2"></i>제출하기
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ANALYTICS Tab -->
            <div id="tab-analytics" class="tab-content hidden">
                <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-4">
                        <i class="fas fa-chart-bar text-green-600 mr-2"></i>
                        Phase 2: 분석 및 인사이트
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
                    <h2 class="text-2xl font-bold text-gray-800 mb-4">
                        <i class="fas fa-rocket text-orange-600 mr-2"></i>
                        Phase 3: AI 실행 지원
                    </h2>
                    
                    <!-- AI 코칭 챗봇 -->
                    <div class="mb-6">
                        <h3 class="text-lg font-semibold text-gray-800 mb-3">
                            <i class="fas fa-comments text-blue-600 mr-2"></i>AI 코칭
                        </h3>
                        <div id="chat-container" class="border rounded-lg p-4 mb-4 h-[400px] overflow-y-auto bg-gray-50">
                            <div class="text-gray-500 text-sm text-center py-8">
                                역량 진단 결과에 대해 AI 코치와 대화를 시작하세요
                            </div>
                        </div>
                        <div class="flex gap-2">
                            <input 
                                type="text" 
                                id="chat-input" 
                                placeholder="질문을 입력하세요..."
                                class="flex-1 rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                                onkeypress="if(event.key === 'Enter') sendChatMessage()"
                            >
                            <button onclick="sendChatMessage()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/axios@1.6.0/dist/axios.min.js"></script>
        <script src="/static/app.js?v=2"></script>
    </body>
    </html>
  `)
})

export default app
