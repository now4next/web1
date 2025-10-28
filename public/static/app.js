// ============================================================================
// 전역 상태 관리
// ============================================================================

let selectedCompetencies = []
let chatMessages = []

// ============================================================================
// 탭 전환
// ============================================================================

function showTab(tabName) {
  // 모든 탭 숨기기
  document.querySelectorAll('.tab-content').forEach(tab => {
    tab.classList.add('hidden')
  })
  
  // 선택된 탭 표시
  document.getElementById(`tab-${tabName}`).classList.remove('hidden')
  
  // 네비게이션 버튼 스타일 업데이트
  document.querySelectorAll('.nav-btn').forEach(btn => {
    btn.classList.remove('bg-blue-100', 'text-blue-700')
  })
  event.target.closest('button').classList.add('bg-blue-100', 'text-blue-700')
}

// ============================================================================
// Phase 1: 진단 설계
// ============================================================================

// 역량 검색
async function searchCompetencies() {
  const query = document.getElementById('competency-search').value
  const resultsDiv = document.getElementById('search-results')
  
  if (!query.trim()) {
    resultsDiv.innerHTML = '<p class="text-gray-400 text-sm">역량을 검색하세요</p>'
    return
  }
  
  try {
    resultsDiv.innerHTML = '<p class="text-gray-400 text-sm">검색 중...</p>'
    
    const response = await axios.get(`/api/competencies/search?q=${encodeURIComponent(query)}`)
    
    if (response.data.success && response.data.data.length > 0) {
      resultsDiv.innerHTML = response.data.data.map(comp => `
        <div class="flex items-center justify-between py-2 px-3 hover:bg-gray-50 rounded cursor-pointer mb-2 border" 
             onclick="selectCompetency(${comp.id}, '${comp.keyword}', '${comp.description}')">
          <div>
            <div class="font-medium text-gray-800">${comp.keyword}</div>
            <div class="text-xs text-gray-500">${comp.model_name} · ${comp.description}</div>
          </div>
          <button class="text-blue-600 hover:text-blue-700">
            <i class="fas fa-plus-circle"></i>
          </button>
        </div>
      `).join('')
    } else {
      resultsDiv.innerHTML = '<p class="text-gray-400 text-sm">검색 결과가 없습니다</p>'
    }
  } catch (error) {
    console.error('Error searching competencies:', error)
    resultsDiv.innerHTML = '<p class="text-red-500 text-sm">검색 중 오류가 발생했습니다</p>'
  }
}

// 역량 선택
function selectCompetency(id, keyword, description) {
  // 중복 체크
  if (selectedCompetencies.find(c => c.id === id)) {
    alert('이미 선택된 역량입니다')
    return
  }
  
  selectedCompetencies.push({ id, keyword, description })
  updateSelectedCompetencies()
}

// 선택된 역량 제거
function removeCompetency(id) {
  selectedCompetencies = selectedCompetencies.filter(c => c.id !== id)
  updateSelectedCompetencies()
}

// 선택된 역량 UI 업데이트
function updateSelectedCompetencies() {
  const selectedDiv = document.getElementById('selected-competencies')
  
  if (selectedCompetencies.length === 0) {
    selectedDiv.innerHTML = '<p class="text-gray-400 text-sm">역량을 선택하세요</p>'
    return
  }
  
  selectedDiv.innerHTML = selectedCompetencies.map(comp => `
    <div class="flex items-center justify-between py-2 px-3 bg-blue-50 rounded mb-2 border border-blue-200">
      <div>
        <div class="font-medium text-gray-800">${comp.keyword}</div>
        <div class="text-xs text-gray-600">${comp.description}</div>
      </div>
      <button onclick="removeCompetency(${comp.id})" class="text-red-600 hover:text-red-700">
        <i class="fas fa-times-circle"></i>
      </button>
    </div>
  `).join('')
}

