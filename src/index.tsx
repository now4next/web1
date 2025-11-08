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
    
    // Search across competencies, jobs, and behavioral_indicators
    // Use DISTINCT to avoid duplicate results when multiple indicators match
    const { results } = await db.prepare(`
      SELECT DISTINCT 
        c.id,
        c.name as keyword,
        c.definition as description,
        c.job_id,
        j.name as job_name,
        j.description as job_description,
        c.created_at
      FROM competencies c
      JOIN jobs j ON c.job_id = j.id
      LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
      WHERE c.name LIKE ? 
        OR c.definition LIKE ? 
        OR j.name LIKE ?
        OR j.description LIKE ?
        OR bi.indicator_text LIKE ?
      ORDER BY c.sort_order ASC, c.created_at DESC
    `).bind(`%${query}%`, `%${query}%`, `%${query}%`, `%${query}%`, `%${query}%`).all()
    
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
        SELECT id FROM competencies WHERE name = ? LIMIT 1
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
          `${keyword} 관련 업무를 체계적으로 수행한다`,
          `${keyword}을 활용하여 팀 목표 달성에 기여한다`,
          `${keyword} 역량을 지속적으로 개발하고 향상시킨다`
        ]
      })),
      questions: body.competency_keywords.flatMap(keyword => [
        {
          competency: keyword,
          question_text: `나는 ${keyword} 역량을 효과적으로 발휘하고 있다`,
          question_type: body.question_type
        },
        {
          competency: keyword,
          question_text: `나는 ${keyword}과 관련된 업무를 자신있게 수행할 수 있다`,
          question_type: body.question_type
        },
        {
          competency: keyword,
          question_text: `나는 ${keyword} 역량 개발을 위해 지속적으로 노력한다`,
          question_type: body.question_type
        },
        {
          competency: keyword,
          question_text: `나는 ${keyword}을 업무에 적극적으로 활용하고 있다`,
          question_type: body.question_type
        },
        {
          competency: keyword,
          question_text: `나는 ${keyword}에 대한 전문성을 갖추고 있다`,
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

⚠️ 중요: "competency" 필드에는 반드시 위의 역량 키워드를 정확히 그대로 사용하세요. 절대 변형하지 마세요.
예시: "리더십" → "리더십" (O), "전략적 리더십" (X), "Leadership" (X)

📋 진단 문항 작성 가이드라인:
1. **서술문 종결형으로 작성**: 질문형(~합니까?, ~하는가?)이 아닌 평서문 형태로 작성
2. **종결 표현**: "~한다", "~하고 있다", "~할 수 있다", "~노력한다", "~이해하고 있다" 등 사용
3. **자기 역량 측정**: 응답자 자신이 해당 역량을 보유하고 있거나 발휘하고 있는지 확인하는 내용
4. **1인칭 관점**: "나는 ~한다", "나는 ~하고 있다", "나는 ~할 수 있다" 형식 사용

✅ 좋은 예시:
- "나는 팀원들과 효과적으로 소통하고 있다"
- "나는 복잡한 문제를 논리적으로 분석할 수 있다"
- "나는 목표 달성을 위해 체계적으로 계획을 수립한다"
- "나는 새로운 기술을 학습하기 위해 지속적으로 노력한다"
- "나는 업무의 우선순위를 명확히 이해하고 있다"

❌ 나쁜 예시:
- "팀원들과 효과적으로 소통합니까?" (질문형)
- "복잡한 문제를 논리적으로 분석하는가?" (질문형)
- "목표 달성을 위한 계획을 수립해야 한다" (당위형)

각 역량마다 다음을 생성해주세요:
1. 행동 지표 (Behavioral Indicators) 3개
2. 진단 문항 5개 (반드시 위 가이드라인을 따를 것)

응답 형식 (JSON):
{
  "behavioral_indicators": [
    {
      "competency": "역량명 (입력된 키워드 그대로)",
      "indicators": ["지표1", "지표2", "지표3"]
    }
  ],
  "questions": [
    {
      "competency": "역량명 (입력된 키워드 그대로)",
      "question_text": "나는 ~한다/하고 있다/할 수 있다 형식의 서술문",
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
    
    // 🔧 AI가 생성한 역량명을 입력된 키워드로 강제 정규화
    const keywordMap = new Map()
    for (const keyword of body.competency_keywords) {
      keywordMap.set(keyword.toLowerCase().trim(), keyword)
    }
    
    // Behavioral indicators 정규화
    if (content.behavioral_indicators) {
      for (const item of content.behavioral_indicators) {
        const normalized = keywordMap.get(item.competency.toLowerCase().trim())
        if (normalized) {
          item.competency = normalized
        } else {
          console.warn(`AI generated unknown competency: ${item.competency}`)
        }
      }
    }
    
    // Questions 정규화
    if (content.questions) {
      for (const question of content.questions) {
        const normalized = keywordMap.get(question.competency.toLowerCase().trim())
        if (normalized) {
          question.competency = normalized
        } else {
          console.warn(`AI generated unknown competency: ${question.competency}`)
        }
      }
    }
    
    // DB에 저장 (있으면)
    if (db) {
      try {
        for (const behavioralItem of content.behavioral_indicators || []) {
          // 역량 ID 조회
          const { results: compResults } = await db.prepare(`
            SELECT id FROM competencies WHERE name = ? LIMIT 1
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
            SELECT id FROM competencies WHERE name = ? LIMIT 1
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

// ==================== 사용자 인증 API ====================

// 회원가입 (간단한 정보만 입력)
app.post('/api/auth/signup', async (c) => {
  const db = c.env.DB
  
  if (!db) {
    return c.json({ success: false, error: 'Database not configured' }, 500)
  }
  
  try {
    const body = await c.req.json()
    const { name, email, position, organization } = body
    
    // 입력 검증
    if (!name || !email) {
      return c.json({ success: false, error: '이름과 이메일은 필수입니다.' }, 400)
    }
    
    // 이메일 중복 체크
    const { results: existingUsers } = await db.prepare(`
      SELECT id FROM users WHERE email = ? LIMIT 1
    `).bind(email).all()
    
    if (existingUsers && existingUsers.length > 0) {
      return c.json({ success: false, error: '이미 등록된 이메일입니다.' }, 400)
    }
    
    // 사용자 생성
    const result = await db.prepare(`
      INSERT INTO users (name, email, position, organization, created_at, updated_at)
      VALUES (?, ?, ?, ?, datetime('now'), datetime('now'))
    `).bind(name, email, position || null, organization || null).run()
    
    const userId = result.meta.last_row_id
    
    // 세션 토큰 생성 (간단한 랜덤 토큰)
    const sessionToken = `session_${Date.now()}_${Math.random().toString(36).substring(2)}`
    const expiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString() // 30일
    
    await db.prepare(`
      INSERT INTO user_sessions (user_id, session_token, expires_at, created_at)
      VALUES (?, ?, ?, datetime('now'))
    `).bind(userId, sessionToken, expiresAt).run()
    
    // 마지막 로그인 시간 업데이트
    await db.prepare(`
      UPDATE users SET last_login_at = datetime('now') WHERE id = ?
    `).bind(userId).run()
    
    return c.json({ 
      success: true, 
      data: {
        user: { id: userId, name, email, position, organization },
        sessionToken
      }
    })
  } catch (error: any) {
    console.error('Signup error:', error)
    return c.json({ success: false, error: error.message }, 500)
  }
})

// 로그인 (이메일만으로 간단 로그인)
app.post('/api/auth/login', async (c) => {
  const db = c.env.DB
  
  if (!db) {
    return c.json({ success: false, error: 'Database not configured' }, 500)
  }
  
  try {
    const body = await c.req.json()
    const { email } = body
    
    if (!email) {
      return c.json({ success: false, error: '이메일을 입력하세요.' }, 400)
    }
    
    // 사용자 조회
    const { results: users } = await db.prepare(`
      SELECT id, name, email, position, organization, status
      FROM users 
      WHERE email = ? AND status = 'active'
      LIMIT 1
    `).bind(email).all()
    
    if (!users || users.length === 0) {
      return c.json({ success: false, error: '등록되지 않은 이메일입니다.' }, 404)
    }
    
    const user = users[0]
    
    // 기존 세션 삭제 (선택적)
    await db.prepare(`
      DELETE FROM user_sessions WHERE user_id = ? AND expires_at < datetime('now')
    `).bind(user.id).run()
    
    // 새 세션 토큰 생성
    const sessionToken = `session_${Date.now()}_${Math.random().toString(36).substring(2)}`
    const expiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString()
    
    await db.prepare(`
      INSERT INTO user_sessions (user_id, session_token, expires_at, created_at)
      VALUES (?, ?, ?, datetime('now'))
    `).bind(user.id, sessionToken, expiresAt).run()
    
    // 마지막 로그인 시간 업데이트
    await db.prepare(`
      UPDATE users SET last_login_at = datetime('now') WHERE id = ?
    `).bind(user.id).run()
    
    return c.json({ 
      success: true, 
      data: {
        user,
        sessionToken
      }
    })
  } catch (error: any) {
    console.error('Login error:', error)
    return c.json({ success: false, error: error.message }, 500)
  }
})

// 세션 확인 (로그인 체크)
app.get('/api/auth/me', async (c) => {
  const db = c.env.DB
  
  if (!db) {
    return c.json({ success: false, error: 'Database not configured' }, 500)
  }
  
  try {
    const authHeader = c.req.header('Authorization')
    const sessionToken = authHeader?.replace('Bearer ', '')
    
    if (!sessionToken) {
      return c.json({ success: false, error: 'No session token' }, 401)
    }
    
    // 세션 조회
    const { results: sessions } = await db.prepare(`
      SELECT 
        s.user_id,
        s.expires_at,
        u.id,
        u.name,
        u.email,
        u.position,
        u.organization,
        u.status
      FROM user_sessions s
      JOIN users u ON s.user_id = u.id
      WHERE s.session_token = ? AND s.expires_at > datetime('now')
      LIMIT 1
    `).bind(sessionToken).all()
    
    if (!sessions || sessions.length === 0) {
      return c.json({ success: false, error: 'Invalid or expired session' }, 401)
    }
    
    const user = {
      id: sessions[0].id,
      name: sessions[0].name,
      email: sessions[0].email,
      position: sessions[0].position,
      organization: sessions[0].organization,
      status: sessions[0].status
    }
    
    return c.json({ success: true, data: { user } })
  } catch (error: any) {
    console.error('Session check error:', error)
    return c.json({ success: false, error: error.message }, 500)
  }
})

// 로그아웃
app.post('/api/auth/logout', async (c) => {
  const db = c.env.DB
  
  if (!db) {
    return c.json({ success: false, error: 'Database not configured' }, 500)
  }
  
  try {
    const authHeader = c.req.header('Authorization')
    const sessionToken = authHeader?.replace('Bearer ', '')
    
    if (sessionToken) {
      await db.prepare(`
        DELETE FROM user_sessions WHERE session_token = ?
      `).bind(sessionToken).run()
    }
    
    return c.json({ success: true })
  } catch (error: any) {
    console.error('Logout error:', error)
    return c.json({ success: false, error: error.message }, 500)
  }
})

// 프로필 업데이트
app.put('/api/auth/profile', async (c) => {
  const db = c.env.DB
  
  if (!db) {
    return c.json({ success: false, error: 'Database not configured' }, 500)
  }
  
  try {
    const authHeader = c.req.header('Authorization')
    const sessionToken = authHeader?.replace('Bearer ', '')
    
    if (!sessionToken) {
      return c.json({ success: false, error: 'No session token' }, 401)
    }
    
    // 세션으로 사용자 ID 조회
    const { results: sessions } = await db.prepare(`
      SELECT user_id FROM user_sessions 
      WHERE session_token = ? AND expires_at > datetime('now')
      LIMIT 1
    `).bind(sessionToken).all()
    
    if (!sessions || sessions.length === 0) {
      return c.json({ success: false, error: 'Invalid or expired session' }, 401)
    }
    
    const userId = sessions[0].user_id
    const body = await c.req.json()
    const { name, position, organization } = body
    
    // 입력 검증
    if (!name) {
      return c.json({ success: false, error: '이름은 필수입니다.' }, 400)
    }
    
    // 사용자 정보 업데이트
    await db.prepare(`
      UPDATE users 
      SET name = ?, 
          position = ?, 
          organization = ?, 
          updated_at = datetime('now')
      WHERE id = ?
    `).bind(name, position || null, organization || null, userId).run()
    
    // 업데이트된 사용자 정보 반환
    const { results: users } = await db.prepare(`
      SELECT id, name, email, position, organization, status
      FROM users 
      WHERE id = ?
      LIMIT 1
    `).bind(userId).all()
    
    return c.json({ 
      success: true, 
      data: { user: users[0] }
    })
  } catch (error: any) {
    console.error('Profile update error:', error)
    return c.json({ success: false, error: error.message }, 500)
  }
})

// 회원탈퇴
app.delete('/api/auth/account', async (c) => {
  const db = c.env.DB
  
  if (!db) {
    return c.json({ success: false, error: 'Database not configured' }, 500)
  }
  
  try {
    const authHeader = c.req.header('Authorization')
    const sessionToken = authHeader?.replace('Bearer ', '')
    
    if (!sessionToken) {
      return c.json({ success: false, error: 'No session token' }, 401)
    }
    
    // 세션으로 사용자 ID 조회
    const { results: sessions } = await db.prepare(`
      SELECT user_id FROM user_sessions 
      WHERE session_token = ? AND expires_at > datetime('now')
      LIMIT 1
    `).bind(sessionToken).all()
    
    if (!sessions || sessions.length === 0) {
      return c.json({ success: false, error: 'Invalid or expired session' }, 401)
    }
    
    const userId = sessions[0].user_id
    
    // 사용자 상태를 'deleted'로 변경 (실제 삭제 대신 소프트 삭제)
    await db.prepare(`
      UPDATE users 
      SET status = 'deleted', 
          updated_at = datetime('now')
      WHERE id = ?
    `).bind(userId).run()
    
    // 모든 세션 삭제
    await db.prepare(`
      DELETE FROM user_sessions WHERE user_id = ?
    `).bind(userId).run()
    
    return c.json({ 
      success: true,
      message: '회원탈퇴가 완료되었습니다.'
    })
  } catch (error: any) {
    console.error('Account deletion error:', error)
    return c.json({ success: false, error: error.message }, 500)
  }
})

// ==================== 진단 세션 API ====================

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
      c.name as competency,
      c.definition as competency_description,
      cm.name as model_name
    FROM assessment_questions aq
    JOIN competencies c ON aq.competency_id = c.id
    JOIN competency_models cm ON c.model_id = cm.id
    ORDER BY cm.name, c.name, aq.id
  `).all()
  
  return c.json({ success: true, data: results, count: results.length })
})

// 문항 저장 (키워드 기반)
app.post('/api/assessment-questions-save', async (c) => {
  const db = c.env.DB
  const body = await c.req.json()
  
  // 역량 키워드로 competency_id 찾기
  const competency = await db.prepare(`
    SELECT id FROM competencies WHERE name = ?
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
        SELECT id FROM competencies WHERE name = ?
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
          respondentInfo.level || respondentInfo.position || ''  // level 우선, 없으면 position 사용
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
        // 역량으로 competency_id 찾기 (정확한 매칭)
        let competency = await db.prepare(`
          SELECT id FROM competencies WHERE name = ?
        `).bind(resp.competency).first()
        
        // 찾지 못하면 대소문자 무시하고 재시도
        if (!competency) {
          competency = await db.prepare(`
            SELECT id FROM competencies 
            WHERE LOWER(TRIM(name)) = LOWER(TRIM(?))
          `).bind(resp.competency).first()
        }
        
        // 여전히 못 찾으면 공백 완전 제거 후 매칭
        if (!competency) {
          const normalizedInput = resp.competency.replace(/\s+/g, '').toLowerCase()
          const allCompetencies = await db.prepare(`
            SELECT id, name FROM competencies
          `).all()
          
          for (const comp of allCompetencies.results || []) {
            const normalizedName = comp.name.replace(/\s+/g, '').toLowerCase()
            if (normalizedName === normalizedInput) {
              competency = comp
              console.log(`Matched "${resp.competency}" to "${comp.name}" (space-insensitive)`)
              break
            }
          }
        }
        
        // 여전히 못 찾으면 유사한 키워드 검색
        if (!competency) {
          const similar = await db.prepare(`
            SELECT id, name FROM competencies 
            WHERE name LIKE ?
            LIMIT 5
          `).bind(`%${resp.competency}%`).all()
          
          console.error(`❌ Competency NOT FOUND: "${resp.competency}"`)
          console.error(`📊 Similar competencies in DB:`, similar.results?.map((c: any) => c.name))
          console.error(`📋 Full response data:`, {
            competency: resp.competency,
            question_text: resp.question_text,
            competency_length: resp.competency.length,
            competency_charCodes: Array.from(resp.competency).map(c => c.charCodeAt(0))
          })
          
          return c.json({ 
            success: false, 
            error: `COMPETENCY_NOT_FOUND`,
            competency: resp.competency,
            message: `❌ 역량을 찾을 수 없습니다: "${resp.competency}"\n\n이 역량이 데이터베이스에 존재하지 않습니다.\n\n유사한 역량:\n${similar.results?.map((c: any) => `- ${c.name}`).join('\n') || '없음'}\n\n💡 해결방법:\n1. 브라우저 Console(F12)을 열어주세요\n2. 다음 명령어를 실행하세요:\n   console.log(assessmentQuestions.map(q => q.competency))\n3. 결과를 개발자에게 전달해주세요`,
            similar_keywords: similar.results?.map((c: any) => c.name) || [],
            debug: {
              competency_length: resp.competency.length,
              has_whitespace: /\s/.test(resp.competency),
              normalized: resp.competency.replace(/\s+/g, '').toLowerCase()
            }
          }, 400)
        }
        
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
    
    // 4. 세션에 사용된 역량 저장 (session_competencies)
    const uniqueCompetencies = new Set<number>()
    for (const resp of responses) {
      // 역량으로 competency_id 찾기
      const competency = await db.prepare(`
        SELECT id FROM competencies WHERE name = ?
      `).bind(resp.competency).first()
      
      if (competency) {
        uniqueCompetencies.add(competency.id as number)
      }
    }
    
    // session_competencies 테이블에 저장 (중복 방지)
    for (const competencyId of uniqueCompetencies) {
      // 이미 존재하는지 확인
      const existing = await db.prepare(`
        SELECT id FROM session_competencies 
        WHERE session_id = ? AND competency_id = ?
      `).bind(sessionId, competencyId).first()
      
      if (!existing) {
        await db.prepare(`
          INSERT INTO session_competencies (session_id, competency_id)
          VALUES (?, ?)
        `).bind(sessionId, competencyId).run()
      }
    }
    
    return c.json({ 
      success: true, 
      session_id: sessionId,
      respondent_id: respondentId,
      saved_count: savedResponses.length,
      competencies_saved: uniqueCompetencies.size,
      message: '진단이 성공적으로 제출되었습니다!'
    })
  } catch (error: any) {
    console.error('Submit assessment error:', error)
    
    // 외래키 제약 조건 오류 감지
    if (error.message && error.message.includes('FOREIGN KEY constraint failed')) {
      return c.json({ 
        success: false, 
        error: 'FOREIGN_KEY_ERROR',
        message: '선택한 역량이 데이터베이스에 존재하지 않습니다. 역량 목록을 새로고침해주세요.',
        detail: error.message
      }, 400)
    }
    
    return c.json({ 
      success: false, 
      error: error.message || 'Unknown error',
      message: '진단 제출 중 오류가 발생했습니다.'
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

// 로그인한 사용자의 진단 결과 목록 (인증 필요)
app.get('/api/my-assessments', async (c) => {
  const db = c.env.DB
  const authHeader = c.req.header('Authorization')
  
  if (!authHeader) {
    return c.json({ success: false, error: '인증이 필요합니다' }, 401)
  }
  
  const sessionToken = authHeader.replace('Bearer ', '')
  
  // 세션 확인
  const session = await db.prepare(`
    SELECT user_id FROM user_sessions 
    WHERE session_token = ? AND datetime(expires_at) > datetime('now')
  `).bind(sessionToken).first()
  
  if (!session) {
    return c.json({ success: false, error: '유효하지 않은 세션입니다' }, 401)
  }
  
  // 사용자 정보
  const user = await db.prepare(`
    SELECT * FROM users WHERE id = ?
  `).bind(session.user_id).first()
  
  if (!user) {
    return c.json({ success: false, error: '사용자를 찾을 수 없습니다' }, 404)
  }
  
  // 해당 사용자의 진단 세션 목록 (이메일 기반)
  const { results: assessments } = await db.prepare(`
    SELECT 
      ase.id as session_id,
      ase.session_name,
      ase.session_type,
      ase.target_level,
      ase.status,
      ase.start_date,
      ase.created_at,
      r.id as respondent_id,
      r.name as respondent_name,
      r.email,
      r.department,
      r.position,
      COUNT(DISTINCT ar.id) as response_count,
      COUNT(DISTINCT ar.question_id) as question_count
    FROM assessment_sessions ase
    LEFT JOIN assessment_responses ar ON ase.id = ar.session_id
    LEFT JOIN respondents r ON ar.respondent_id = r.id
    WHERE r.email = ?
    GROUP BY ase.id
    ORDER BY ase.created_at DESC
  `).bind(user.email).all()
  
  // 각 진단 세션의 역량 정보 가져오기
  for (const assessment of assessments) {
    const { results: competencies } = await db.prepare(`
      SELECT c.name
      FROM session_competencies sc
      JOIN competencies c ON sc.competency_id = c.id
      WHERE sc.session_id = ?
      ORDER BY c.name
    `).bind(assessment.session_id).all()
    
    assessment.competencies = competencies.map(c => c.name)
  }
  
  return c.json({ 
    success: true, 
    data: assessments,
    user: {
      name: user.name,
      email: user.email
    }
  })
})

// 진단 결과 삭제 (본인 결과만 삭제 가능) - 개별 진단 세션 삭제
app.delete('/api/assessments/session/:sessionId', async (c) => {
  const db = c.env.DB
  const authHeader = c.req.header('Authorization')
  const sessionId = c.req.param('sessionId')
  
  if (!authHeader) {
    return c.json({ success: false, error: '인증이 필요합니다' }, 401)
  }
  
  const sessionToken = authHeader.replace('Bearer ', '')
  
  // 세션 확인
  const userSession = await db.prepare(`
    SELECT user_id FROM user_sessions 
    WHERE session_token = ? AND datetime(expires_at) > datetime('now')
  `).bind(sessionToken).first()
  
  if (!userSession) {
    return c.json({ success: false, error: '유효하지 않은 세션입니다' }, 401)
  }
  
  // 사용자 정보
  const user = await db.prepare(`
    SELECT * FROM users WHERE id = ?
  `).bind(userSession.user_id).first()
  
  if (!user) {
    return c.json({ success: false, error: '사용자를 찾을 수 없습니다' }, 404)
  }
  
  // 진단 세션 정보 확인 (본인 것인지 체크)
  const assessmentSession = await db.prepare(`
    SELECT ase.*, r.email as respondent_email
    FROM assessment_sessions ase
    LEFT JOIN assessment_responses ar ON ase.id = ar.session_id
    LEFT JOIN respondents r ON ar.respondent_id = r.id
    WHERE ase.id = ?
    LIMIT 1
  `).bind(sessionId).first()
  
  if (!assessmentSession) {
    return c.json({ success: false, error: '진단 세션을 찾을 수 없습니다' }, 404)
  }
  
  // 본인의 진단 결과인지 확인
  if (assessmentSession.respondent_email !== user.email) {
    return c.json({ success: false, error: '본인의 진단 결과만 삭제할 수 있습니다' }, 403)
  }
  
  try {
    // 개별 진단 세션과 관련 데이터만 삭제
    
    // 1. 해당 세션의 응답 데이터 삭제
    await db.prepare(`
      DELETE FROM assessment_responses WHERE session_id = ?
    `).bind(sessionId).run()
    
    // 2. 해당 세션의 역량 매핑 삭제
    await db.prepare(`
      DELETE FROM session_competencies WHERE session_id = ?
    `).bind(sessionId).run()
    
    // 3. 진단 세션 삭제
    await db.prepare(`
      DELETE FROM assessment_sessions WHERE id = ?
    `).bind(sessionId).run()
    
    return c.json({ 
      success: true,
      message: '진단 결과가 삭제되었습니다'
    })
  } catch (error: any) {
    console.error('Delete assessment error:', error)
    return c.json({ success: false, error: '삭제 중 오류가 발생했습니다' }, 500)
  }
})

// 응답자별 결과 분석
app.get('/api/analysis/:respondentId', async (c) => {
  const db = c.env.DB
  const respondentId = c.req.param('respondentId')
  
  // 응답자 정보 (users 테이블과 JOIN하여 최신 직급 정보 가져오기)
  const respondent = await db.prepare(`
    SELECT 
      r.*,
      COALESCE(
        NULLIF(u.position, ''),
        NULLIF(r.position, ''),
        '직급 미지정'
      ) as position,
      COALESCE(
        NULLIF(u.organization, ''),
        NULLIF(r.department, ''),
        '부서 미지정'
      ) as department
    FROM respondents r
    LEFT JOIN users u ON r.email = u.email
    WHERE r.id = ?
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
      c.name as competency,
      c.definition as competency_description
    FROM assessment_responses ar
    JOIN assessment_questions aq ON ar.question_id = aq.id
    JOIN competencies c ON aq.competency_id = c.id
    WHERE ar.respondent_id = ?
    ORDER BY c.name, ar.created_at
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
    
    // 저장된 인사이트 조회 (ai_insights 테이블 사용)
    const insight = await db.prepare(`
      SELECT insight_content, created_at 
      FROM ai_insights 
      WHERE respondent_id = ? 
      AND insight_type = 'full_analysis'
      ORDER BY created_at DESC
      LIMIT 1
    `).bind(respondentId).first()
    
    if (insight && insight.insight_content) {
      try {
        const insights = JSON.parse(insight.insight_content as string)
        // 유효한 인사이트인지 확인
        if (insights.overall && insights.strengths && insights.improvements && insights.recommendations) {
          return c.json({ 
            success: true, 
            insights, 
            cached: true,
            createdAt: insight.created_at
          })
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
      
      // ai_insights 테이블에 인사이트 저장
      await db.prepare(`
        INSERT INTO ai_insights 
        (respondent_id, insight_type, insight_content, created_at, updated_at)
        VALUES (?, 'full_analysis', ?, datetime('now'), datetime('now'))
      `).bind(
        respondentId,
        insightsJson
      ).run()
      
      console.log('✅ AI insights saved to database')
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
                    <div class="flex items-center cursor-pointer" onclick="goToHome()">
                        <i class="fas fa-brain text-blue-600 text-2xl mr-3"></i>
                        <h1 class="text-xl font-bold text-gray-800 hover:text-blue-600 transition-colors">AI 역량 진단 플랫폼</h1>
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
                        
                        <!-- User Menu -->
                        <div id="user-menu" class="hidden">
                            <button onclick="showProfileModal()" class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                                <i class="fas fa-user-circle mr-2"></i>
                                <span id="user-name"></span>
                            </button>
                            <button onclick="handleLogout()" class="px-3 py-2 text-sm text-gray-600 hover:bg-gray-100 rounded-lg">
                                로그아웃
                            </button>
                        </div>
                        
                        <!-- Login Button -->
                        <button id="login-btn" onclick="showLoginModal()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                            <i class="fas fa-sign-in-alt mr-2"></i>로그인
                        </button>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <div class="bg-white border-b border-gray-200">
            <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-28">
                <div class="text-center">
                    <!-- Main Heading -->
                    <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-8 leading-relaxed">
                        역량을 평가하고, 성장을 설계하는<br/>
                        <span class="text-blue-600">AI 진단 플랫폼</span>
                    </h1>
                    
                    <!-- Description -->
                    <p class="text-lg md:text-xl text-gray-600 mb-12 max-w-3xl mx-auto leading-relaxed">
                        전문가는 스스로 역량을 객관화하고 지속적으로 발전시킵니다.<br class="hidden md:block"/>
                        AI가 당신의 역량을 진단하고, 성장 계획을 함께 만듭니다.
                    </p>
                    
                    <!-- CTA Button -->
                    <button onclick="scrollToAssessment()" class="px-10 py-4 bg-blue-600 text-white rounded-lg font-medium text-lg hover:bg-blue-700 transition-colors duration-200 shadow-md">
                        역량 진단 시작하기
                    </button>
                    
                    <!-- Features -->
                    <div class="mt-16 grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
                        <div class="space-y-3">
                            <div class="w-12 h-12 bg-blue-50 rounded-lg flex items-center justify-center mx-auto">
                                <i class="fas fa-brain text-blue-600 text-xl"></i>
                            </div>
                            <h3 class="font-semibold text-gray-900">AI 기반 진단</h3>
                            <p class="text-sm text-gray-600">역량별 맞춤 질문 자동 생성</p>
                        </div>
                        <div class="space-y-3">
                            <div class="w-12 h-12 bg-blue-50 rounded-lg flex items-center justify-center mx-auto">
                                <i class="fas fa-chart-line text-blue-600 text-xl"></i>
                            </div>
                            <h3 class="font-semibold text-gray-900">정확한 분석</h3>
                            <p class="text-sm text-gray-600">강점과 개선점을 명확히 파악</p>
                        </div>
                        <div class="space-y-3">
                            <div class="w-12 h-12 bg-blue-50 rounded-lg flex items-center justify-center mx-auto">
                                <i class="fas fa-route text-blue-600 text-xl"></i>
                            </div>
                            <h3 class="font-semibold text-gray-900">실행 계획</h3>
                            <p class="text-sm text-gray-600">즉시 적용 가능한 개발 로드맵</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <main id="features" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <!-- ASSESS Tab -->
            <div id="tab-assess" class="tab-content">
                <div id="phase1-assessment" class="bg-white rounded-lg shadow p-6 mb-6">
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
                    
                    <!-- Step 1: 응답 척도 설정 -->
                    <div id="scale-settings-section" class="mb-8">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">
                            <span class="bg-blue-600 text-white rounded-full w-6 h-6 inline-flex items-center justify-center mr-2 text-sm">1</span>
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

                    <!-- Step 2: 진단 문항 디스플레이 설정 -->
                    <div id="display-settings-section" class="mb-8">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">
                            <span class="bg-blue-600 text-white rounded-full w-6 h-6 inline-flex items-center justify-center mr-2 text-sm">2</span>
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
                <!-- 인트로 섹션 -->
                <div class="bg-gradient-to-r from-green-50 to-blue-50 rounded-lg p-8 mb-6">
                    <div class="max-w-3xl mx-auto text-center">
                        <div class="inline-block p-4 bg-white rounded-full shadow-md mb-4">
                            <i class="fas fa-chart-line text-green-600 text-4xl"></i>
                        </div>
                        <h2 class="text-3xl font-bold text-gray-800 mb-3">나의 역량 진단 결과</h2>
                        <p class="text-gray-600 text-lg">
                            진행한 역량 진단의 결과를 확인하고 분석할 수 있습니다
                        </p>
                    </div>
                </div>
                
                <!-- 진단 결과 목록 -->
                <div class="bg-white rounded-lg shadow-sm">
                    <div class="border-b border-gray-200 px-6 py-4">
                        <h3 class="text-xl font-bold text-gray-800 flex items-center">
                            <i class="fas fa-clipboard-list text-green-600 mr-2"></i>
                            나의 진단 목록
                            <span id="my-assessments-count" class="ml-3 px-3 py-1 bg-green-100 text-green-700 text-sm font-semibold rounded-full">0</span>
                        </h3>
                        <p class="text-sm text-gray-500 mt-1">내가 참여한 역량 진단 결과를 확인하세요</p>
                    </div>
                    
                    <div id="my-assessments-list" class="p-6">
                        <div class="text-center py-8">
                            <i class="fas fa-spinner fa-spin text-4xl text-gray-400 mb-4"></i>
                            <p class="text-gray-500">진단 결과를 불러오는 중...</p>
                        </div>
                    </div>
                </div>
                
                <!-- 결과 리포트 영역 (초기 숨김) -->
                <div id="analysis-report" class="hidden mt-6"></div>
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

        <!-- 회원가입/로그인 모달 -->
        <div id="auth-modal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
            <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4">
                <div class="p-6">
                    <div class="flex justify-between items-center mb-6">
                        <h2 id="modal-title" class="text-2xl font-bold text-gray-800">회원가입</h2>
                        <button onclick="closeAuthModal()" class="text-gray-400 hover:text-gray-600">
                            <i class="fas fa-times text-xl"></i>
                        </button>
                    </div>
                    
                    <!-- 로그인 폼 -->
                    <div id="login-form" class="hidden">
                        <div class="mb-4">
                            <label class="block text-sm font-medium text-gray-700 mb-2">이메일</label>
                            <input type="email" id="login-email" placeholder="your@email.com" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                        </div>
                        <button onclick="handleLogin()" class="w-full px-4 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium">
                            로그인
                        </button>
                        <p class="mt-4 text-center text-sm text-gray-600">
                            계정이 없으신가요? <button onclick="showSignupForm()" class="text-blue-600 hover:underline">회원가입</button>
                        </p>
                    </div>
                    
                    <!-- 회원가입 폼 -->
                    <div id="signup-form">
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">이름 *</label>
                                <input type="text" id="signup-name" placeholder="홍길동" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" required>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">이메일 *</label>
                                <input type="email" id="signup-email" placeholder="your@email.com" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" required>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">직급</label>
                                <input type="text" id="signup-position" placeholder="예: 사원, 대리, 과장" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">소속 조직</label>
                                <input type="text" id="signup-organization" placeholder="예: 마케팅팀, 전략기획팀" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                            </div>
                        </div>
                        <button onclick="handleSignup()" class="w-full mt-6 px-4 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium">
                            가입하고 시작하기
                        </button>
                        <p class="mt-4 text-center text-sm text-gray-600">
                            이미 계정이 있으신가요? <button onclick="showLoginForm()" class="text-blue-600 hover:underline">로그인</button>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 프로필 모달 -->
        <div id="profile-modal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
            <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4">
                <div class="p-6">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-2xl font-bold text-gray-800">프로필 관리</h2>
                        <button onclick="closeProfileModal()" class="text-gray-400 hover:text-gray-600">
                            <i class="fas fa-times text-xl"></i>
                        </button>
                    </div>
                    
                    <!-- 프로필 정보 폼 -->
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">이름 *</label>
                            <input type="text" id="profile-name" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">이메일</label>
                            <input type="email" id="profile-email" class="w-full rounded-lg border-gray-300 bg-gray-50 shadow-sm" disabled>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">직급</label>
                            <input type="text" id="profile-position" placeholder="예: 사원, 대리, 과장" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">소속 조직</label>
                            <input type="text" id="profile-organization" placeholder="예: 마케팅팀, 전략기획팀" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                        </div>
                    </div>
                    
                    <!-- 버튼 그룹 -->
                    <div class="mt-6 space-y-3">
                        <button onclick="handleProfileUpdate()" class="w-full px-4 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium">
                            정보 수정
                        </button>
                        <button onclick="handleAccountDeletion()" class="w-full px-4 py-3 bg-red-600 text-white rounded-lg hover:bg-red-700 font-medium">
                            회원 탈퇴
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/axios@1.6.0/dist/axios.min.js"></script>
        <script>
            // Smooth scroll to features section
            function scrollToFeatures() {
                const featuresSection = document.getElementById('features');
                if (featuresSection) {
                    featuresSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            }

            // Smooth scroll to Phase 1: Assessment section
            function scrollToAssessment() {
                // 로그인 체크
                checkAuthAndProceed();
            }
            
            // ==================== 인증 관련 함수 ====================
            
            // 로컬스토리지에서 세션 토큰 가져오기
            function getSessionToken() {
                return localStorage.getItem('sessionToken');
            }
            
            // 세션 토큰 저장
            function setSessionToken(token) {
                localStorage.setItem('sessionToken', token);
            }
            
            // 세션 토큰 삭제
            function clearSessionToken() {
                localStorage.removeItem('sessionToken');
            }
            
            // 로그인 상태 체크 및 진단 진행
            async function checkAuthAndProceed() {
                const token = getSessionToken();
                
                if (!token) {
                    // 로그인 안됨 - 회원가입 모달 표시
                    showSignupModal();
                    return;
                }
                
                // 세션 유효성 체크
                try {
                    const response = await axios.get('/api/auth/me', {
                        headers: { 'Authorization': 'Bearer ' + token }
                    });
                    
                    if (response.data.success) {
                        // 로그인됨 - Phase 1으로 이동
                        proceedToAssessment();
                    } else {
                        // 세션 만료 - 회원가입 모달 표시
                        clearSessionToken();
                        showSignupModal();
                    }
                } catch (error) {
                    // 세션 오류 - 회원가입 모달 표시
                    clearSessionToken();
                    showSignupModal();
                }
            }
            
            // Phase 1으로 진행
            function proceedToAssessment() {
                showTab('assess', document.querySelector('.nav-btn'));
                setTimeout(() => {
                    const assessmentSection = document.getElementById('phase1-assessment');
                    if (assessmentSection) {
                        assessmentSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                }, 100);
            }
            
            // 회원가입 모달 표시
            function showSignupModal() {
                document.getElementById('auth-modal').classList.remove('hidden');
                document.getElementById('modal-title').textContent = '회원가입';
                document.getElementById('signup-form').classList.remove('hidden');
                document.getElementById('login-form').classList.add('hidden');
            }
            
            // 로그인 모달 표시
            function showLoginModal() {
                document.getElementById('auth-modal').classList.remove('hidden');
                document.getElementById('modal-title').textContent = '로그인';
                document.getElementById('login-form').classList.remove('hidden');
                document.getElementById('signup-form').classList.add('hidden');
            }
            
            // 모달 닫기
            function closeAuthModal() {
                document.getElementById('auth-modal').classList.add('hidden');
            }
            
            // 로그인 폼 표시
            function showLoginForm() {
                document.getElementById('modal-title').textContent = '로그인';
                document.getElementById('login-form').classList.remove('hidden');
                document.getElementById('signup-form').classList.add('hidden');
            }
            
            // 회원가입 폼 표시
            function showSignupForm() {
                document.getElementById('modal-title').textContent = '회원가입';
                document.getElementById('signup-form').classList.remove('hidden');
                document.getElementById('login-form').classList.add('hidden');
            }
            
            // 회원가입 처리
            async function handleSignup() {
                const name = document.getElementById('signup-name').value.trim();
                const email = document.getElementById('signup-email').value.trim();
                const position = document.getElementById('signup-position').value.trim();
                const organization = document.getElementById('signup-organization').value.trim();
                
                if (!name || !email) {
                    alert('이름과 이메일은 필수입니다.');
                    return;
                }
                
                try {
                    const response = await axios.post('/api/auth/signup', {
                        name, email, position, organization
                    });
                    
                    if (response.data.success) {
                        const { sessionToken, user } = response.data.data;
                        setSessionToken(sessionToken);
                        updateUIForLoggedInUser(user);
                        closeAuthModal();
                        
                        // 회원가입 후 바로 Phase 1으로 이동
                        proceedToAssessment();
                    } else {
                        alert(response.data.error || '회원가입 실패');
                    }
                } catch (error) {
                    console.error('Signup error:', error);
                    alert(error.response?.data?.error || '회원가입 중 오류가 발생했습니다.');
                }
            }
            
            // 로그인 처리
            async function handleLogin() {
                const email = document.getElementById('login-email').value.trim();
                
                if (!email) {
                    alert('이메일을 입력하세요.');
                    return;
                }
                
                try {
                    const response = await axios.post('/api/auth/login', { email });
                    
                    if (response.data.success) {
                        const { sessionToken, user } = response.data.data;
                        setSessionToken(sessionToken);
                        updateUIForLoggedInUser(user);
                        closeAuthModal();
                    } else {
                        alert(response.data.error || '로그인 실패');
                    }
                } catch (error) {
                    console.error('Login error:', error);
                    alert(error.response?.data?.error || '로그인 중 오류가 발생했습니다.');
                }
            }
            
            // 로그아웃 처리
            async function handleLogout() {
                const token = getSessionToken();
                
                if (token) {
                    try {
                        await axios.post('/api/auth/logout', {}, {
                            headers: { 'Authorization': 'Bearer ' + token }
                        });
                    } catch (error) {
                        console.error('Logout error:', error);
                    }
                }
                
                clearSessionToken();
                updateUIForLoggedOutUser();
            }
            
            // ==================== 프로필 관련 함수 ====================
            
            // 프로필 모달 표시
            async function showProfileModal() {
                const token = getSessionToken();
                
                if (!token) {
                    alert('로그인이 필요합니다.');
                    return;
                }
                
                try {
                    // 현재 사용자 정보 가져오기
                    const response = await axios.get('/api/auth/me', {
                        headers: { 'Authorization': 'Bearer ' + token }
                    });
                    
                    if (response.data.success) {
                        const user = response.data.data.user;
                        
                        // 폼에 현재 정보 채우기
                        document.getElementById('profile-name').value = user.name || '';
                        document.getElementById('profile-email').value = user.email || '';
                        document.getElementById('profile-position').value = user.position || '';
                        document.getElementById('profile-organization').value = user.organization || '';
                        
                        // 모달 표시
                        document.getElementById('profile-modal').classList.remove('hidden');
                    } else {
                        alert('사용자 정보를 불러올 수 없습니다.');
                    }
                } catch (error) {
                    console.error('Profile load error:', error);
                    alert('사용자 정보를 불러오는 중 오류가 발생했습니다.');
                }
            }
            
            // 프로필 모달 닫기
            function closeProfileModal() {
                document.getElementById('profile-modal').classList.add('hidden');
            }
            
            // 프로필 업데이트 처리
            async function handleProfileUpdate() {
                const token = getSessionToken();
                
                if (!token) {
                    alert('로그인이 필요합니다.');
                    return;
                }
                
                const name = document.getElementById('profile-name').value.trim();
                const position = document.getElementById('profile-position').value.trim();
                const organization = document.getElementById('profile-organization').value.trim();
                
                if (!name) {
                    alert('이름은 필수 항목입니다.');
                    return;
                }
                
                try {
                    const response = await axios.put('/api/auth/profile', {
                        name,
                        position,
                        organization
                    }, {
                        headers: { 'Authorization': 'Bearer ' + token }
                    });
                    
                    if (response.data.success) {
                        alert('프로필이 성공적으로 업데이트되었습니다.');
                        
                        // UI 업데이트
                        const user = response.data.data.user;
                        document.getElementById('user-name').textContent = user.name;
                        
                        closeProfileModal();
                    } else {
                        alert('프로필 업데이트 실패: ' + (response.data.error || '알 수 없는 오류'));
                    }
                } catch (error) {
                    console.error('Profile update error:', error);
                    alert('프로필 업데이트 중 오류가 발생했습니다.');
                }
            }
            
            // 회원탈퇴 처리
            async function handleAccountDeletion() {
                if (!confirm('정말로 회원탈퇴를 진행하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                    return;
                }
                
                const token = getSessionToken();
                
                if (!token) {
                    alert('로그인이 필요합니다.');
                    return;
                }
                
                try {
                    const response = await axios.delete('/api/auth/account', {
                        headers: { 'Authorization': 'Bearer ' + token }
                    });
                    
                    if (response.data.success) {
                        alert('회원탈퇴가 완료되었습니다.');
                        
                        clearSessionToken();
                        closeProfileModal();
                        updateUIForLoggedOutUser();
                        
                        // 홈으로 이동
                        window.location.href = '/';
                    } else {
                        alert('회원탈퇴 실패: ' + (response.data.error || '알 수 없는 오류'));
                    }
                } catch (error) {
                    console.error('Account deletion error:', error);
                    alert('회원탈퇴 중 오류가 발생했습니다.');
                }
            }
            
            // 로그인 상태 UI 업데이트
            function updateUIForLoggedInUser(user) {
                document.getElementById('login-btn').classList.add('hidden');
                document.getElementById('user-menu').classList.remove('hidden');
                document.getElementById('user-name').textContent = user.name;
            }
            
            // 로그아웃 상태 UI 업데이트
            function updateUIForLoggedOutUser() {
                document.getElementById('login-btn').classList.remove('hidden');
                document.getElementById('user-menu').classList.add('hidden');
                document.getElementById('user-name').textContent = '';
            }
            
            // 페이지 로드 시 로그인 상태 체크
            async function checkLoginStatus() {
                const token = getSessionToken();
                
                if (token) {
                    try {
                        const response = await axios.get('/api/auth/me', {
                            headers: { 'Authorization': 'Bearer ' + token }
                        });
                        
                        if (response.data.success) {
                            updateUIForLoggedInUser(response.data.data.user);
                        } else {
                            clearSessionToken();
                        }
                    } catch (error) {
                        clearSessionToken();
                    }
                }
            }
            
            // 페이지 로드 시 실행
            document.addEventListener('DOMContentLoaded', () => {
                checkLoginStatus();
            });
        </script>
        <script src="/static/app.js?v=26"></script>
    </body>
    </html>
  `)
})

export default app
