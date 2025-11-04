# 🔍 진단 제출 오류 디버깅 가이드

## 📊 현재 상황

### 증상
```
제출 중 오류가 발생했습니다: FOREIGN_KEY_ERROR
```

### 배포 완료
- ✅ 개선된 디버깅 로그 추가
- ✅ 프로덕션 배포: https://df0440dc.aiassess.pages.dev
- ✅ 메인 URL: https://aiassess.pages.dev

---

## 🚀 즉시 시도하기

### 1단계: 브라우저 강력 새로고침
```
Windows: Ctrl + Shift + R
Mac: Cmd + Shift + R
```

### 2단계: 개발자 도구 열기
```
F12 키 또는
마우스 우클릭 > 검사 > Console 탭
```

### 3단계: 진단 제출 시도
1. 역량 선택 (예: "리더십", "문제해결", "협업")
2. AI 문항 생성
3. 진단 실행 및 응답
4. **제출 버튼 클릭**

### 4단계: Console 로그 확인
제출 버튼 클릭 시 다음과 같은 로그가 표시됩니다:

```javascript
=== 진단 제출 디버깅 ===
Submitting assessment... {
  respondent: {...},
  question_count: 15,
  response_count: 15,
  competencies: ["리더십", "문제해결", "협업", ...]  // 👈 이 부분 확인!
}
첫 3개 문항 상세: [
  {id: null, competency: "리더십", question_text: "..."},
  {id: null, competency: "문제해결", question_text: "..."},
  {id: null, competency: "협업", question_text: "..."}
]
```

**오류 발생 시 추가 로그**:
```javascript
=== 제출 실패 상세 ===
오류 타입: FOREIGN_KEY_ERROR
오류 메시지: 역량을 찾을 수 없습니다: XXX
유사 키워드: ["리더십", "리더십 역량", ...]
```

---

## 📋 이 정보를 공유해주세요

### 필수 정보
1. **선택한 역량** (검색 탭에서 선택한 것들)
2. **Console의 competencies 배열** (위 로그에서 확인)
3. **오류 메시지 전체** (similar_keywords 포함)

### 스크린샷
- Console 전체 화면
- 선택한 역량 목록

---

## 🎯 문제 유형별 해결

### 유형 1: 역량 키워드 불일치

**증상**:
```
오류 메시지: 역량을 찾을 수 없습니다: "리더쉽"
유사 키워드: ["리더십", ...]
```

**원인**: 오타 또는 공백
**해결**: 
1. 역량 검색 탭에서 다시 검색
2. 정확한 키워드로 선택
3. 진단 재생성

### 유형 2: DB에 없는 역량

**증상**:
```
오류 메시지: 역량을 찾을 수 없습니다: "XXX"
유사 키워드: []
```

**원인**: 프로덕션 DB에 해당 역량 없음
**해결**: 
- 확실히 존재하는 역량으로 재시도:
  - ✅ 리더십
  - ✅ 문제해결
  - ✅ 협업
  - ✅ 학습민첩성
  - ✅ 분석적 사고

### 유형 3: 공백 또는 특수문자 문제

**증상**:
```
competencies: ["리더십 ", "문제 해결", ...]  // 공백 있음
```

**원인**: 데이터 처리 중 공백 추가
**해결**: 
- 역량 다시 선택
- 또는 백엔드가 TRIM 처리 (이미 적용됨)

---

## 🔧 확실한 테스트 방법

### 테스트 1: 단일 역량
```
1. "리더십" 1개만 선택
2. 진단 생성
3. 제출
→ 성공하면 백엔드 정상
→ 실패하면 Console 로그 확인
```

### 테스트 2: 프로덕션 DB 확인
```bash
curl "https://aiassess.pages.dev/api/competencies/search?q=리더십" | jq '.'

# 결과에 리더십이 있으면 정상
```

### 테스트 3: API 직접 테스트
```bash
curl -X POST "https://aiassess.pages.dev/api/submit-assessment" \
  -H "Content-Type: application/json" \
  -d '{
    "respondent_info": {"name": "테스트", "email": "test@test.com"},
    "responses": [{
      "competency": "리더십",
      "question_text": "테스트",
      "response": 5
    }]
  }'

# 성공하면 백엔드 정상
```

---

## 💡 일반적인 원인

### 1. 캐시 문제 (90%)
**해결**: Ctrl + Shift + R (강력 새로고침)

### 2. 역량 키워드 불일치 (5%)
**해결**: 정확한 키워드로 재선택

### 3. DB 상태 불일치 (5%)
**해결**: job_name 업데이트 (EXECUTE_NOW.md 참조)

---

## 📞 지원 요청 시

다음 정보를 함께 보내주세요:

```
1. Console 로그 전체 (스크린샷)
   - "=== 진단 제출 디버깅 ===" 부분
   - "=== 제출 실패 상세 ===" 부분

2. 선택한 역량 (텍스트)
   - 검색 탭에서 선택한 역량 목록

3. 시도한 브라우저
   - Chrome / Edge / Firefox / Safari

4. 오류 재현 단계
   - 어떤 역량을 선택했는지
   - 몇 개의 문항이 생성되었는지
```

---

## ✅ 예상 결과

### 정상 작동 시
```javascript
=== 진단 제출 디버깅 ===
competencies: ["리더십", "문제해결", "협업"]

// 제출 성공
Submit result: {
  success: true,
  session_id: 32,
  respondent_id: 6,
  saved_count: 15
}

alert: "진단이 성공적으로 제출되었습니다!"
```

### 오류 발생 시
```javascript
=== 진단 제출 디버깅 ===
competencies: ["리더쉽"]  // 오타!

=== 제출 실패 상세 ===
오류 타입: 역량을 찾을 수 없습니다: 리더쉽
유사 키워드: ["리더십"]

alert: "제출 중 오류가 발생했습니다: ..."
```

---

## 🚀 다음 단계

1. **브라우저 새로고침** (Ctrl + Shift + R)
2. **F12로 Console 열기**
3. **진단 제출 시도**
4. **Console 로그 확인 및 공유**

**새로운 디버깅 로그가 배포되었습니다!**

이제 정확한 문제를 파악할 수 있습니다. 🔍
