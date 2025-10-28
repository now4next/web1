// ============================================================================
// 전역 상태 관리
// ============================================================================

let selectedCompetencies = []
let chatMessages = []
let generatedData = null // AI 생성된 데이터 저장
let editableQuestions = [] // 편집 가능한 문항 목록
let currentSessionId = null // 현재 진단 세션 ID

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
    }, {
      timeout: 60000 // 60초 타임아웃
    })
    
    if (response.data.success) {
      const data = response.data.data
      const isDemo = response.data.demo
      
      // 생성된 데이터 저장
      generatedData = data
      editableQuestions = data.questions.map((q, idx) => ({
        id: idx,
        ...q
      }))
      
      renderGeneratedQuestions(data, isDemo)
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
    const errorDetail = error.response?.data?.error || error.message || '알 수 없는 오류'
    contentDiv.innerHTML = `
      <div class="text-center py-8">
        <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
        <p class="text-red-600">문항 생성 중 오류가 발생했습니다</p>
        <p class="text-gray-500 text-sm mt-2">${errorDetail}</p>
        <button onclick="generateQuestions()" class="mt-4 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
          <i class="fas fa-redo mr-2"></i>다시 시도
        </button>
      </div>
    `
  }
}

// 생성된 문항 렌더링 (편집 가능)
function renderGeneratedQuestions(data, isDemo) {
  const contentDiv = document.getElementById('generation-content')
  
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
    
    <!-- 진단 문항 (편집 가능) -->
    <div>
      <div class="flex justify-between items-center mb-3">
        <h4 class="font-semibold text-gray-800">
          <i class="fas fa-clipboard-question mr-2 text-purple-600"></i>진단 문항
        </h4>
        <button onclick="toggleEditMode()" id="edit-mode-btn" class="px-3 py-1 text-sm bg-gray-100 hover:bg-gray-200 rounded-lg">
          <i class="fas fa-edit mr-1"></i>편집 모드
        </button>
      </div>
      <div id="questions-container"></div>
    </div>
    
    <div class="mt-6 flex gap-3">
      <button onclick="showSaveDialog()" class="flex-1 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
        <i class="fas fa-save mr-2"></i>진단 저장
      </button>
      <button onclick="showScaleSetup()" class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
        <i class="fas fa-play mr-2"></i>진단 시작
      </button>
    </div>
  `
  
  renderQuestions()
}

// 문항 목록 렌더링
function renderQuestions() {
  const container = document.getElementById('questions-container')
  if (!container) return
  
  const isEditMode = document.getElementById('edit-mode-btn')?.textContent.includes('보기 모드')
  
  container.innerHTML = editableQuestions.map((q, idx) => `
    <div class="mb-3 p-4 bg-white border rounded-lg question-item" data-id="${q.id}">
      <div class="flex items-start gap-3">
        ${isEditMode ? `
        <div class="flex flex-col gap-2">
          <button onclick="moveQuestion(${idx}, -1)" class="text-gray-400 hover:text-gray-600" ${idx === 0 ? 'disabled' : ''}>
            <i class="fas fa-arrow-up"></i>
          </button>
          <button onclick="moveQuestion(${idx}, 1)" class="text-gray-400 hover:text-gray-600" ${idx === editableQuestions.length - 1 ? 'disabled' : ''}>
            <i class="fas fa-arrow-down"></i>
          </button>
        </div>
        ` : ''}
        <span class="text-sm font-medium text-gray-500 mt-1">Q${idx + 1}</span>
        <div class="flex-1">
          ${isEditMode ? `
          <textarea 
            class="w-full p-2 border rounded text-gray-700 mb-2" 
            rows="2"
            onchange="updateQuestion(${idx}, this.value)"
          >${q.question_text}</textarea>
          ` : `
          <div class="text-gray-700">${q.question_text}</div>
          `}
          <div class="text-xs text-gray-500 mt-1">역량: ${q.competency}</div>
        </div>
        ${isEditMode ? `
        <button onclick="deleteQuestion(${idx})" class="text-red-500 hover:text-red-700">
          <i class="fas fa-trash"></i>
        </button>
        ` : ''}
      </div>
    </div>
  `).join('')
}

// 편집 모드 토글
function toggleEditMode() {
  const btn = document.getElementById('edit-mode-btn')
  if (btn.textContent.includes('편집 모드')) {
    btn.innerHTML = '<i class="fas fa-eye mr-1"></i>보기 모드'
    btn.classList.remove('bg-gray-100', 'hover:bg-gray-200')
    btn.classList.add('bg-blue-100', 'hover:bg-blue-200', 'text-blue-700')
  } else {
    btn.innerHTML = '<i class="fas fa-edit mr-1"></i>편집 모드'
    btn.classList.remove('bg-blue-100', 'hover:bg-blue-200', 'text-blue-700')
    btn.classList.add('bg-gray-100', 'hover:bg-gray-200')
  }
  renderQuestions()
}

// 문항 수정
function updateQuestion(idx, newText) {
  editableQuestions[idx].question_text = newText
}

// 문항 삭제
function deleteQuestion(idx) {
  if (confirm('이 문항을 삭제하시겠습니까?')) {
    editableQuestions.splice(idx, 1)
    renderQuestions()
  }
}

// 문항 순서 변경
function moveQuestion(idx, direction) {
  const newIdx = idx + direction
  if (newIdx < 0 || newIdx >= editableQuestions.length) return
  
  const temp = editableQuestions[idx]
  editableQuestions[idx] = editableQuestions[newIdx]
  editableQuestions[newIdx] = temp
  
  renderQuestions()
}

// 진단 저장 대화상자
async function showSaveDialog() {
  const sessionName = prompt('진단 세션 이름을 입력하세요:', `${selectedCompetencies.map(c => c.keyword).join(', ')} 진단`)
  if (!sessionName) return
  
  try {
    const targetLevel = document.getElementById('target-level').value
    const questionType = document.getElementById('question-type').value
    
    // 진단 세션 생성
    const sessionResponse = await axios.post('/api/assessment-sessions', {
      session_name: sessionName,
      session_type: questionType,
      target_level: targetLevel,
      status: 'draft'
    })
    
    if (!sessionResponse.data.success) {
      alert('진단 세션 생성 실패')
      return
    }
    
    currentSessionId = sessionResponse.data.id
    
    // 문항 저장
    for (const comp of selectedCompetencies) {
      await axios.post('/api/session-competencies', {
        session_id: currentSessionId,
        competency_id: comp.id
      })
    }
    
    for (const q of editableQuestions) {
      await axios.post('/api/assessment-questions-save', {
        session_id: currentSessionId,
        competency_keyword: q.competency,
        question_text: q.question_text,
        question_type: q.question_type
      })
    }
    
    alert('진단이 성공적으로 저장되었습니다!')
  } catch (error) {
    console.error('Error saving assessment:', error)
    alert('진단 저장 중 오류가 발생했습니다: ' + (error.response?.data?.error || error.message))
  }
}

// 진단 척도 설정 및 시작
function showScaleSetup() {
  if (!editableQuestions || editableQuestions.length === 0) {
    alert('먼저 진단 문항을 생성하세요')
    return
  }
  
  const contentDiv = document.getElementById('generation-content')
  
  contentDiv.innerHTML = `
    <div class="bg-white rounded-lg p-6">
      <h3 class="text-xl font-bold text-gray-800 mb-4">
        <i class="fas fa-sliders-h mr-2 text-blue-600"></i>진단 응답 척도 설정
      </h3>
      
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">척도 유형</label>
        <select id="scale-type" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
          <option value="likert_5">5점 척도 (1: 전혀 그렇지 않다 ~ 5: 매우 그렇다)</option>
          <option value="likert_7">7점 척도 (1: 전혀 그렇지 않다 ~ 7: 매우 그렇다)</option>
          <option value="percent">백분율 (0% ~ 100%)</option>
        </select>
      </div>
      
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">응답자 정보</label>
        <div class="grid grid-cols-2 gap-4">
          <input type="text" id="respondent-name" placeholder="이름" class="rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
          <input type="email" id="respondent-email" placeholder="이메일" class="rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
          <input type="text" id="respondent-dept" placeholder="부서" class="rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
          <input type="text" id="respondent-position" placeholder="직책" class="rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
        </div>
      </div>
      
      <div class="flex gap-3">
        <button onclick="renderGeneratedQuestions(generatedData, false)" class="flex-1 px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600">
          <i class="fas fa-arrow-left mr-2"></i>뒤로
        </button>
        <button onclick="startAssessmentExecution()" class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
          <i class="fas fa-play mr-2"></i>진단 시작
        </button>
      </div>
    </div>
  `
}

// 진단 실행
function startAssessmentExecution() {
  const scaleType = document.getElementById('scale-type').value
  const name = document.getElementById('respondent-name').value
  const email = document.getElementById('respondent-email').value
  const dept = document.getElementById('respondent-dept').value
  const position = document.getElementById('respondent-position').value
  
  if (!name || !email) {
    alert('이름과 이메일은 필수입니다')
    return
  }
  
  const contentDiv = document.getElementById('generation-content')
  let currentQuestionIndex = 0
  const responses = []
  
  function renderQuestion() {
    if (currentQuestionIndex >= editableQuestions.length) {
      showAssessmentComplete(responses, { name, email, dept, position })
      return
    }
    
    const q = editableQuestions[currentQuestionIndex]
    const progress = ((currentQuestionIndex / editableQuestions.length) * 100).toFixed(0)
    
    let scaleOptions = ''
    if (scaleType === 'likert_5') {
      scaleOptions = `
        <div class="flex justify-between gap-2">
          ${[1,2,3,4,5].map(val => `
            <button onclick="selectResponse(${val})" class="flex-1 py-3 border-2 rounded-lg hover:border-blue-500 hover:bg-blue-50 scale-btn">
              <div class="font-bold text-lg">${val}</div>
              <div class="text-xs text-gray-500 mt-1">${val === 1 ? '전혀\n그렇지\n않다' : val === 5 ? '매우\n그렇다' : ''}</div>
            </button>
          `).join('')}
        </div>
      `
    } else if (scaleType === 'likert_7') {
      scaleOptions = `
        <div class="flex justify-between gap-2">
          ${[1,2,3,4,5,6,7].map(val => `
            <button onclick="selectResponse(${val})" class="flex-1 py-3 border-2 rounded-lg hover:border-blue-500 hover:bg-blue-50 scale-btn">
              <div class="font-bold text-lg">${val}</div>
            </button>
          `).join('')}
        </div>
      `
    } else {
      scaleOptions = `
        <input type="range" id="percent-slider" min="0" max="100" value="50" class="w-full mb-2" oninput="updatePercentValue(this.value)">
        <div class="text-center mb-4">
          <span id="percent-value" class="text-2xl font-bold text-blue-600">50%</span>
        </div>
        <button onclick="selectResponse(document.getElementById('percent-slider').value)" class="w-full py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
          다음
        </button>
      `
    }
    
    contentDiv.innerHTML = `
      <div class="bg-white rounded-lg p-6">
        <!-- 진행 상황 -->
        <div class="mb-6">
          <div class="flex justify-between text-sm text-gray-600 mb-2">
            <span>진행률</span>
            <span>${currentQuestionIndex + 1} / ${editableQuestions.length}</span>
          </div>
          <div class="w-full bg-gray-200 rounded-full h-2">
            <div class="bg-blue-600 h-2 rounded-full transition-all" style="width: ${progress}%"></div>
          </div>
        </div>
        
        <!-- 문항 -->
        <div class="mb-8">
          <div class="text-sm text-gray-500 mb-2">Q${currentQuestionIndex + 1}. ${q.competency}</div>
          <div class="text-lg font-medium text-gray-800 mb-6">${q.question_text}</div>
          
          ${scaleOptions}
        </div>
        
        <!-- 네비게이션 -->
        <div class="flex gap-3">
          ${currentQuestionIndex > 0 ? `
          <button onclick="previousQuestion()" class="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600">
            <i class="fas fa-arrow-left mr-2"></i>이전
          </button>
          ` : ''}
        </div>
      </div>
    `
  }
  
  window.selectResponse = function(value) {
    responses[currentQuestionIndex] = {
      question_id: editableQuestions[currentQuestionIndex].id,
      question_text: editableQuestions[currentQuestionIndex].question_text,
      competency: editableQuestions[currentQuestionIndex].competency,
      response_value: parseInt(value)
    }
    currentQuestionIndex++
    renderQuestion()
  }
  
  window.previousQuestion = function() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--
      renderQuestion()
    }
  }
  
  window.updatePercentValue = function(val) {
    document.getElementById('percent-value').textContent = val + '%'
  }
  
  renderQuestion()
}

// 진단 완료
async function showAssessmentComplete(responses, respondent) {
  const contentDiv = document.getElementById('generation-content')
  
  contentDiv.innerHTML = `
    <div class="bg-white rounded-lg p-6 text-center">
      <i class="fas fa-check-circle text-6xl text-green-600 mb-4"></i>
      <h3 class="text-2xl font-bold text-gray-800 mb-2">진단 완료!</h3>
      <p class="text-gray-600 mb-6">모든 문항에 응답하셨습니다.</p>
      
      <div class="bg-gray-50 rounded-lg p-4 mb-6 text-left">
        <h4 class="font-semibold text-gray-800 mb-2">응답 요약</h4>
        <div class="text-sm text-gray-600">
          <p>응답자: ${respondent.name} (${respondent.email})</p>
          <p>총 문항 수: ${responses.length}개</p>
          <p>평균 점수: ${(responses.reduce((sum, r) => sum + r.response_value, 0) / responses.length).toFixed(2)}</p>
        </div>
      </div>
      
      <div class="flex gap-3">
        <button onclick="saveResponses(${JSON.stringify(responses).replace(/"/g, '&quot;')}, ${JSON.stringify(respondent).replace(/"/g, '&quot;')})" class="flex-1 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
          <i class="fas fa-save mr-2"></i>결과 저장
        </button>
        <button onclick="showTab('analytics')" class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
          <i class="fas fa-chart-bar mr-2"></i>분석 보기
        </button>
      </div>
    </div>
  `
}

// 응답 저장
async function saveResponses(responses, respondent) {
  try {
    // 응답자 등록
    const respResponse = await axios.post('/api/respondents', {
      name: respondent.name,
      email: respondent.email,
      department: respondent.dept || '',
      position: respondent.position || '',
      level: document.getElementById('target-level')?.value || 'all'
    })
    
    const respondentId = respResponse.data.id
    
    // 응답 저장
    for (const response of responses) {
      await axios.post('/api/assessment-responses', {
        session_id: currentSessionId || 1,
        respondent_id: respondentId,
        question_text: response.question_text,
        competency: response.competency,
        response_value: response.response_value
      })
    }
    
    alert('응답이 성공적으로 저장되었습니다!')
  } catch (error) {
    console.error('Error saving responses:', error)
    alert('응답 저장 중 오류가 발생했습니다: ' + (error.response?.data?.error || error.message))
  }
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
    }, {
      timeout: 60000 // 60초 타임아웃
    })
    
    if (response.data.success) {
      chatMessages.push({ role: 'assistant', content: response.data.message })
      updateChatUI()
    } else {
      alert(response.data.error)
    }
  } catch (error) {
    console.error('Error sending chat message:', error)
    const errorDetail = error.response?.data?.error || error.message || '알 수 없는 오류'
    alert(`메시지 전송 중 오류가 발생했습니다: ${errorDetail}`)
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
  document.getElementById('competency-search')?.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
      searchCompetencies()
    }
  })
})

// ============================================================================
// Phase 2: 분석 및 인사이트
// ============================================================================

// 응답자 목록 로드
async function loadRespondents() {
  try {
    const response = await axios.get('/api/respondents')
    
    if (response.data.success && response.data.data.length > 0) {
      const listDiv = document.getElementById('respondents-list')
      listDiv.innerHTML = response.data.data.map(resp => `
        <div class="flex items-center justify-between p-4 border rounded-lg hover:bg-gray-50 cursor-pointer"
             onclick="loadAnalysis(${resp.id})">
          <div>
            <div class="font-medium text-gray-800">${resp.name}</div>
            <div class="text-sm text-gray-500">${resp.email} · ${resp.department || '부서 미지정'} · ${resp.position || '직책 미지정'}</div>
          </div>
          <button class="px-3 py-1 bg-blue-600 text-white rounded text-sm hover:bg-blue-700">
            <i class="fas fa-chart-line mr-1"></i>결과 보기
          </button>
        </div>
      `).join('')
    } else {
      document.getElementById('respondents-list').innerHTML = 
        '<p class="text-gray-400 text-sm">아직 응답자가 없습니다</p>'
    }
  } catch (error) {
    console.error('Error loading respondents:', error)
    document.getElementById('respondents-list').innerHTML = 
      '<p class="text-red-500 text-sm">응답자 목록을 불러오는 중 오류가 발생했습니다</p>'
  }
}

// 개별 분석 결과 로드
async function loadAnalysis(respondentId) {
  const reportDiv = document.getElementById('analysis-report')
  reportDiv.classList.remove('hidden')
  reportDiv.innerHTML = `
    <div class="text-center py-8">
      <i class="fas fa-spinner fa-spin text-4xl text-blue-600 mb-4"></i>
      <p class="text-gray-600">분석 결과를 불러오는 중...</p>
    </div>
  `
  
  try {
    const response = await axios.get(`/api/analysis/${respondentId}`)
    
    if (response.data.success) {
      renderAnalysisReport(response.data.data)
      
      // AI 인사이트 생성
      loadAIInsights(respondentId, response.data.data)
    } else {
      reportDiv.innerHTML = `
        <div class="text-center py-8">
          <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
          <p class="text-red-600">${response.data.error}</p>
        </div>
      `
    }
  } catch (error) {
    console.error('Error loading analysis:', error)
    reportDiv.innerHTML = `
      <div class="text-center py-8">
        <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
        <p class="text-red-600">분석 결과를 불러오는 중 오류가 발생했습니다</p>
      </div>
    `
  }
}

// 분석 리포트 렌더링
function renderAnalysisReport(data) {
  const reportDiv = document.getElementById('analysis-report')
  const { respondent, analysis, summary } = data
  
  reportDiv.innerHTML = `
    <!-- 리포트 헤더 -->
    <div class="bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-lg p-6 mb-6">
      <div class="flex justify-between items-start">
        <div>
          <h3 class="text-2xl font-bold mb-2">역량 진단 결과 리포트</h3>
          <p class="text-blue-100">${respondent.name} · ${respondent.position || '직책 미지정'}</p>
          <p class="text-sm text-blue-200">${respondent.email}</p>
        </div>
        <button onclick="document.getElementById('analysis-report').classList.add('hidden')" 
                class="text-white hover:bg-white/20 rounded px-3 py-1">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>
    
    <!-- 전체 요약 -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
      <div class="bg-blue-50 rounded-lg p-4 border-l-4 border-blue-600">
        <div class="text-sm text-gray-600 mb-1">전체 평균</div>
        <div class="text-3xl font-bold text-blue-600">${summary.overallAverage}</div>
        <div class="text-xs text-gray-500">총 ${summary.totalQuestions}개 문항</div>
      </div>
      <div class="bg-green-50 rounded-lg p-4 border-l-4 border-green-600">
        <div class="text-sm text-gray-600 mb-1">최고 점수</div>
        <div class="text-2xl font-bold text-green-600">${summary.highestScore.average}</div>
        <div class="text-xs text-gray-500">${summary.highestScore.competency}</div>
      </div>
      <div class="bg-orange-50 rounded-lg p-4 border-l-4 border-orange-600">
        <div class="text-sm text-gray-600 mb-1">최저 점수</div>
        <div class="text-2xl font-bold text-orange-600">${summary.lowestScore.average}</div>
        <div class="text-xs text-gray-500">${summary.lowestScore.competency}</div>
      </div>
      <div class="bg-purple-50 rounded-lg p-4 border-l-4 border-purple-600">
        <div class="text-sm text-gray-600 mb-1">분석 역량</div>
        <div class="text-3xl font-bold text-purple-600">${summary.totalCompetencies}</div>
        <div class="text-xs text-gray-500">개 역량</div>
      </div>
    </div>
    
    <!-- 역량별 점수 차트 -->
    <div class="bg-white rounded-lg border p-6 mb-6">
      <h4 class="text-lg font-semibold text-gray-800 mb-4">
        <i class="fas fa-chart-bar mr-2 text-blue-600"></i>역량별 점수
      </h4>
      <canvas id="competency-chart" height="80"></canvas>
    </div>
    
    <!-- 강점 및 개선영역 -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
      <div class="bg-green-50 rounded-lg p-6 border border-green-200">
        <h4 class="text-lg font-semibold text-green-800 mb-3">
          <i class="fas fa-thumbs-up mr-2"></i>강점 역량
        </h4>
        <ul class="space-y-2">
          ${summary.strengths.map(s => `
            <li class="flex items-center text-green-700">
              <i class="fas fa-check-circle mr-2"></i>${s}
            </li>
          `).join('')}
        </ul>
      </div>
      <div class="bg-orange-50 rounded-lg p-6 border border-orange-200">
        <h4 class="text-lg font-semibold text-orange-800 mb-3">
          <i class="fas fa-arrow-up mr-2"></i>개선 영역
        </h4>
        <ul class="space-y-2">
          ${summary.improvements.map(i => `
            <li class="flex items-center text-orange-700">
              <i class="fas fa-exclamation-circle mr-2"></i>${i}
            </li>
          `).join('')}
        </ul>
      </div>
    </div>
    
    <!-- 역량별 상세 분석 -->
    <div class="bg-white rounded-lg border p-6 mb-6">
      <h4 class="text-lg font-semibold text-gray-800 mb-4">
        <i class="fas fa-list-alt mr-2 text-purple-600"></i>역량별 상세 분석
      </h4>
      <div class="space-y-4">
        ${analysis.map(comp => `
          <div class="border rounded-lg p-4 hover:shadow-md transition-shadow">
            <div class="flex justify-between items-start mb-3">
              <div>
                <h5 class="font-semibold text-gray-800">${comp.competency}</h5>
                <p class="text-sm text-gray-500">${comp.description}</p>
              </div>
              <div class="text-right">
                <div class="text-2xl font-bold ${comp.average >= 4 ? 'text-green-600' : comp.average >= 3 ? 'text-blue-600' : 'text-orange-600'}">
                  ${comp.average}
                </div>
                <div class="text-xs text-gray-500">평균 점수</div>
              </div>
            </div>
            <div class="grid grid-cols-4 gap-2 text-sm mb-3">
              <div class="bg-gray-50 rounded p-2 text-center">
                <div class="text-gray-500">문항 수</div>
                <div class="font-semibold">${comp.count}</div>
              </div>
              <div class="bg-gray-50 rounded p-2 text-center">
                <div class="text-gray-500">최고점</div>
                <div class="font-semibold">${comp.max}</div>
              </div>
              <div class="bg-gray-50 rounded p-2 text-center">
                <div class="text-gray-500">최저점</div>
                <div class="font-semibold">${comp.min}</div>
              </div>
              <div class="bg-gray-50 rounded p-2 text-center">
                <div class="text-gray-500">표준편차</div>
                <div class="font-semibold">${comp.stdDev}</div>
              </div>
            </div>
            <div class="relative pt-1">
              <div class="overflow-hidden h-2 text-xs flex rounded bg-gray-200">
                <div style="width:${(comp.average / 5) * 100}%" 
                     class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center ${comp.average >= 4 ? 'bg-green-500' : comp.average >= 3 ? 'bg-blue-500' : 'bg-orange-500'}">
                </div>
              </div>
            </div>
          </div>
        `).join('')}
      </div>
    </div>
    
    <!-- AI 인사이트 -->
    <div id="ai-insights" class="bg-gradient-to-br from-purple-50 to-blue-50 rounded-lg border-2 border-purple-200 p-6">
      <h4 class="text-lg font-semibold text-purple-800 mb-3">
        <i class="fas fa-brain mr-2"></i>AI 인사이트
      </h4>
      <div class="text-center py-8">
        <i class="fas fa-spinner fa-spin text-3xl text-purple-600 mb-2"></i>
        <p class="text-gray-600">AI가 인사이트를 생성하고 있습니다...</p>
      </div>
    </div>
  `
  
  // 차트 렌더링
  renderCompetencyChart(analysis)
}

// 역량 차트 렌더링
function renderCompetencyChart(analysis) {
  const ctx = document.getElementById('competency-chart')
  if (!ctx) return
  
  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: analysis.map(a => a.competency),
      datasets: [{
        label: '평균 점수',
        data: analysis.map(a => a.average),
        backgroundColor: analysis.map(a => 
          a.average >= 4 ? 'rgba(34, 197, 94, 0.8)' : 
          a.average >= 3 ? 'rgba(59, 130, 246, 0.8)' : 
          'rgba(249, 115, 22, 0.8)'
        ),
        borderColor: analysis.map(a => 
          a.average >= 4 ? 'rgb(34, 197, 94)' : 
          a.average >= 3 ? 'rgb(59, 130, 246)' : 
          'rgb(249, 115, 22)'
        ),
        borderWidth: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      scales: {
        y: {
          beginAtZero: true,
          max: 5,
          ticks: {
            stepSize: 1
          }
        }
      },
      plugins: {
        legend: {
          display: false
        },
        tooltip: {
          callbacks: {
            label: function(context) {
              return `평균: ${context.parsed.y}점`
            }
          }
        }
      }
    }
  })
}

// AI 인사이트 로드
async function loadAIInsights(respondentId, analysisData) {
  const insightsDiv = document.getElementById('ai-insights')
  
  try {
    const response = await axios.post(`/api/analysis/${respondentId}/insights`, analysisData, {
      timeout: 60000
    })
    
    if (response.data.success) {
      const insights = response.data.insights
      const isDemo = response.data.demo
      
      insightsDiv.innerHTML = `
        <div class="flex items-center justify-between mb-4">
          <h4 class="text-lg font-semibold text-purple-800">
            <i class="fas fa-brain mr-2"></i>AI 인사이트
          </h4>
          ${isDemo ? '<span class="text-xs bg-yellow-200 text-yellow-800 px-2 py-1 rounded">데모 모드</span>' : ''}
        </div>
        
        <!-- 전반적 평가 -->
        <div class="bg-white rounded-lg p-4 mb-4">
          <h5 class="font-semibold text-gray-800 mb-2">
            <i class="fas fa-star text-yellow-500 mr-2"></i>전반적 평가
          </h5>
          <p class="text-gray-700 leading-relaxed">${insights.overall}</p>
        </div>
        
        <!-- 강점 분석 -->
        <div class="bg-white rounded-lg p-4 mb-4">
          <h5 class="font-semibold text-gray-800 mb-2">
            <i class="fas fa-trophy text-green-500 mr-2"></i>강점 역량 분석
          </h5>
          <p class="text-gray-700 leading-relaxed">${insights.strengths}</p>
        </div>
        
        <!-- 개선 영역 -->
        <div class="bg-white rounded-lg p-4 mb-4">
          <h5 class="font-semibold text-gray-800 mb-2">
            <i class="fas fa-arrow-trend-up text-orange-500 mr-2"></i>개선 영역
          </h5>
          <p class="text-gray-700 leading-relaxed">${insights.improvements}</p>
        </div>
        
        <!-- 추천 사항 -->
        <div class="bg-white rounded-lg p-4">
          <h5 class="font-semibold text-gray-800 mb-3">
            <i class="fas fa-lightbulb text-blue-500 mr-2"></i>추천 사항
          </h5>
          <ul class="space-y-2">
            ${insights.recommendations.map((rec, idx) => `
              <li class="flex items-start text-gray-700">
                <span class="flex-shrink-0 w-6 h-6 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center text-sm font-semibold mr-2">
                  ${idx + 1}
                </span>
                <span>${rec}</span>
              </li>
            `).join('')}
          </ul>
        </div>
      `
    }
  } catch (error) {
    console.error('Error loading AI insights:', error)
    insightsDiv.innerHTML = `
      <h4 class="text-lg font-semibold text-purple-800 mb-3">
        <i class="fas fa-brain mr-2"></i>AI 인사이트
      </h4>
      <div class="bg-red-50 border border-red-200 rounded-lg p-4">
        <p class="text-red-600">AI 인사이트를 생성하는 중 오류가 발생했습니다</p>
      </div>
    `
  }
}

// 탭 전환 시 응답자 목록 로드
const originalShowTab = showTab
window.showTab = function(tabName) {
  originalShowTab.call(this, tabName)
  if (tabName === 'analytics') {
    loadRespondents()
  }
}

// ============================================================================
// 진단 실행 (Execute Assessment)
// ============================================================================

// 전역 변수
let assessmentQuestions = []
let currentPage = 0
let questionsPerPage = 5  // 기본값
let assessmentResponses = []
let currentRespondentInfo = null
let scaleConfig = {
  type: '5-point',
  labels: ['전혀 그렇지 않다', '그렇지 않다', '보통이다', '그렇다', '매우 그렇다']
}

// 척도 레이블 업데이트
function updateScaleLabels() {
  const scaleType = document.getElementById('scale-type').value
  const container = document.getElementById('scale-labels-grid')
  
  let defaultLabels = []
  let scaleCount = 0
  
  switch(scaleType) {
    case 'single':
      scaleCount = 1
      defaultLabels = ['확인']
      break
    case 'binary':
      scaleCount = 2
      defaultLabels = ['아니오 (X)', '예 (O)']
      break
    case '3-point':
      scaleCount = 3
      defaultLabels = ['낮음', '보통', '높음']
      break
    case '5-point':
      scaleCount = 5
      defaultLabels = ['전혀 그렇지 않다', '그렇지 않다', '보통이다', '그렇다', '매우 그렇다']
      break
    case '7-point':
      scaleCount = 7
      defaultLabels = ['매우 그렇지 않다', '그렇지 않다', '약간 그렇지 않다', '보통', '약간 그렇다', '그렇다', '매우 그렇다']
      break
    case '10-point':
      scaleCount = 10
      defaultLabels = Array.from({length: 10}, (_, i) => `${i + 1}점`)
      break
  }
  
  scaleConfig.type = scaleType
  scaleConfig.labels = defaultLabels
  
  container.innerHTML = defaultLabels.map((label, idx) => `
    <div class="flex items-center gap-3">
      <span class="flex-shrink-0 w-12 text-center font-semibold text-gray-700 bg-white rounded px-2 py-1 border">
        ${idx + 1}
      </span>
      <input 
        type="text" 
        value="${label}"
        placeholder="척도 ${idx + 1}의 의미"
        class="flex-1 rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
        onchange="updateScaleLabel(${idx}, this.value)"
      >
    </div>
  `).join('')
}

// 개별 척도 레이블 업데이트
function updateScaleLabel(index, value) {
  scaleConfig.labels[index] = value
}

// 척도 버튼 렌더링
function renderScaleButtons(questionIdx, currentResponse) {
  const scaleCount = scaleConfig.labels.length
  const labels = scaleConfig.labels
  
  // 그리드 컬럼 수 결정
  let gridCols = 'grid-cols-5'
  if (scaleCount === 1) gridCols = 'grid-cols-1'
  else if (scaleCount === 2) gridCols = 'grid-cols-2'
  else if (scaleCount === 3) gridCols = 'grid-cols-3'
  else if (scaleCount === 7) gridCols = 'grid-cols-7'
  else if (scaleCount === 10) gridCols = 'grid-cols-5'
  
  return `
    <div class="grid ${gridCols} gap-2">
      ${Array.from({length: scaleCount}, (_, i) => i + 1).map(value => `
        <button 
          onclick="selectAnswer(${questionIdx}, ${value})"
          class="response-btn py-4 border-2 rounded-lg transition-all ${
            currentResponse === value 
              ? 'border-blue-500 bg-blue-50 ring-2 ring-blue-200' 
              : 'border-gray-300 hover:border-blue-400 hover:bg-blue-50'
          }">
          <div class="text-2xl font-bold text-gray-700">${value}</div>
          <div class="text-xs text-gray-500 mt-1 px-1">
            ${labels[value - 1] ? labels[value - 1].replace(/\n/g, '<br>') : ''}
          </div>
        </button>
      `).join('')}
    </div>
    ${scaleCount > 1 ? `
    <div class="flex justify-between text-xs text-gray-500 px-1 mt-2">
      <span>${labels[0] || ''}</span>
      <span>${labels[scaleCount - 1] || ''}</span>
    </div>
    ` : ''}
  `
}

// 문항 디스플레이 설정
function setQuestionDisplay(count) {
  questionsPerPage = count
  
  // 버튼 스타일 업데이트
  document.querySelectorAll('.display-btn').forEach(btn => {
    btn.classList.remove('border-blue-500', 'bg-blue-50', 'ring-2', 'ring-blue-200')
    btn.classList.add('border-gray-300')
  })
  event.target.closest('button').classList.remove('border-gray-300')
  event.target.closest('button').classList.add('border-blue-500', 'bg-blue-50', 'ring-2', 'ring-blue-200')
  
  // 선택된 옵션 표시
  const displayText = count === -1 ? '전체' : `${count}개씩`
  document.getElementById('selected-display').innerHTML = `
    선택된 디스플레이: <span class="font-semibold text-blue-600">${displayText}</span>
  `
  
  // 진단 시작 버튼 활성화
  checkStartButtonState()
}

// 진단 시작 버튼 상태 체크
function checkStartButtonState() {
  const name = document.getElementById('exec-name').value.trim()
  const email = document.getElementById('exec-email').value.trim()
  const hasDisplay = questionsPerPage !== null
  
  const startBtn = document.getElementById('start-assessment-btn')
  if (name && email && hasDisplay) {
    startBtn.disabled = false
    startBtn.classList.remove('opacity-50', 'cursor-not-allowed')
  } else {
    startBtn.disabled = true
    startBtn.classList.add('opacity-50', 'cursor-not-allowed')
  }
}

// 입력 필드 변경 감지 및 초기화
document.addEventListener('DOMContentLoaded', () => {
  const nameInput = document.getElementById('exec-name')
  const emailInput = document.getElementById('exec-email')
  
  if (nameInput) nameInput.addEventListener('input', checkStartButtonState)
  if (emailInput) emailInput.addEventListener('input', checkStartButtonState)
  
  // 척도 레이블 초기화
  if (document.getElementById('scale-type')) {
    updateScaleLabels()
  }
})

// 진단 시작
async function startAssessment() {
  const name = document.getElementById('exec-name').value.trim()
  const email = document.getElementById('exec-email').value.trim()
  const department = document.getElementById('exec-department').value.trim()
  const position = document.getElementById('exec-position').value.trim()
  const level = document.getElementById('exec-level').value
  
  if (!name || !email) {
    alert('이름과 이메일은 필수 입력 항목입니다')
    return
  }
  
  // 응답자 정보 및 척도 정보 저장
  currentRespondentInfo = {
    name, email, department, position, level
  }
  
  // 척도 설정 저장
  const scaleType = document.getElementById('scale-type').value
  scaleConfig.type = scaleType
  
  try {
    // 진단 문항 로드
    const response = await axios.get('/api/assessment-questions')
    
    if (!response.data.success || response.data.count === 0) {
      alert('진단 문항이 없습니다. 먼저 진단 설계 탭에서 문항을 생성하세요.')
      return
    }
    
    assessmentQuestions = response.data.data
    assessmentResponses = new Array(assessmentQuestions.length).fill(null)
    currentPage = 0
    
    // 진단 영역 표시
    document.getElementById('respondent-info-section').style.display = 'none'
    document.getElementById('display-settings-section').style.display = 'none'
    document.querySelector('#tab-execute .flex.justify-center').style.display = 'none'
    document.getElementById('assessment-questions-area').classList.remove('hidden')
    
    // 총 문항 수 표시
    document.getElementById('total-questions').textContent = assessmentQuestions.length
    
    // 첫 페이지 렌더링
    renderQuestionsPage()
    
  } catch (error) {
    console.error('Error starting assessment:', error)
    alert('진단을 시작하는 중 오류가 발생했습니다: ' + (error.response?.data?.error || error.message))
  }
}

// 문항 페이지 렌더링
function renderQuestionsPage() {
  const container = document.getElementById('questions-container')
  
  // 페이지에 표시할 문항 계산
  let startIdx, endIdx
  
  if (questionsPerPage === -1) {
    // 전체 표시
    startIdx = 0
    endIdx = assessmentQuestions.length
  } else {
    startIdx = currentPage * questionsPerPage
    endIdx = Math.min(startIdx + questionsPerPage, assessmentQuestions.length)
  }
  
  const pageQuestions = assessmentQuestions.slice(startIdx, endIdx)
  
  // 문항 HTML 생성
  container.innerHTML = pageQuestions.map((q, localIdx) => {
    const globalIdx = startIdx + localIdx
    const currentResponse = assessmentResponses[globalIdx]
    
    return `
      <div class="border rounded-lg p-6 bg-white" data-question-idx="${globalIdx}">
        <!-- 문항 헤더 -->
        <div class="mb-4">
          <div class="flex items-start justify-between mb-2">
            <div class="flex-1">
              <span class="inline-block px-2 py-1 bg-blue-100 text-blue-700 text-xs font-medium rounded mb-2">
                ${q.competency}
              </span>
              <h4 class="text-lg font-medium text-gray-800">
                Q${globalIdx + 1}. ${q.question_text}
              </h4>
            </div>
            ${currentResponse !== null ? `
              <span class="ml-4 flex-shrink-0 px-3 py-1 bg-green-100 text-green-700 text-sm font-medium rounded">
                <i class="fas fa-check mr-1"></i>응답 완료
              </span>
            ` : ''}
          </div>
        </div>
        
        <!-- 응답 척도 (동적) -->
        <div class="space-y-2">
          ${renderScaleButtons(globalIdx, currentResponse)}
        </div>
      </div>
    `
  }).join('')
  
  // 진행률 업데이트
  updateProgress()
  
  // 네비게이션 버튼 상태 업데이트
  updateNavigationButtons()
}

// 응답 선택
function selectAnswer(questionIdx, value) {
  assessmentResponses[questionIdx] = value
  
  // 해당 문항 버튼 스타일 업데이트
  const questionDiv = document.querySelector(`[data-question-idx="${questionIdx}"]`)
  if (questionDiv) {
    questionDiv.querySelectorAll('.response-btn').forEach((btn, idx) => {
      if (idx + 1 === value) {
        btn.classList.remove('border-gray-300', 'hover:border-blue-400')
        btn.classList.add('border-blue-500', 'bg-blue-50', 'ring-2', 'ring-blue-200')
      } else {
        btn.classList.remove('border-blue-500', 'bg-blue-50', 'ring-2', 'ring-blue-200')
        btn.classList.add('border-gray-300', 'hover:border-blue-400')
      }
    })
    
    // 응답 완료 표시 추가/업데이트
    const existingBadge = questionDiv.querySelector('.bg-green-100')
    if (!existingBadge) {
      const headerDiv = questionDiv.querySelector('.flex.items-start.justify-between')
      headerDiv.insertAdjacentHTML('beforeend', `
        <span class="ml-4 flex-shrink-0 px-3 py-1 bg-green-100 text-green-700 text-sm font-medium rounded">
          <i class="fas fa-check mr-1"></i>응답 완료
        </span>
      `)
    }
  }
  
  // 진행률 업데이트
  updateProgress()
  
  // 네비게이션 버튼 업데이트
  updateNavigationButtons()
}

// 진행률 업데이트
function updateProgress() {
  const answeredCount = assessmentResponses.filter(r => r !== null).length
  document.getElementById('current-progress').textContent = answeredCount
}

// 네비게이션 버튼 상태 업데이트
function updateNavigationButtons() {
  const prevBtn = document.getElementById('prev-btn')
  const nextBtn = document.getElementById('next-btn')
  const submitBtn = document.getElementById('submit-btn')
  
  // 전체 표시 모드인 경우
  if (questionsPerPage === -1) {
    prevBtn.classList.add('hidden')
    nextBtn.classList.add('hidden')
    
    // 모든 문항에 응답했는지 체크
    const allAnswered = assessmentResponses.every(r => r !== null)
    if (allAnswered) {
      submitBtn.classList.remove('hidden')
    } else {
      submitBtn.classList.add('hidden')
    }
    return
  }
  
  // 페이지 모드
  const totalPages = Math.ceil(assessmentQuestions.length / questionsPerPage)
  const isFirstPage = currentPage === 0
  const isLastPage = currentPage === totalPages - 1
  
  // 이전 버튼
  if (isFirstPage) {
    prevBtn.disabled = true
    prevBtn.classList.add('opacity-50', 'cursor-not-allowed')
  } else {
    prevBtn.disabled = false
    prevBtn.classList.remove('opacity-50', 'cursor-not-allowed')
  }
  
  // 다음/제출 버튼
  if (isLastPage) {
    // 현재 페이지의 모든 문항에 응답했는지 체크
    const startIdx = currentPage * questionsPerPage
    const endIdx = Math.min(startIdx + questionsPerPage, assessmentQuestions.length)
    const allAnswered = assessmentResponses.every(r => r !== null)
    
    nextBtn.classList.add('hidden')
    
    if (allAnswered) {
      submitBtn.classList.remove('hidden')
    } else {
      submitBtn.classList.add('hidden')
    }
  } else {
    nextBtn.classList.remove('hidden')
    submitBtn.classList.add('hidden')
    
    // 현재 페이지의 문항에 응답이 있는지 체크
    const startIdx = currentPage * questionsPerPage
    const endIdx = Math.min(startIdx + questionsPerPage, assessmentQuestions.length)
    const pageAnswered = assessmentResponses.slice(startIdx, endIdx).some(r => r !== null)
    
    nextBtn.disabled = false
    nextBtn.classList.remove('opacity-50', 'cursor-not-allowed')
  }
}

// 이전 페이지
function previousPage() {
  if (currentPage > 0) {
    currentPage--
    renderQuestionsPage()
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

// 다음 페이지
function nextPage() {
  const totalPages = Math.ceil(assessmentQuestions.length / questionsPerPage)
  if (currentPage < totalPages - 1) {
    currentPage++
    renderQuestionsPage()
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

// 진단 제출
async function submitAssessment() {
  // 모든 문항에 응답했는지 확인
  const unanswered = assessmentResponses.filter(r => r === null).length
  if (unanswered > 0) {
    alert(`아직 ${unanswered}개의 문항에 응답하지 않았습니다. 모든 문항에 응답해주세요.`)
    return
  }
  
  if (!confirm('진단을 제출하시겠습니까? 제출 후에는 수정할 수 없습니다.')) {
    return
  }
  
  try {
    // 응답자 등록
    const respResponse = await axios.post('/api/respondents', {
      name: currentRespondentInfo.name,
      email: currentRespondentInfo.email,
      department: currentRespondentInfo.department,
      position: currentRespondentInfo.position,
      level: currentRespondentInfo.level
    })
    
    const respondentId = respResponse.data.id
    
    // 진단 세션 생성
    const sessionResponse = await axios.post('/api/assessment-sessions', {
      session_name: `${currentRespondentInfo.name}의 진단 (${new Date().toLocaleDateString()})`,
      session_type: 'self',
      target_level: currentRespondentInfo.level,
      status: 'completed'
    })
    
    const sessionId = sessionResponse.data.id
    
    // 응답 저장
    for (let i = 0; i < assessmentQuestions.length; i++) {
      await axios.post('/api/assessment-responses', {
        session_id: sessionId,
        respondent_id: respondentId,
        question_id: assessmentQuestions[i].id,
        response_value: assessmentResponses[i]
      })
    }
    
    // 완료 메시지
    const avgScore = (assessmentResponses.reduce((sum, val) => sum + val, 0) / assessmentResponses.length).toFixed(2)
    
    const container = document.getElementById('questions-container')
    container.innerHTML = `
      <div class="text-center py-12">
        <i class="fas fa-check-circle text-6xl text-green-600 mb-4"></i>
        <h3 class="text-2xl font-bold text-gray-800 mb-2">진단이 완료되었습니다!</h3>
        <p class="text-gray-600 mb-6">응답해 주셔서 감사합니다.</p>
        
        <div class="bg-gray-50 rounded-lg p-6 mb-6 inline-block text-left">
          <h4 class="font-semibold text-gray-800 mb-3">응답 요약</h4>
          <div class="space-y-2 text-sm text-gray-600">
            <p><strong>응답자:</strong> ${currentRespondentInfo.name}</p>
            <p><strong>이메일:</strong> ${currentRespondentInfo.email}</p>
            <p><strong>총 문항 수:</strong> ${assessmentQuestions.length}개</p>
            <p><strong>평균 점수:</strong> ${avgScore}점</p>
          </div>
        </div>
        
        <div class="flex gap-3 justify-center">
          <button onclick="showTab('analytics')" class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
            <i class="fas fa-chart-bar mr-2"></i>분석 결과 보기
          </button>
          <button onclick="location.reload()" class="px-6 py-3 bg-gray-500 text-white rounded-lg hover:bg-gray-600">
            <i class="fas fa-home mr-2"></i>처음으로
          </button>
        </div>
      </div>
    `
    
    // 네비게이션 버튼 숨기기
    document.getElementById('prev-btn').style.display = 'none'
    document.getElementById('next-btn').style.display = 'none'
    document.getElementById('submit-btn').style.display = 'none'
    
  } catch (error) {
    console.error('Error submitting assessment:', error)
    alert('진단 제출 중 오류가 발생했습니다: ' + (error.response?.data?.error || error.message))
  }
}
