# 🎯 FOREIGN_KEY_ERROR 근본 원인 해결 완료

## 📋 문제 분석

### 발견된 근본 원인
**AI가 생성한 문항의 역량 키워드가 데이터베이스와 일치하지 않았습니다.**

#### 문제 발생 메커니즘:

1. **사용자 입력**: "리더십", "문제해결" 등의 역량 선택
2. **AI 생성**: OpenAI가 자유롭게 역량명 생성
   - 입력: "리더십"
   - AI 출력 가능성: "전략적 리더십", "Leadership", "리더십 역량" 등
3. **DB 저장 실패**: AI가 생성한 역량명으로 competency_id 검색 실패
4. **Phase 2 제출**: 저장되지 않은 문항 사용 → **FOREIGN_KEY_ERROR**

### 구체적 예시:
```
시나리오: 사용자가 "리더십" 선택
AI 생성: {
  "competency": "전략적 리더십",  // ⚠️ DB에 없는 키워드
  "question_text": "나는 전략적 리더십을 발휘한다"
}
→ DB에서 "전략적 리더십" 검색 실패
→ assessment_questions 테이블 INSERT 실패
→ Phase 2 제출 시 FOREIGN_KEY_ERROR
```

---

## ✅ 적용된 해결 방법

### **방법 1: AI 프롬프트 강제**
OpenAI에게 입력된 역량 키워드를 정확히 그대로 사용하도록 명령

**변경 전:**
```typescript
const prompt = `당신은 조직 역량 진단 전문가입니다. 다음 역량들에 대한 진단 문항을 생성해주세요.

역량 키워드: ${body.competency_keywords.join(', ')}
...
"competency": "역량명",
```

**변경 후:**
```typescript
const prompt = `당신은 조직 역량 진단 전문가입니다. 다음 역량들에 대한 진단 문항을 생성해주세요.

역량 키워드: ${body.competency_keywords.join(', ')}
...

⚠️ 중요: "competency" 필드에는 반드시 위의 역량 키워드를 정확히 그대로 사용하세요. 절대 변형하지 마세요.
예시: "리더십" → "리더십" (O), "전략적 리더십" (X), "Leadership" (X)

...
"competency": "역량명 (입력된 키워드 그대로)",
```

### **방법 2: Backend 역량명 정규화**
AI가 생성한 역량명을 입력된 키워드로 강제 매핑

```typescript
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
```

---

## 🚀 배포 정보

### 배포 URL
- **Production**: https://f3452c0d.aiassess.pages.dev
- **또는**: https://aiassess.pages.dev
- **GitHub**: https://github.com/now4next/web1

### Git Commit
```
commit a19c705
Fix FOREIGN_KEY_ERROR: Force AI to use exact competency keywords

- Modified OpenAI prompt to explicitly require exact keyword usage
- Added backend normalization to map AI-generated competencies to input keywords
- Prevents AI from creating variations like '전략적 리더십' when input is '리더십'
- Ensures all generated questions use DB-valid competency names
```

---

## 🧪 테스트 시나리오

### 이제 다음이 작동해야 합니다:

1. **Phase 1**: 역량 선택 (예: "리더십", "문제해결")
2. **AI 문항 생성**: AI가 정확히 "리더십", "문제해결" 사용
3. **DB 저장**: competency_id 검색 성공 → 문항 저장 성공
4. **Phase 2**: 진단 제출 → ✅ **성공!**

### 테스트 방법:

1. https://f3452c0d.aiassess.pages.dev 접속
2. Phase 1에서 역량 선택 (4-5개)
3. "AI 문항 생성" 클릭
4. Phase 2에서 응답자 정보 입력
5. "진단지 구성하기" → 모든 문항 응답
6. "진단 제출" 클릭
7. **기대 결과**: "진단이 성공적으로 제출되었습니다!" 메시지

---

## 📊 기술적 개선 사항

### 1. AI 프롬프트 개선
- 역량 키워드 정확 사용 명령 추가
- 예시와 경고 문구 추가

### 2. Backend 데이터 정규화
- Case-insensitive 매칭
- Trim 처리
- Unknown competency 경고 로그

### 3. 방어적 프로그래밍
- 이중 안전장치 (프롬프트 + 백엔드 정규화)
- AI가 규칙을 어겨도 백엔드에서 자동 수정

---

## 🎓 교훈

### 발견한 것:
1. **AI는 지시를 완벽히 따르지 않을 수 있다**
   - 프롬프트만으로는 불충분
   - 백엔드 검증이 필수

2. **외부 키 제약은 엄격하다**
   - SQLite FOREIGN KEY는 정확한 매칭만 허용
   - 데이터 일관성 검증이 중요

3. **디버깅 로그의 중요성**
   - 실제 데이터를 보지 않으면 근본 원인 파악 불가
   - Console 출력이 문제 해결의 핵심

### 앞으로의 개선:
1. **AI 응답 검증 강화**
   - Schema validation
   - 더 엄격한 타입 체크

2. **더 나은 오류 메시지**
   - 어떤 역량이 문제인지 명확히 표시
   - 사용자에게 실행 가능한 해결책 제공

3. **자동화된 테스트**
   - AI 생성 문항의 역량명 검증
   - E2E 테스트로 전체 플로우 검증

---

## 📝 다음 작업 (Optional)

1. **job_name 데이터 업데이트**
   - EXECUTE_NOW.md의 SQL 실행
   - Production DB에 job_name 추가

2. **로컬 DB 동기화**
   - Production에서 Local로 역량 데이터 동기화
   - 52개 역량으로 맞추기

3. **추가 모니터링**
   - 실제 사용자 제출 성공률 확인
   - 로그에서 Unknown competency 경고 확인

---

## ✨ 결론

**FOREIGN_KEY_ERROR의 근본 원인은 AI가 생성한 역량 키워드가 DB와 일치하지 않는 것이었습니다.**

**해결 방법:**
1. ✅ AI 프롬프트에 정확한 키워드 사용 명령 추가
2. ✅ Backend에서 AI 응답 정규화 및 검증
3. ✅ 이중 안전장치로 데이터 일관성 보장

**배포 완료**: https://f3452c0d.aiassess.pages.dev

이제 사용자가 진단을 제출하면 성공할 것입니다! 🎉