// AI 문항 생성
async function generateQuestions() {
  if (selectedCompetencies.length === 0) {
    alert('역량을 먼저 선택해주세요')
    return
  }
  
  const targetLevel = document.getElementById('target-level').value
  const questionType = document.getElementById('question-type').value
  
  const resultDiv = document.getElementById('generation-result')
  const contentDiv = document.getElementById('generation-content')
  
  try {
    resultDiv.classList.remove('hidden')
    contentDiv.innerHTML = `
      <div class="text-center py-8">
        <i class="fas fa-spinner fa-spin text-4xl text-blue-600 mb-4"></i>
        <p class="text-gray-600">AI가 진단 문항을 생성하고 있습니다...</p>
      </div>
    `
    
    const response = await axios.post('/api/ai/generate-questions', {
      competency_keywords: selectedCompetencies.map(c => c.keyword),
      target_level: targetLevel,
      question_type: questionType
    })
    
    if (response.data.success) {
      const data = response.data.data
      const isDemo = response.data.demo
      
      contentDiv.innerHTML = `
        ${isDemo ? `
        <!-- 데모 모드 알림 -->
        <div class="bg-yellow-50 border-l-4 border-yellow-500 p-4 mb-4">
          <div class="flex items-center">
            <i class="fas fa-exclamation-triangle text-yellow-600 mr-2"></i>
            <div>
              <h4 class="font-semibold text-yellow-900 mb-1">데모 모드로 실행 중</h4>
              <p class="text-yellow-800 text-sm">
                OpenAI API 키가 설정되지 않아 샘플 데이터를 표시합니다. 
                실제 AI 생성을 원하시면 <code class="bg-yellow-100 px-1 rounded">.dev.vars</code> 파일에 API 키를 설정하세요.
              </p>
            </div>
          </div>
        </div>
        ` : ''}
        
        <!-- 진단 안내문 -->
        <div class="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6">
          <h4 class="font-semibold text-blue-900 mb-2">
            <i class="fas fa-info-circle mr-2"></i>진단 안내
          </h4>
          <p class="text-blue-800 text-sm whitespace-pre-line">${data.guide}</p>
        </div>
        
        <!-- 행동 지표 -->
        <div class="mb-6">
          <h4 class="font-semibold text-gray-800 mb-3">
            <i class="fas fa-list-check mr-2 text-green-600"></i>행동 지표 (Behavioral Indicators)
          </h4>
          ${data.behavioral_indicators.map(bi => `
            <div class="mb-4 p-4 bg-white border rounded-lg">
              <div class="font-medium text-gray-800 mb-2">${bi.competency}</div>
              <ul class="list-disc list-inside space-y-1">
                ${bi.indicators.map(ind => `
                  <li class="text-gray-600 text-sm">${ind}</li>
                `).join('')}
              </ul>
            </div>
          `).join('')}
        </div>
        
        <!-- 진단 문항 -->
        <div>
          <h4 class="font-semibold text-gray-800 mb-3">
            <i class="fas fa-clipboard-question mr-2 text-purple-600"></i>진단 문항
          </h4>
          ${data.questions.map((q, idx) => `
            <div class="mb-3 p-4 bg-white border rounded-lg">
              <div class="flex items-start gap-3">
                <span class="text-sm font-medium text-gray-500 mt-1">Q${idx + 1}</span>
                <div class="flex-1">
                  <div class="text-gray-700">${q.question_text}</div>
                  <div class="text-xs text-gray-500 mt-1">역량: ${q.competency}</div>
                </div>
              </div>
            </div>
          `).join('')}
        </div>
        
        <div class="mt-6 flex gap-3">
          <button onclick="saveAssessment()" class="flex-1 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
            <i class="fas fa-save mr-2"></i>진단 저장
          </button>
          <button onclick="startAssessment()" class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
            <i class="fas fa-play mr-2"></i>진단 시작
          </button>
        </div>
      `
    } else {
      contentDiv.innerHTML = `
        <div class="text-center py-8">
          <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
          <p class="text-red-600">${response.data.error}</p>
          <p class="text-gray-500 text-sm mt-2">OpenAI API 키를 .dev.vars 파일에 설정해주세요</p>
        </div>
      `
    }
  } catch (error) {
    console.error('Error generating questions:', error)
    contentDiv.innerHTML = `
      <div class="text-center py-8">
        <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
        <p class="text-red-600">문항 생성 중 오류가 발생했습니다</p>
        <p class="text-gray-500 text-sm mt-2">${error.message}</p>
      </div>
    `
  }
}

function saveAssessment() {
  alert('진단 저장 기능은 개발 중입니다')
}

function startAssessment() {
  alert('진단 시작 기능은 개발 중입니다')
}

// ============================================================================
// Phase 3: AI 코칭
// ============================================================================

async function sendChatMessage() {
  const input = document.getElementById('chat-input')
  const message = input.value.trim()
  
  if (!message) return
  
  // 사용자 메시지 추가
  chatMessages.push({ role: 'user', content: message })
  updateChatUI()
  input.value = ''
  
  // AI 응답 요청
  try {
    const response = await axios.post('/api/ai/coaching', {
      messages: [
        { 
          role: 'system', 
          content: '당신은 조직 역량 개발 전문 AI 코치입니다. 임직원의 역량 진단 결과를 바탕으로 강점을 강화하고 약점을 보완할 수 있도록 구체적이고 실용적인 조언을 제공합니다.' 
        },
        ...chatMessages
      ]
    })
    
    if (response.data.success) {
      chatMessages.push({ role: 'assistant', content: response.data.message })
      updateChatUI()
    } else {
      alert(response.data.error)
    }
  } catch (error) {
    console.error('Error sending chat message:', error)
    alert('메시지 전송 중 오류가 발생했습니다')
  }
}

function updateChatUI() {
  const container = document.getElementById('chat-container')
  
  if (chatMessages.length === 0) {
    container.innerHTML = `
      <div class="text-gray-500 text-sm text-center py-8">
        역량 진단 결과에 대해 AI 코치와 대화를 시작하세요
      </div>
    `
    return
  }
  
  container.innerHTML = chatMessages.map(msg => {
    if (msg.role === 'user') {
      return `
        <div class="flex justify-end mb-4">
          <div class="bg-blue-600 text-white rounded-lg px-4 py-2 max-w-[70%]">
            ${msg.content}
          </div>
        </div>
      `
    } else {
      return `
        <div class="flex justify-start mb-4">
          <div class="bg-gray-200 text-gray-800 rounded-lg px-4 py-2 max-w-[70%]">
            <div class="flex items-center gap-2 mb-1">
              <i class="fas fa-robot text-blue-600"></i>
              <span class="font-medium text-sm">AI 코치</span>
            </div>
            <div class="whitespace-pre-line">${msg.content}</div>
          </div>
        </div>
      `
    }
  }).join('')
  
  // 스크롤을 최하단으로
  container.scrollTop = container.scrollHeight
}

// ============================================================================
// 초기화
// ============================================================================

document.addEventListener('DOMContentLoaded', () => {
  // 기본 탭 활성화
  showTab('assess')
  
  // 엔터키로 검색
  document.getElementById('competency-search').addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
      searchCompetencies()
    }
  })
})
