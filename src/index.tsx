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
  
  if (!apiKey || apiKey === 'your-openai-api-key-here') {
    return c.json({ 
      success: false, 
      error: 'OpenAI API key가 설정되지 않았습니다. .dev.vars 파일을 확인해주세요.' 
    }, 400)
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

// AI 코칭 API
app.post('/api/ai/coaching', async (c) => {
  const apiKey = c.env.OPENAI_API_KEY
  const body = await c.req.json()
  
  if (!apiKey || apiKey === 'your-openai-api-key-here') {
    return c.json({ 
      success: false, 
      error: 'OpenAI API key가 설정되지 않았습니다.' 
    }, 400)
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
        <link href="/static/style.css" rel="stylesheet">
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

            <!-- ANALYTICS Tab -->
            <div id="tab-analytics" class="tab-content hidden">
                <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-4">
                        <i class="fas fa-chart-bar text-green-600 mr-2"></i>
                        Phase 2: 분석 및 인사이트
                    </h2>
                    <p class="text-gray-600 mb-4">진단 데이터 분석 기능은 개발 중입니다.</p>
                    
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="border rounded-lg p-4">
                            <div class="text-3xl font-bold text-blue-600 mb-2">--</div>
                            <div class="text-sm text-gray-600">진행 중인 진단</div>
                        </div>
                        <div class="border rounded-lg p-4">
                            <div class="text-3xl font-bold text-green-600 mb-2">--</div>
                            <div class="text-sm text-gray-600">완료된 응답</div>
                        </div>
                        <div class="border rounded-lg p-4">
                            <div class="text-3xl font-bold text-purple-600 mb-2">--</div>
                            <div class="text-sm text-gray-600">분석 대기</div>
                        </div>
                    </div>
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
        <script src="/static/app.js"></script>
    </body>
    </html>
  `)
})

export default app
