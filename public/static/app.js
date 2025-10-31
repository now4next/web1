// ============================================================================
// 전역 상태 관리
// ============================================================================

let selectedCompetencies = []
let chatMessages = []
let generatedData = null // AI 생성된 데이터 저장
let editableQuestions = [] // 편집 가능한 문항 목록
let currentSessionId = null // 현재 진단 세션 ID

// axios 로드 확인
window.addEventListener('load', () => {
  if (typeof axios === 'undefined') {
    console.error('axios is not loaded!')
  } else {
    console.log('axios loaded successfully')
  }
})

// ============================================================================
// 탭 전환
// ============================================================================

function showTab(tabName, buttonElement) {
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
  
  // buttonElement가 전달된 경우에만 스타일 업데이트
  if (buttonElement) {
    const btn = buttonElement.closest ? buttonElement.closest('button') : buttonElement
    if (btn) {
      btn.classList.add('bg-blue-100', 'text-blue-700')
    }
  }
}

// ============================================================================
// Phase 1: 진단 설계
// ============================================================================

// 역량 검색
async function searchCompetencies() {
  console.log('searchCompetencies called')
  
  const inputEl = document.getElementById('competency-search')
  const resultsDiv = document.getElementById('search-results')
  
  if (!inputEl) {
    console.error('competency-search input not found')
    return
  }
  
  if (!resultsDiv) {
    console.error('search-results div not found')
    return
  }
  
  const query = inputEl.value
  console.log('Search query:', query)
  
  if (!query.trim()) {
    resultsDiv.innerHTML = '<p class="text-gray-400 text-sm">역량을 검색하세요</p>'
    return
  }
  
  try {
    resultsDiv.innerHTML = '<p class="text-gray-400 text-sm">검색 중...</p>'
    
    console.log('Sending request to:', `/api/competencies/search?q=${encodeURIComponent(query)}`)
    const response = await axios.get(`/api/competencies/search?q=${encodeURIComponent(query)}`)
    console.log('Search response:', response.data)
    
    if (response.data.success && response.data.data.length > 0) {
      resultsDiv.innerHTML = response.data.data.map((comp, index) => {
        return `
          <div class="flex items-center justify-between py-2 px-3 hover:bg-gray-50 rounded cursor-pointer mb-2 border search-result-item" 
               data-comp-id="${comp.id}"
               data-comp-keyword="${comp.keyword.replace(/"/g, '&quot;')}"
               data-comp-description="${comp.description.replace(/"/g, '&quot;')}">
            <div>
              <div class="font-medium text-gray-800">${comp.keyword}</div>
              <div class="text-xs text-gray-500">${comp.model_name} · ${comp.description}</div>
            </div>
            <button class="text-blue-600 hover:text-blue-700">
              <i class="fas fa-plus-circle"></i>
            </button>
          </div>
        `
      }).join('')
      
      // 이벤트 리스너 추가
      document.querySelectorAll('.search-result-item').forEach(item => {
        item.addEventListener('click', function() {
          const id = parseInt(this.getAttribute('data-comp-id'))
          const keyword = this.getAttribute('data-comp-keyword')
          const description = this.getAttribute('data-comp-description')
          selectCompetency(id, keyword, description)
        })
      })
    } else {
      resultsDiv.innerHTML = '<p class="text-gray-400 text-sm">검색 결과가 없습니다</p>'
    }
  } catch (error) {
    console.error('Error searching competencies:', error)
    console.error('Error details:', error.response ? error.response.data : error.message)
    resultsDiv.innerHTML = `<p class="text-red-500 text-sm">검색 중 오류가 발생했습니다: ${error.message}</p>`
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
    <div class="flex items-center justify-between py-2 px-3 bg-blue-50 rounded mb-2 border border-blue-200 selected-comp-item" data-comp-id="${comp.id}">
      <div>
        <div class="font-medium text-gray-800">${comp.keyword}</div>
        <div class="text-xs text-gray-600">${comp.description}</div>
      </div>
      <button class="remove-comp-btn text-red-600 hover:text-red-700">
        <i class="fas fa-times-circle"></i>
      </button>
    </div>
  `).join('')
  
  // 삭제 버튼 이벤트 리스너 추가
  document.querySelectorAll('.remove-comp-btn').forEach(btn => {
    btn.addEventListener('click', function(e) {
      e.stopPropagation()
      const id = parseInt(this.closest('.selected-comp-item').getAttribute('data-comp-id'))
      removeCompetency(id)
    })
  })
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
    
    <div class="mt-6">
      <button onclick="showSaveDialog()" class="w-full px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
        <i class="fas fa-save mr-2"></i>진단 저장
      </button>
      <div class="mt-4 p-4 bg-blue-50 border border-blue-200 rounded-lg">
        <p class="text-sm text-blue-800">
          <i class="fas fa-info-circle mr-2"></i>
          진단을 시작하려면 아래 <strong>Phase 2: 진단 설정</strong>으로 스크롤하여 응답자 정보와 설정을 완료한 후 진단을 시작하세요.
        </p>
      </div>
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
  
  // Phase 2의 진단 설정으로 스크롤
  // Phase 2 섹션이 보이도록 스크롤
  const phase2Section = document.querySelector('.bg-white.rounded-lg.shadow.p-6.mb-6:nth-child(2)')
  if (phase2Section) {
    phase2Section.scrollIntoView({ behavior: 'smooth', block: 'start' })
    
    // 알림 메시지 표시
    setTimeout(() => {
      alert('아래 Phase 2: 진단 설정에서 응답자 정보와 척도를 설정한 후 진단을 시작하세요.')
    }, 500)
  } else {
    // Phase 2가 없는 경우 기존 방식 사용
    const contentDiv = document.getElementById('generation-content')
    
    contentDiv.innerHTML = `
      <div class="bg-white rounded-lg p-6">
        <h3 class="text-xl font-bold text-gray-800 mb-4">
          <i class="fas fa-sliders-h mr-2 text-blue-600"></i>진단 응답 척도 설정
        </h3>
        
        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700 mb-2">척도 유형</label>
          <select id="scale-type-old" class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
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
// Phase 3: AI 실행 지원
// ============================================================================

// 현재 선택된 어시스턴트
let currentAssistant = null

// 어시스턴트 설정
const assistantProfiles = {
  consulting: {
    name: 'AI 컨설턴트',
    icon: 'fa-briefcase',
    color: 'blue',
    gradient: 'from-blue-600 to-blue-700',
    bgColor: 'bg-blue-600',
    systemPrompt: '당신은 조직 역량 개발 전문 컨설턴트입니다. 전략적이고 분석적인 관점에서 조직의 역량 개발 방향을 제시하며, 데이터 기반의 구체적인 실행 계획과 로드맵을 제공합니다. 비즈니스 영향도를 고려한 우선순위와 투자 대비 효과를 중시하는 전문적이고 논리적인 어조로 대화합니다.',
    greeting: '안녕하세요. AI 컨설턴트입니다.\n\n조직의 역량 개발 전략에 대해 함께 논의하겠습니다. 진단 결과를 바탕으로 전략적 방향성과 실행 계획을 수립하는 데 도움을 드리겠습니다.'
  },
  coaching: {
    name: 'AI 코치',
    icon: 'fa-comments',
    color: 'green',
    gradient: 'from-green-600 to-green-700',
    bgColor: 'bg-green-600',
    systemPrompt: '당신은 역량 개발 전문 코치입니다. 질문을 통해 스스로 답을 찾도록 돕고, 강점을 발견하고 활용하도록 격려하며, 자기주도적 성장을 촉진합니다. 경청하고 공감하며 긍정적이고 지지적인 어조로 대화합니다. 열린 질문을 통해 내담자의 통찰을 이끌어냅니다.',
    greeting: '반갑습니다! AI 코치입니다.\n\n당신의 성장 여정을 함께하게 되어 기쁩니다. 진단 결과에서 어떤 부분이 가장 눈에 띄시나요? 함께 이야기 나누면서 성장의 실마리를 찾아보겠습니다.'
  },
  mentoring: {
    name: 'AI 멘토',
    icon: 'fa-user-tie',
    color: 'purple',
    gradient: 'from-purple-600 to-purple-700',
    bgColor: 'bg-purple-600',
    systemPrompt: '당신은 풍부한 실무 경험을 가진 시니어 멘토입니다. 실제 현장에서의 경험과 노하우를 공유하며, 구체적인 사례와 실용적인 조언을 제공합니다. 따뜻하고 친근하면서도 전문적인 어조로 대화하며, 때로는 개인적인 경험담을 곁들여 공감대를 형성합니다.',
    greeting: '안녕하세요, AI 멘토입니다.\n\n저도 비슷한 길을 걸어왔습니다. 진단 결과를 보니 제 경험이 도움이 될 것 같네요. 편하게 궁금한 점을 물어보세요. 실무에서 직접 겪은 이야기들을 나누며 함께 성장해 나가겠습니다.'
  },
  teaching: {
    name: 'AI 선생님',
    icon: 'fa-chalkboard-teacher',
    color: 'orange',
    gradient: 'from-orange-600 to-orange-700',
    bgColor: 'bg-orange-600',
    systemPrompt: '당신은 체계적이고 명확한 교육 전문가입니다. 복잡한 개념을 쉽게 설명하고, 단계별 학습 방법을 제시하며, 이론과 실습을 균형있게 안내합니다. 명확하고 이해하기 쉬운 어조로 대화하며, 학습 내용을 구조화하여 전달합니다. 필요시 예제와 연습 문제를 제공합니다.',
    greeting: '안녕하세요, AI 선생님입니다.\n\n역량 개발을 위한 체계적인 학습을 시작해볼까요? 진단 결과를 분석하여 가장 효과적인 학습 경로를 설계하고, 단계별로 필요한 지식과 기술을 습득할 수 있도록 안내하겠습니다.'
  }
}

// 어시스턴트 선택
function selectAssistant(type) {
  currentAssistant = type
  const profile = assistantProfiles[type]
  
  // UI 전환
  document.getElementById('assistant-selection').classList.add('hidden')
  document.getElementById('chat-area').classList.remove('hidden')
  
  // 헤더 업데이트
  const header = document.getElementById('assistant-header')
  header.className = `bg-gradient-to-r ${profile.gradient} rounded-t-xl p-4 flex items-center justify-between`
  
  const avatar = document.getElementById('assistant-avatar')
  avatar.innerHTML = `<i class="fas ${profile.icon} text-${profile.color}-600 text-xl"></i>`
  
  document.getElementById('assistant-name').textContent = profile.name
  
  // 채팅 초기화 및 인사말 추가
  chatMessages = [
    { role: 'assistant', content: profile.greeting, isGreeting: true }
  ]
  updateChatUI()
  
  // 입력 포커스
  document.getElementById('chat-input').focus()
}

// 어시스턴트 재선택
function resetAssistant() {
  currentAssistant = null
  chatMessages = []
  
  // UI 전환
  document.getElementById('chat-area').classList.add('hidden')
  document.getElementById('assistant-selection').classList.remove('hidden')
}

// 메시지 전송
async function sendChatMessage() {
  const input = document.getElementById('chat-input')
  const message = input.value.trim()
  
  if (!message || !currentAssistant) return
  
  // 사용자 메시지 추가
  chatMessages.push({ role: 'user', content: message })
  updateChatUI()
  input.value = ''
  
  // 타이핑 인디케이터 표시
  showTypingIndicator()
  
  // AI 응답 요청
  try {
    const profile = assistantProfiles[currentAssistant]
    const response = await axios.post('/api/ai/coaching', {
      messages: [
        { role: 'system', content: profile.systemPrompt },
        ...chatMessages.filter(m => !m.isGreeting)
      ]
    }, {
      timeout: 60000
    })
    
    hideTypingIndicator()
    
    if (response.data.success) {
      chatMessages.push({ role: 'assistant', content: response.data.message })
      updateChatUI()
    } else {
      alert(response.data.error)
    }
  } catch (error) {
    hideTypingIndicator()
    console.error('Error sending chat message:', error)
    const errorDetail = error.response?.data?.error || error.message || '알 수 없는 오류'
    
    chatMessages.push({ 
      role: 'assistant', 
      content: `죄송합니다. 일시적인 오류가 발생했습니다.\n\n${errorDetail}\n\n다시 시도해 주세요.`,
      isError: true
    })
    updateChatUI()
  }
}

// 타이핑 인디케이터
function showTypingIndicator() {
  const container = document.getElementById('chat-container')
  const profile = assistantProfiles[currentAssistant]
  
  const indicator = document.createElement('div')
  indicator.id = 'typing-indicator'
  indicator.className = 'flex justify-start mb-4'
  indicator.innerHTML = `
    <div class="flex items-start gap-3 max-w-[70%]">
      <div class="w-10 h-10 ${profile.bgColor} rounded-full flex items-center justify-center flex-shrink-0 shadow-lg">
        <i class="fas ${profile.icon} text-white"></i>
      </div>
      <div class="bg-white rounded-2xl rounded-tl-sm px-6 py-4 shadow-md">
        <div class="flex gap-1">
          <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0s"></div>
          <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.2s"></div>
          <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.4s"></div>
        </div>
      </div>
    </div>
  `
  container.appendChild(indicator)
  container.scrollTop = container.scrollHeight
}

function hideTypingIndicator() {
  const indicator = document.getElementById('typing-indicator')
  if (indicator) indicator.remove()
}

// 채팅 UI 업데이트
function updateChatUI() {
  const container = document.getElementById('chat-container')
  const profile = assistantProfiles[currentAssistant]
  
  if (chatMessages.length === 0) {
    container.innerHTML = `
      <div class="text-gray-500 text-sm text-center py-8">
        대화를 시작하세요
      </div>
    `
    return
  }
  
  container.innerHTML = chatMessages.map((msg, idx) => {
    const timestamp = new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' })
    
    if (msg.role === 'user') {
      return `
        <div class="flex justify-end mb-4 animate-fadeIn">
          <div class="flex flex-col items-end max-w-[70%]">
            <div class="bg-gradient-to-r from-blue-600 to-blue-500 text-white rounded-2xl rounded-tr-sm px-6 py-3 shadow-lg">
              <div class="whitespace-pre-line leading-relaxed">${msg.content}</div>
            </div>
            <span class="text-xs text-gray-400 mt-1">${timestamp}</span>
          </div>
        </div>
      `
    } else {
      return `
        <div class="flex justify-start mb-4 animate-fadeIn">
          <div class="flex items-start gap-3 max-w-[70%]">
            <div class="w-10 h-10 ${profile.bgColor} rounded-full flex items-center justify-center flex-shrink-0 shadow-lg">
              <i class="fas ${profile.icon} text-white"></i>
            </div>
            <div class="flex flex-col">
              <div class="bg-white rounded-2xl rounded-tl-sm px-6 py-4 shadow-md ${msg.isError ? 'border-2 border-red-300' : ''}">
                <div class="whitespace-pre-line leading-relaxed text-gray-800">${msg.content}</div>
              </div>
              <span class="text-xs text-gray-400 mt-1 ml-2">${profile.name} · ${timestamp}</span>
            </div>
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
    console.log(`📊 Loading analysis for respondent ${respondentId}`)
    const response = await axios.get(`/api/analysis/${respondentId}`)
    console.log('📊 Analysis response:', response.data)
    
    if (response.data.success) {
      try {
        renderAnalysisReport(response.data.data)
        console.log('✅ Analysis report rendered successfully')
        
        // AI 인사이트는 버튼 클릭 시 생성 (자동 호출 제거)
      } catch (renderError) {
        console.error('❌ Error rendering analysis report:', renderError)
        reportDiv.innerHTML = `
          <div class="text-center py-8">
            <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
            <p class="text-red-600">분석 결과를 표시하는 중 오류가 발생했습니다</p>
            <p class="text-sm text-gray-500 mt-2">${renderError.message}</p>
          </div>
        `
      }
    } else {
      console.error('❌ Analysis API returned error:', response.data.error)
      reportDiv.innerHTML = `
        <div class="text-center py-8">
          <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
          <p class="text-red-600">${response.data.error}</p>
        </div>
      `
    }
  } catch (error) {
    console.error('❌ Error loading analysis:', error)
    console.error('Error details:', error.response || error)
    
    // 404 에러 (응답 데이터 없음) 처리
    if (error.response && error.response.status === 404) {
      reportDiv.innerHTML = `
        <div class="text-center py-8">
          <i class="fas fa-inbox text-4xl text-gray-400 mb-4"></i>
          <p class="text-gray-600 text-lg mb-2">응답 데이터가 없습니다</p>
          <p class="text-sm text-gray-500">이 응답자는 아직 진단을 완료하지 않았습니다.</p>
        </div>
      `
    } else {
      // 기타 에러
      reportDiv.innerHTML = `
        <div class="text-center py-8">
          <i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>
          <p class="text-red-600">분석 결과를 불러오는 중 오류가 발생했습니다</p>
          <p class="text-sm text-gray-500 mt-2">${error.response?.data?.error || error.message || '알 수 없는 오류'}</p>
        </div>
      `
    }
  }
}

// 현재 분석 데이터 저장 (AI 인사이트 생성용)
let currentAnalysisData = null

// 분석 리포트 렌더링
function renderAnalysisReport(data) {
  console.log('🎨 Rendering analysis report with data:', data)
  const reportDiv = document.getElementById('analysis-report')
  
  if (!data || !data.respondent || !data.analysis || !data.summary) {
    console.error('❌ Invalid data structure:', data)
    throw new Error('데이터 구조가 올바르지 않습니다')
  }
  
  // 전역 변수에 저장
  currentAnalysisData = data
  
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
      <div style="height: ${Math.max(400, analysis.length * 50)}px; position: relative;">
        <canvas id="competency-chart"></canvas>
      </div>
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
      <div class="flex items-center justify-between mb-4">
        <h4 class="text-lg font-semibold text-purple-800">
          <i class="fas fa-brain mr-2"></i>AI 인사이트
        </h4>
      </div>
      <div class="text-center py-8">
        <p class="text-gray-600 mb-4">AI 분석을 통해 맞춤형 인사이트와 발전 방향을 제공합니다</p>
        <button 
          onclick="generateAIInsights(${respondent.id})"
          id="generate-insights-btn"
          class="bg-gradient-to-r from-purple-600 to-blue-600 text-white px-6 py-3 rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all duration-200 font-semibold shadow-lg">
          <i class="fas fa-magic mr-2"></i>AI 인사이트 생성
        </button>
      </div>
    </div>
  `
  
  // 차트 렌더링
  renderCompetencyChart(analysis)
}

// 역량 차트 렌더링 - 세련된 수평 막대 차트
function renderCompetencyChart(analysis) {
  const ctx = document.getElementById('competency-chart')
  if (!ctx) {
    console.warn('⚠️ Chart canvas not found')
    return
  }
  
  // Chart.js가 로드되었는지 확인
  if (typeof Chart === 'undefined') {
    console.error('❌ Chart.js is not loaded')
    ctx.parentElement.innerHTML = `
      <div class="text-center py-8 text-gray-500">
        <i class="fas fa-exclamation-triangle text-2xl mb-2"></i>
        <p>차트 라이브러리를 불러오는 중입니다...</p>
      </div>
    `
    // 1초 후 재시도
    setTimeout(() => {
      if (typeof Chart !== 'undefined') {
        renderCompetencyChart(analysis)
      }
    }, 1000)
    return
  }
  
  // 데이터 정렬 (점수 높은 순)
  const sortedAnalysis = [...analysis].sort((a, b) => b.average - a.average)
  
  // 색상 함수
  const getColor = (value) => {
    if (value >= 4.5) return { bg: 'rgba(16, 185, 129, 0.85)', border: 'rgb(16, 185, 129)' } // 진한 녹색
    if (value >= 4) return { bg: 'rgba(34, 197, 94, 0.85)', border: 'rgb(34, 197, 94)' } // 녹색
    if (value >= 3.5) return { bg: 'rgba(59, 130, 246, 0.85)', border: 'rgb(59, 130, 246)' } // 파란색
    if (value >= 3) return { bg: 'rgba(99, 102, 241, 0.85)', border: 'rgb(99, 102, 241)' } // 보라색
    if (value >= 2.5) return { bg: 'rgba(245, 158, 11, 0.85)', border: 'rgb(245, 158, 11)' } // 주황색
    return { bg: 'rgba(239, 68, 68, 0.85)', border: 'rgb(239, 68, 68)' } // 빨간색
  }
  
  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: sortedAnalysis.map(a => a.competency),
      datasets: [{
        label: '평균 점수',
        data: sortedAnalysis.map(a => a.average),
        backgroundColor: sortedAnalysis.map(a => getColor(a.average).bg),
        borderColor: sortedAnalysis.map(a => getColor(a.average).border),
        borderWidth: 2,
        borderRadius: 8,
        borderSkipped: false
      }]
    },
    options: {
      indexAxis: 'y', // 수평 막대 차트
      responsive: true,
      maintainAspectRatio: false,
      layout: {
        padding: {
          right: 50 // 점수 레이블을 위한 여백
        }
      },
      scales: {
        x: {
          beginAtZero: true,
          max: 5,
          ticks: {
            stepSize: 1,
            font: {
              size: 12,
              weight: 'bold'
            }
          },
          grid: {
            color: 'rgba(0, 0, 0, 0.05)',
            drawBorder: false
          }
        },
        y: {
          ticks: {
            font: {
              size: 13,
              weight: '500'
            },
            padding: 10
          },
          grid: {
            display: false
          }
        }
      },
      plugins: {
        legend: {
          display: false
        },
        tooltip: {
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          padding: 12,
          titleFont: {
            size: 14,
            weight: 'bold'
          },
          bodyFont: {
            size: 13
          },
          borderColor: 'rgba(255, 255, 255, 0.1)',
          borderWidth: 1,
          callbacks: {
            title: function(context) {
              return context[0].label
            },
            label: function(context) {
              const item = sortedAnalysis[context.dataIndex]
              return [
                `평균 점수: ${item.average}점`,
                `응답 수: ${item.count}개`,
                `최고: ${item.max}점 / 최저: ${item.min}점`
              ]
            }
          }
        },
        // 데이터 레이블 플러그인
        datalabels: false // 기본 플러그인 비활성화
      },
      animation: {
        duration: 1500,
        easing: 'easeInOutQuart'
      }
    },
    plugins: [{
      // 커스텀 데이터 레이블 플러그인
      id: 'customDataLabels',
      afterDatasetsDraw: function(chart) {
        const ctx = chart.ctx
        chart.data.datasets.forEach(function(dataset, i) {
          const meta = chart.getDatasetMeta(i)
          meta.data.forEach(function(bar, index) {
            const data = dataset.data[index]
            ctx.fillStyle = '#1f2937'
            ctx.font = 'bold 14px sans-serif'
            ctx.textAlign = 'left'
            ctx.textBaseline = 'middle'
            
            const x = bar.x + 10
            const y = bar.y
            
            ctx.fillText(data.toFixed(1) + '점', x, y)
          })
        })
      }
    }]
  })
}

// AI 인사이트 생성 (버튼 클릭 시)
async function generateAIInsights(respondentId) {
  console.log('🤖 Generating AI insights for respondent:', respondentId)
  
  if (!currentAnalysisData) {
    alert('분석 데이터를 찾을 수 없습니다. 페이지를 새로고침해주세요.')
    return
  }
  
  const insightsDiv = document.getElementById('ai-insights')
  const generateBtn = document.getElementById('generate-insights-btn')
  
  // 버튼 비활성화 및 로딩 표시
  if (generateBtn) {
    generateBtn.disabled = true
    generateBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>생성 중...'
  }
  
  insightsDiv.innerHTML = `
    <h4 class="text-lg font-semibold text-purple-800 mb-3">
      <i class="fas fa-brain mr-2"></i>AI 인사이트
    </h4>
    <div class="text-center py-8">
      <i class="fas fa-spinner fa-spin text-3xl text-purple-600 mb-2"></i>
      <p class="text-gray-600">AI가 인사이트를 생성하고 있습니다...</p>
      <p class="text-sm text-gray-500 mt-2">최대 1분 정도 소요될 수 있습니다</p>
    </div>
  `
  
  // AI 인사이트 로드
  await loadAIInsights(respondentId, currentAnalysisData)
}

// AI 인사이트 로드
async function loadAIInsights(respondentId, analysisData) {
  const insightsDiv = document.getElementById('ai-insights')
  
  try {
    console.log('🤖 Calling API:', `/api/analysis/${respondentId}/insights`)
    console.log('🤖 Request data:', analysisData)
    
    const response = await axios.post(`/api/analysis/${respondentId}/insights`, analysisData, {
      timeout: 60000,
      headers: {
        'Content-Type': 'application/json'
      }
    })
    
    console.log('🤖 API response:', response.data)
    
    if (response.data.success) {
      const insights = response.data.insights
      const isDemo = response.data.demo
      
      console.log('✅ Insights received:', insights)
      
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
        
        <!-- 역량 개발 추천 -->
        <div class="bg-white rounded-lg p-4">
          <h5 class="font-semibold text-gray-800 mb-3">
            <i class="fas fa-lightbulb text-blue-500 mr-2"></i>역량 개발 추천
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
    } else {
      console.error('❌ API returned error:', response.data)
      throw new Error(response.data.error || 'API returned success: false')
    }
  } catch (error) {
    console.error('❌ Error loading AI insights:', error)
    console.error('Error details:', error.response?.data || error.message)
    
    insightsDiv.innerHTML = `
      <h4 class="text-lg font-semibold text-purple-800 mb-3">
        <i class="fas fa-brain mr-2"></i>AI 인사이트
      </h4>
      <div class="bg-red-50 border border-red-200 rounded-lg p-4">
        <p class="text-red-600 mb-2">AI 인사이트를 생성하는 중 오류가 발생했습니다</p>
        <p class="text-sm text-gray-600">${error.response?.data?.error || error.message || '알 수 없는 오류'}</p>
        <button 
          onclick="generateAIInsights(${respondentId})"
          class="mt-3 bg-purple-600 text-white px-4 py-2 rounded hover:bg-purple-700 text-sm">
          <i class="fas fa-redo mr-2"></i>다시 시도
        </button>
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
let questionsPerPage = null  // 사용자가 선택해야 함
let assessmentResponses = []
let currentRespondentInfo = null
let scaleConfig = {
  type: '5-point',
  labels: ['전혀 그렇지 않다', '그렇지 않다', '보통이다', '그렇다', '매우 그렇다']
}

// 척도 레이블 업데이트
function updateScaleLabels() {
  const scaleTypeElement = document.getElementById('scale-type')
  if (!scaleTypeElement) {
    console.warn('scale-type element not found')
    return
  }
  
  const scaleType = scaleTypeElement.value
  const container = document.getElementById('scale-labels-grid')
  
  let defaultLabels = []
  let scaleCount = 0
  
  switch(scaleType) {
    case 'single':
      scaleCount = 1
      defaultLabels = ['확인']
      break
    case '3-point':
      scaleCount = 3
      defaultLabels = ['낮음', '보통', '높음']
      break
    case '5-point':
      scaleCount = 5
      defaultLabels = ['전혀 그렇지 않다', '그렇지 않다', '보통이다', '그렇다', '매우 그렇다']
      break
    case '6-point':
      scaleCount = 6
      defaultLabels = ['전혀 그렇지 않다', '그렇지 않다', '약간 그렇지 않다', '약간 그렇다', '그렇다', '매우 그렇다']
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
  
  if (container) {
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
  else if (scaleCount === 6) gridCols = 'grid-cols-6'
  else if (scaleCount === 7) gridCols = 'grid-cols-7'
  else if (scaleCount === 10) gridCols = 'grid-cols-5'
  
  return `
    <div class="grid ${gridCols} gap-3" id="scale-buttons-${questionIdx}">
      ${Array.from({length: scaleCount}, (_, i) => i + 1).map(value => {
        const isSelected = currentResponse === value;
        return `
        <button 
          data-question="${questionIdx}"
          data-value="${value}"
          onclick="selectAnswer(${questionIdx}, ${value})"
          class="response-btn py-4 px-2 border-2 rounded-lg transition-all duration-200 transform ${
            isSelected
              ? 'selected-btn border-blue-600 text-white ring-4 ring-blue-300 shadow-2xl scale-110' 
              : 'unselected-btn border-gray-300 bg-white'
          }">
          <div class="text-2xl font-bold ${isSelected ? 'text-white' : 'text-gray-700'}">${value}</div>
          <div class="text-xs mt-1 px-1 ${isSelected ? 'text-blue-100' : 'text-gray-500'}">
            ${labels[value - 1] ? labels[value - 1].replace(/\n/g, '<br>') : ''}
          </div>
          ${isSelected ? '<div class="absolute -top-1 -right-1 bg-white rounded-full p-0.5 shadow-lg" style="z-index: 10;"><i class="fas fa-check-circle text-blue-600 text-xl"></i></div>' : ''}
        </button>
      `}).join('')}
    </div>
    ${scaleCount > 1 ? `
    <div class="flex justify-between text-xs text-gray-500 px-1 mt-2">
      <span>${labels[0] || ''}</span>
      <span>${labels[scaleCount - 1] || ''}</span>
    </div>
    ` : ''}
  `
}

// 문항 디스플레이 설정 (드롭다운)
function setQuestionDisplayFromSelect() {
  const selectElement = document.getElementById('display-count')
  if (!selectElement) return
  
  const value = selectElement.value
  if (value === '') {
    questionsPerPage = null
  } else {
    questionsPerPage = parseInt(value)
  }
  
  // 진단지 구성하기 버튼 상태 체크
  checkComposeButtonState()
}

// 진단지 구성하기 버튼 상태 체크
function checkComposeButtonState() {
  const nameElement = document.getElementById('exec-name')
  const emailElement = document.getElementById('exec-email')
  const displayElement = document.getElementById('display-count')
  const composeBtn = document.getElementById('compose-assessment-btn')
  
  if (!nameElement || !emailElement || !displayElement || !composeBtn) {
    return
  }
  
  const name = nameElement.value.trim()
  const email = emailElement.value.trim()
  const hasDisplay = displayElement.value !== ''
  
  if (name && email && hasDisplay) {
    composeBtn.disabled = false
    composeBtn.classList.remove('opacity-50', 'cursor-not-allowed')
  } else {
    composeBtn.disabled = true
    composeBtn.classList.add('opacity-50', 'cursor-not-allowed')
  }
}

// 진단지 구성하기
async function composeAssessment() {
  const name = document.getElementById('exec-name').value.trim()
  const email = document.getElementById('exec-email').value.trim()
  const department = document.getElementById('exec-department').value.trim()
  const position = document.getElementById('exec-position').value.trim()
  const level = document.getElementById('exec-level').value
  
  if (!name || !email) {
    alert('이름과 이메일은 필수 입력 항목입니다')
    return
  }
  
  if (questionsPerPage === null || questionsPerPage === undefined) {
    alert('진단 문항 디스플레이 설정을 선택해주세요')
    return
  }
  
  // 응답자 정보 저장
  currentRespondentInfo = {
    name, email, department, position, level
  }
  
  // 척도 설정 저장
  const scaleType = document.getElementById('scale-type').value
  scaleConfig.type = scaleType
  
  try {
    // 생성된 문항 확인 (editableQuestions 사용)
    if (!editableQuestions || editableQuestions.length === 0) {
      alert('진단 문항이 없습니다. 먼저 Phase 1에서 문항을 생성해주세요.')
      return
    }
    
    console.log('Using generated questions:', editableQuestions.length)
    
    // 생성된 문항을 진단 문항으로 설정
    assessmentQuestions = editableQuestions.map(q => ({
      id: q.id || null,  // DB에 저장된 경우 ID가 있음
      competency: q.competency,
      question_text: q.question_text
    }))
    
    assessmentResponses = new Array(assessmentQuestions.length).fill(null)
    
    // 역량 진단 렌더링
    renderAssessmentPreview()
    
    // 진단 영역 표시
    const previewArea = document.getElementById('assessment-preview')
    if (previewArea) {
      previewArea.classList.remove('hidden')
      // 진단 영역으로 스크롤
      previewArea.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
    
  } catch (error) {
    console.error('Error composing assessment:', error)
    alert('진단지를 구성하는 중 오류가 발생했습니다: ' + (error.response?.data?.error || error.message))
  }
}

// 역량 진단 렌더링 (실제 응답 가능한 인터페이스)
let currentAssessmentPage = 0

function renderAssessmentPreview() {
  const previewContent = document.getElementById('preview-content')
  if (!previewContent) {
    console.error('preview-content element not found')
    return
  }
  
  if (!currentRespondentInfo) {
    console.error('currentRespondentInfo is null')
    alert('응답자 정보가 없습니다. 이름과 이메일을 입력해주세요.')
    return
  }
  
  // 응답 배열 초기화
  assessmentResponses = new Array(assessmentQuestions.length).fill(null)
  currentAssessmentPage = 0
  
  const scaleCount = scaleConfig.labels.length
  const labels = scaleConfig.labels
  
  previewContent.innerHTML = `
    <!-- 응답자 정보 -->
    <div class="bg-white rounded-lg p-4 mb-6 border border-gray-300">
      <h4 class="font-semibold text-gray-800 mb-3">
        <i class="fas fa-user text-blue-600 mr-2"></i>응답자 정보
      </h4>
      <div class="grid grid-cols-2 gap-3 text-sm">
        <div><span class="text-gray-600">이름:</span> <span class="font-medium">${currentRespondentInfo.name || '-'}</span></div>
        <div><span class="text-gray-600">이메일:</span> <span class="font-medium">${currentRespondentInfo.email || '-'}</span></div>
        <div><span class="text-gray-600">부서:</span> <span class="font-medium">${currentRespondentInfo.department || '-'}</span></div>
        <div><span class="text-gray-600">직위:</span> <span class="font-medium">${currentRespondentInfo.position || '-'}</span></div>
      </div>
    </div>
    
    <!-- 척도 정보 -->
    <div class="bg-white rounded-lg p-4 mb-6 border border-gray-300">
      <h4 class="font-semibold text-gray-800 mb-3">
        <i class="fas fa-sliders-h text-purple-600 mr-2"></i>응답 척도 (${scaleCount}점)
      </h4>
      <div class="flex flex-wrap gap-2">
        ${labels.map((label, idx) => `
          <span class="px-3 py-1 bg-blue-50 border border-blue-200 rounded-full text-sm">
            <strong>${idx + 1}:</strong> ${label}
          </span>
        `).join('')}
      </div>
    </div>
    
    <!-- 역량 진단 -->
    <div class="bg-white rounded-lg p-4 border border-gray-300">
      <h4 class="font-semibold text-gray-800 mb-4">
        <i class="fas fa-clipboard-check text-green-600 mr-2"></i>역량 진단
      </h4>
      <div id="assessment-questions-container" class="space-y-6"></div>
      
      <!-- 네비게이션 버튼 -->
      <div id="assessment-nav" class="flex justify-between items-center mt-6 pt-4 border-t"></div>
    </div>
  `
  
  renderAssessmentPage()
}

// 역량 진단 페이지 렌더링
function renderAssessmentPage() {
  const container = document.getElementById('assessment-questions-container')
  const nav = document.getElementById('assessment-nav')
  if (!container || !nav) return
  
  const perPage = questionsPerPage === -1 ? assessmentQuestions.length : questionsPerPage
  const totalPages = Math.ceil(assessmentQuestions.length / perPage)
  const startIdx = currentAssessmentPage * perPage
  const endIdx = Math.min(startIdx + perPage, assessmentQuestions.length)
  const pageQuestions = assessmentQuestions.slice(startIdx, endIdx)
  
  // 문항 렌더링
  container.innerHTML = pageQuestions.map((q, localIdx) => {
    const globalIdx = startIdx + localIdx
    const currentResponse = assessmentResponses[globalIdx]
    
    return `
      <div class="border rounded-lg p-6 bg-white">
        <h4 class="text-lg font-medium text-gray-800 mb-4">
          Q${globalIdx + 1}. ${q.question_text}
        </h4>
        <div class="text-xs text-gray-500 mb-4">
          <i class="fas fa-tag mr-1"></i>역량: ${q.competency}
        </div>
        ${renderScaleButtons(globalIdx, currentResponse)}
      </div>
    `
  }).join('')
  
  // 네비게이션 버튼
  nav.innerHTML = `
    <div>
      ${currentAssessmentPage > 0 ? `
        <button onclick="navigateAssessmentPage(-1)" class="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600">
          <i class="fas fa-chevron-left mr-2"></i>이전
        </button>
      ` : '<div></div>'}
    </div>
    
    <div class="text-sm text-gray-600">
      페이지 ${currentAssessmentPage + 1} / ${totalPages} 
      <span class="ml-2">(${startIdx + 1}-${endIdx} / 총 ${assessmentQuestions.length}문항)</span>
    </div>
    
    <div>
      ${currentAssessmentPage < totalPages - 1 ? `
        <button onclick="navigateAssessmentPage(1)" class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
          다음<i class="fas fa-chevron-right ml-2"></i>
        </button>
      ` : `
        <button onclick="submitAssessment()" class="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600">
          <i class="fas fa-check mr-2"></i>제출하기
        </button>
      `}
    </div>
  `
}

// 역량 진단 페이지 이동
function navigateAssessmentPage(direction) {
  const perPage = questionsPerPage === -1 ? assessmentQuestions.length : questionsPerPage
  const startIdx = currentAssessmentPage * perPage
  const endIdx = Math.min(startIdx + perPage, assessmentQuestions.length)
  
  // 현재 페이지 유효성 검증
  let allAnswered = true
  for (let i = startIdx; i < endIdx; i++) {
    if (assessmentResponses[i] === null) {
      allAnswered = false
      break
    }
  }
  
  if (!allAnswered && direction > 0) {
    alert('현재 페이지의 모든 문항에 응답해주세요.')
    return
  }
  
  currentAssessmentPage += direction
  renderAssessmentPage()
}

// 답변 선택 (역량 진단용) - 완전 재렌더링 방식
function selectAnswer(questionIdx, value) {
  console.log(`🎯 Selecting answer: Question ${questionIdx}, Value ${value}`)
  
  // 응답 저장
  assessmentResponses[questionIdx] = value
  
  // 해당 질문의 척도 버튼 컨테이너를 완전히 다시 렌더링
  const scaleContainer = document.getElementById(`scale-buttons-${questionIdx}`)
  if (!scaleContainer) {
    console.error(`❌ Scale container not found for question ${questionIdx}`)
    return
  }
  
  // 현재 응답값으로 버튼 HTML 재생성
  const scaleCount = scaleConfig.labels.length
  const labels = scaleConfig.labels
  
  // 그리드 컬럼 수 결정
  let gridCols = 'grid-cols-5'
  if (scaleCount === 1) gridCols = 'grid-cols-1'
  else if (scaleCount === 2) gridCols = 'grid-cols-2'
  else if (scaleCount === 3) gridCols = 'grid-cols-3'
  else if (scaleCount === 6) gridCols = 'grid-cols-6'
  else if (scaleCount === 7) gridCols = 'grid-cols-7'
  else if (scaleCount === 10) gridCols = 'grid-cols-5'
  
  // 새로운 HTML 생성
  const buttonsHTML = Array.from({length: scaleCount}, (_, i) => i + 1).map(btnValue => {
    const isSelected = value === btnValue;
    return `
      <button 
        data-question="${questionIdx}"
        data-value="${btnValue}"
        onclick="selectAnswer(${questionIdx}, ${btnValue})"
        class="response-btn py-4 px-2 border-2 rounded-lg transition-all duration-200 transform ${
          isSelected
            ? 'selected-btn border-blue-600 text-white ring-4 ring-blue-300 shadow-2xl scale-110' 
            : 'unselected-btn border-gray-300 bg-white'
        }">
        <div class="text-2xl font-bold ${isSelected ? 'text-white' : 'text-gray-700'}">${btnValue}</div>
        <div class="text-xs mt-1 px-1 ${isSelected ? 'text-blue-100' : 'text-gray-500'}">
          ${labels[btnValue - 1] ? labels[btnValue - 1].replace(/\n/g, '<br>') : ''}
        </div>
        ${isSelected ? '<div class="absolute -top-1 -right-1 bg-white rounded-full p-0.5 shadow-lg" style="z-index: 10;"><i class="fas fa-check-circle text-blue-600 text-xl"></i></div>' : ''}
      </button>
    `
  }).join('')
  
  // DOM 업데이트
  scaleContainer.innerHTML = buttonsHTML
  
  console.log(`✅ Question ${questionIdx} answered with value ${value} - UI updated!`)
}

// 역량 진단 제출
async function submitAssessment() {
  // 모든 문항 응답 확인
  const unansweredCount = assessmentResponses.filter(r => r === null).length
  if (unansweredCount > 0) {
    alert(`${unansweredCount}개의 문항이 응답되지 않았습니다. 모든 문항에 응답해주세요.`)
    return
  }
  
  if (!confirm('진단을 제출하시겠습니까? 제출 후에는 수정할 수 없습니다.')) return
  
  try {
    console.log('Submitting assessment...', {
      respondent: currentRespondentInfo,
      question_count: assessmentQuestions.length,
      response_count: assessmentResponses.filter(r => r !== null).length
    })
    
    const response = await fetch('/api/submit-assessment', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        respondent_info: currentRespondentInfo,
        responses: assessmentQuestions.map((q, idx) => ({
          question_id: q.id,
          competency: q.competency,
          question_text: q.question_text,
          response: assessmentResponses[idx]
        }))
      })
    })
    
    const result = await response.json()
    console.log('Submit result:', result)
    
    if (result.success) {
      alert(`진단이 성공적으로 제출되었습니다!\n\n✓ 제출 완료: ${result.saved_count}개 문항\n✓ 세션 ID: ${result.session_id}\n✓ 응답자 ID: ${result.respondent_id}`)
      
      // 진단 영역 숨기기
      document.getElementById('assessment-preview').classList.add('hidden')
      
      // 응답 초기화
      assessmentResponses = []
      currentAssessmentPage = 0
      
      // 결과 분석 탭으로 이동
      showTab('analytics', document.querySelector('.nav-btn'))
      
      // 결과 분석 자동 로드 (응답자 ID가 있으면)
      if (result.respondent_id) {
        setTimeout(() => {
          viewResultsPage(result.respondent_id)
        }, 500)
      }
    } else {
      throw new Error(result.error || '제출 실패')
    }
  } catch (error) {
    console.error('제출 오류:', error)
    alert('제출 중 오류가 발생했습니다: ' + error.message)
  }
}



// 진단 시작 버튼 상태 체크
function checkStartButtonState() {
  const nameElement = document.getElementById('exec-name')
  const emailElement = document.getElementById('exec-email')
  const startBtn = document.getElementById('start-assessment-btn')
  
  if (!nameElement || !emailElement || !startBtn) {
    return // 요소가 없으면 조기 반환
  }
  
  const name = nameElement.value.trim()
  const email = emailElement.value.trim()
  const hasDisplay = questionsPerPage !== null
  
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
  const displayInput = document.getElementById('display-count')
  
  if (nameInput) {
    nameInput.addEventListener('input', checkComposeButtonState)
  }
  if (emailInput) {
    emailInput.addEventListener('input', checkComposeButtonState)
  }
  if (displayInput) {
    displayInput.addEventListener('change', checkComposeButtonState)
  }
  
  // 척도 레이블 초기화
  if (document.getElementById('scale-type')) {
    updateScaleLabels()
  }
  
  // 진단지 구성하기 버튼 초기 상태 체크
  checkComposeButtonState()
})

// 진단 시작
async function startAssessment() {
  if (!currentRespondentInfo) {
    alert('응답자 정보가 없습니다')
    return
  }
  
  if (!assessmentQuestions || assessmentQuestions.length === 0) {
    alert('진단 문항이 없습니다')
    return
  }
  
  if (questionsPerPage === null || questionsPerPage === undefined) {
    alert('진단 문항 디스플레이 설정을 선택해주세요')
    return
  }
  
  // 응답 배열 초기화
  assessmentResponses = new Array(assessmentQuestions.length).fill(null)
  currentPage = 0
  
  try {
    // 미리보기 영역 숨기기
    document.getElementById('assessment-preview').classList.add('hidden')
    document.getElementById('start-assessment-btn').classList.add('hidden')
    
    // 진단 실행 영역 생성 및 표시
    const phase2Section = document.querySelector('.bg-white.rounded-lg.shadow.p-6.mb-6:nth-child(2)')
    if (!phase2Section) return
    
    // 기존 진단 실행 영역이 있으면 제거
    const existingExecArea = document.getElementById('assessment-execution-area')
    if (existingExecArea) {
      existingExecArea.remove()
    }
    
    // 새로운 진단 실행 영역 생성
    const execArea = document.createElement('div')
    execArea.id = 'assessment-execution-area'
    execArea.className = 'bg-white rounded-lg shadow p-6 mt-6 border-t-4 border-green-600'
    execArea.innerHTML = `
      <div class="border-t pt-6">
        <div class="flex justify-between items-center mb-6">
          <div>
            <h3 class="text-xl font-semibold text-gray-800">
              <i class="fas fa-pen-to-square text-purple-600 mr-2"></i>진단 문항
            </h3>
            <p class="text-sm text-gray-600 mt-1">${currentRespondentInfo.name}님의 역량 진단</p>
          </div>
          <div class="text-sm text-gray-600">
            <span id="current-progress">0</span> / <span id="total-questions">0</span> 문항 완료
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
    `
    
    // Phase 2 섹션 다음에 실행 영역 추가
    phase2Section.parentNode.insertBefore(execArea, phase2Section.nextSibling)
    
    // 총 문항 수 표시
    document.getElementById('total-questions').textContent = assessmentQuestions.length
    
    // 첫 페이지 렌더링
    renderQuestionsPage()
    
    // 실행 영역으로 스크롤
    execArea.scrollIntoView({ behavior: 'smooth', block: 'start' })
    
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
// selectAnswer 함수는 위에 정의되어 있음 (중복 제거됨)

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
    
    // 현재 페이지의 모든 문항에 응답했는지 체크
    const startIdx = currentPage * questionsPerPage
    const endIdx = Math.min(startIdx + questionsPerPage, assessmentQuestions.length)
    const currentPageResponses = assessmentResponses.slice(startIdx, endIdx)
    const allCurrentPageAnswered = currentPageResponses.every(r => r !== null)
    
    if (allCurrentPageAnswered) {
      nextBtn.disabled = false
      nextBtn.classList.remove('opacity-50', 'cursor-not-allowed')
    } else {
      nextBtn.disabled = true
      nextBtn.classList.add('opacity-50', 'cursor-not-allowed')
    }
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
// ============================================================================
// 전역 함수를 window 객체에 명시적으로 할당
// ============================================================================
// 전역 함수를 window 객체에 명시적으로 할당 (존재하는 함수만)
// ============================================================================
if (typeof showTab !== 'undefined') window.showTab = showTab
if (typeof searchCompetencies !== 'undefined') window.searchCompetencies = searchCompetencies
if (typeof selectCompetency !== 'undefined') window.selectCompetency = selectCompetency
if (typeof removeCompetency !== 'undefined') window.removeCompetency = removeCompetency
if (typeof generateQuestions !== 'undefined') window.generateQuestions = generateQuestions
if (typeof saveQuestions !== 'undefined') window.saveQuestions = saveQuestions
if (typeof proceedToPhase2 !== 'undefined') window.proceedToPhase2 = proceedToPhase2
if (typeof updateScaleCount !== 'undefined') window.updateScaleCount = updateScaleCount
if (typeof updateScaleLabels !== 'undefined') window.updateScaleLabels = updateScaleLabels
if (typeof updateScaleLabel !== 'undefined') window.updateScaleLabel = updateScaleLabel
if (typeof setQuestionDisplay !== 'undefined') window.setQuestionDisplay = setQuestionDisplay
if (typeof setQuestionDisplayFromSelect !== 'undefined') window.setQuestionDisplayFromSelect = setQuestionDisplayFromSelect
if (typeof checkComposeButtonState !== 'undefined') window.checkComposeButtonState = checkComposeButtonState
if (typeof composeAssessment !== 'undefined') window.composeAssessment = composeAssessment
if (typeof navigateAssessmentPage !== 'undefined') window.navigateAssessmentPage = navigateAssessmentPage
if (typeof selectAnswer !== 'undefined') window.selectAnswer = selectAnswer
if (typeof submitAssessment !== 'undefined') window.submitAssessment = submitAssessment
if (typeof startAssessment !== 'undefined') window.startAssessment = startAssessment
if (typeof renderQuestionsPage !== 'undefined') window.renderQuestionsPage = renderQuestionsPage
if (typeof prevPage !== 'undefined') window.prevPage = prevPage
if (typeof nextPage !== 'undefined') window.nextPage = nextPage
if (typeof submitResponses !== 'undefined') window.submitResponses = submitResponses
if (typeof viewResultsPage !== 'undefined') window.viewResultsPage = viewResultsPage
if (typeof sendChatMessage !== 'undefined') window.sendChatMessage = sendChatMessage
if (typeof generateAIInsights !== 'undefined') window.generateAIInsights = generateAIInsights
if (typeof selectAssistant !== 'undefined') window.selectAssistant = selectAssistant
if (typeof resetAssistant !== 'undefined') window.resetAssistant = resetAssistant

console.log('=== All functions bound to window object ===')
console.log('searchCompetencies available:', typeof window.searchCompetencies === 'function')
