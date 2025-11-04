# 🚨 긴급 수정: FOREIGN_KEY_ERROR 지속 문제

## 📊 현재 상황

### 오류 메시지
```
제출 중 오류가 발생했습니다: FOREIGN_KEY_ERROR
```

### 원인 분석

#### 1. 코드 흐름
```javascript
// 1. 사용자가 역량 선택 (예: "리더십")
selectedCompetencies = [{keyword: "리더십", ...}]

// 2. AI 문항 생성
POST /api/ai/generate-questions
{
  competency_keywords: ["리더십"]
}

// 3. AI 응답 (데모 모드)
{
  questions: [
    {competency: "리더십", question_text: "..."},  // ✅ 정확함
    {competency: "리더십", question_text: "..."}
  ]
}

// 4. 진단 제출
POST /api/submit-assessment
{
  responses: [
    {competency: "리더십", ...}  // DB 조회
  ]
}

// 5. 백엔드 처리
SELECT id FROM competencies WHERE keyword = "리더십"
→ DB에서 찾지 못하면 FOREIGN_KEY_ERROR
```

#### 2. 문제점
- 사용자가 선택한 역량 키워드와 DB의 실제 키워드가 **정확히 일치**해야 함
- 공백, 대소문자, 특수문자 차이로도 실패
- 예:
  - 선택: "리더십" → DB: "리더십" ✅ (일치)
  - 선택: "분석적 사고" → DB: "분석적 사고" ✅ (일치)
  - 선택: "설득/협상" → DB: "설득/영향력" ❌ (불일치)

---

## 🔍 실제 확인 필요

### 어떤 역량을 선택하셨나요?

프로덕션 DB에 있는 역량 목록:

<details>
<summary>전체 52개 역량 목록 (클릭하여 펼치기)</summary>

```
1. 경영성과관리능력
2. 경영혁신 및 변화관리
3. 경영환경/정보분석
4. 고객중심적 사고
5. 관계형성
6. 교육과정개발능력
7. 교육과정운영능력
8. 교육효과평가기법활용능력
9. 데이터 분석
10. 데이터분석
11. 동시다중업무수행
12. 디지털 마케팅
13. 리더십
14. 문서작성 및 관리
15. 문제해결
16. 변화관리
17. 변화관리/주도
18. 분석적 사고
19. 브랜드 관리
20. 사업기획
21. 상황판단 및 대처능력
22. 서비스 지향
23. 설득/영향력
24. 성과보상관리능력
25. 성과지향
26. 세밀/정확한 일처리
27. 소송관리능력
28. 손익마인드
29. 시설유지관리능력
30. 시스템 개발능력
31. 시장분석
32. 업무조정 및 협상력
33. 예산운용능력
34. 의사결정
35. 의사결정/판단력
36. 재무시스템이해능력
37. 전략적 사고
38. 전략적 사고/기획
39. 전략적사고
40. 전문지식 보유 및 활용
41. 정보수집 및 활용
42. 제도개선능력
43. 주도성
44. 창의적 기획
45. 창의적 사고
46. 체계적 사고
47. 코칭
48. 팀웍/협동
49. 프로세스 개선
50. 프로젝트 관리
51. 학습민첩성
52. 협업
```

</details>

---

## ✅ 즉시 해결 방법

### 방법 1: 디버깅 정보 추가 (추천)

프론트엔드에서 선택한 역량과 제출하는 역량을 확인:

#### A. 브라우저 개발자 도구 열기
1. F12 키 누르기
2. Console 탭 선택

#### B. 제출 시 로그 확인
제출 버튼 클릭 시 다음 정보가 표시됩니다:
```javascript
Submitting assessment...
{
  respondent: {...},
  question_count: 15,
  response_count: 15
}
```

#### C. 추가로 다음 명령어 실행 (Console에 붙여넣기)
```javascript
console.log('Selected competencies:', selectedCompetencies.map(c => c.keyword))
console.log('Assessment questions:', assessmentQuestions.map(q => q.competency))
```

**이 정보를 공유해주시면 정확한 문제를 파악할 수 있습니다!**

---

### 방법 2: 백엔드 로그 개선 (이미 적용됨)

백엔드에서 다음 정보를 로그로 출력:
```typescript
if (!competency) {
  console.error(`Competency not found: ${resp.competency}`)
  console.error(`Available competencies in DB:`, await db.prepare(`
    SELECT keyword FROM competencies LIMIT 10
  `).all())
}
```

Cloudflare Pages 로그에서 확인 가능합니다.

---

### 방법 3: 더 관대한 검색 (권장 수정)

역량 키워드를 찾을 때 대소문자 구분 없이, 공백 제거하여 검색:

```typescript
// src/index.tsx 수정
const competency = await db.prepare(`
  SELECT id FROM competencies 
  WHERE LOWER(TRIM(keyword)) = LOWER(TRIM(?))
`).bind(resp.competency).first()
```

**이 방법으로 수정하면 더 안정적입니다.**

---

## 🚀 즉시 적용 가능한 수정

### 백엔드 코드 개선

현재 코드:
```typescript
const competency = await db.prepare(`
  SELECT id FROM competencies WHERE keyword = ?
`).bind(resp.competency).first()
```

개선된 코드:
```typescript
// 정확한 매칭 시도
let competency = await db.prepare(`
  SELECT id FROM competencies WHERE keyword = ?
`).bind(resp.competency).first()

// 찾지 못하면 대소문자 무시하고 재시도
if (!competency) {
  competency = await db.prepare(`
    SELECT id FROM competencies 
    WHERE LOWER(TRIM(keyword)) = LOWER(TRIM(?))
  `).bind(resp.competency).first()
}

// 여전히 못 찾으면 유사한 키워드 검색
if (!competency) {
  const similar = await db.prepare(`
    SELECT id, keyword FROM competencies 
    WHERE keyword LIKE ?
    LIMIT 5
  `).bind(`%${resp.competency}%`).all()
  
  console.error(`Competency not found: "${resp.competency}"`)
  console.error(`Similar competencies:`, similar.results?.map(c => c.keyword))
  
  return c.json({ 
    success: false, 
    error: `역량을 찾을 수 없습니다: ${resp.competency}`,
    message: '선택한 역량이 데이터베이스에 존재하지 않습니다.',
    similar_keywords: similar.results?.map(c => c.keyword) || []
  }, 400)
}
```

---

## 💡 임시 해결책 (지금 바로)

### 확실하게 존재하는 역량으로 테스트

다음 역량들은 확실히 DB에 존재합니다:
- ✅ 리더십
- ✅ 문제해결
- ✅ 협업
- ✅ 학습민첩성
- ✅ 분석적 사고

**이 역량들로 진단을 생성하고 제출해보세요.**

---

## 📋 체크리스트

### 즉시 확인
- [ ] 브라우저 개발자 도구 Console 열기
- [ ] 선택한 역량 키워드 확인
- [ ] 제출 시 전송되는 역량 확인
- [ ] 정확한 키워드를 알려주시면 해결 가능

### 코드 수정 (제가 할 작업)
- [ ] 더 관대한 역량 검색 로직 추가
- [ ] 유사 키워드 제안 기능 추가
- [ ] 빌드 및 배포

---

## 🆘 다음 단계

**지금 즉시 확인 부탁드립니다:**

1. 어떤 역량을 선택하셨나요?
2. 브라우저 Console에 무엇이 표시되나요?
3. 위 52개 역량 목록에 선택한 역량이 있나요?

**이 정보를 주시면 즉시 해결하겠습니다!** 🚀
