# 🔧 FOREIGN KEY Constraint Error 해결 완료

## 📊 문제 상황

### 증상
```
제출 중 오류가 발생했습니다: D1_ERROR: FOREIGN KEY constraint failed: SQLITE_CONSTRAINT
```

### 발생 위치
- **프로덕션 URL**: https://aiassess.pages.dev
- **로컬 환경**: 정상 작동
- **발생 시점**: 진단 제출 시 (`/api/submit-assessment`)

### 원인 분석

#### 1. 데이터베이스 상태 불일치
```
로컬 DB: 45개 역량 (중복 제거 완료)
프로덕션 DB: 52개 역량 (중복 제거 전)
```

#### 2. 코드 로직 문제
`src/index.tsx` 538-566번 줄:
```typescript
// 역량으로 competency_id 찾기
const competency = await db.prepare(`
  SELECT id FROM competencies WHERE keyword = ?
`).bind(resp.competency).first()

if (competency) {
  // 문항 생성...
}
// ❌ competency가 null인 경우 처리 없음!
```

**문제점**:
- 프론트엔드에서 선택한 역량이 프로덕션 DB에 없을 수 있음
- `competency`가 null이면 `competency.id` 접근 시 오류
- 외래키 제약 조건으로 인해 잘못된 `competency_id` 삽입 불가

---

## ✅ 해결 방법

### 1. 백엔드 오류 처리 개선

#### A. 역량 미발견 시 명확한 오류 반환
```typescript
const competency = await db.prepare(`
  SELECT id FROM competencies WHERE keyword = ?
`).bind(resp.competency).first()

if (!competency) {
  console.error(`Competency not found: ${resp.competency}`)
  return c.json({ 
    success: false, 
    error: `역량을 찾을 수 없습니다: ${resp.competency}`,
    message: '선택한 역량이 데이터베이스에 존재하지 않습니다. 역량 목록을 다시 확인해주세요.'
  }, 400)
}
```

#### B. 외래키 오류 감지 및 사용자 친화적 메시지
```typescript
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
```

### 2. 배포 완료

```bash
# 빌드
npm run build

# 배포
npx wrangler pages deploy dist --project-name aiassess --branch main

# 결과
✨ Deployment complete! 
🌐 https://d5326911.aiassess.pages.dev
🌐 https://aiassess.pages.dev
```

---

## 🎯 근본 원인: 프로덕션 DB 미업데이트

### 현재 상태

| 환경 | 역량 개수 | job_name | 중복 제거 |
|------|----------|----------|----------|
| 로컬 | 45개 | ✅ | ✅ |
| 프로덕션 | 52개 | ❌ | ❌ |

### 필요한 작업

프로덕션 데이터베이스를 로컬과 동일하게 업데이트해야 합니다:

1. **job_name 업데이트** (30개 역량)
2. **중복 역량 제거** (8개 역량: 52개 → 45개)

**가이드**: `QUICK_FIX_VISUAL_GUIDE.md` 참조

---

## 🔍 임시 조치 vs 근본 해결

### ✅ 임시 조치 (완료)
**오류 메시지 개선**으로 사용자에게 명확한 피드백 제공:
```
❌ 이전: "D1_ERROR: FOREIGN KEY constraint failed: SQLITE_CONSTRAINT"
✅ 현재: "선택한 역량이 데이터베이스에 존재하지 않습니다. 역량 목록을 새로고침해주세요."
```

### 🎯 근본 해결 (필요)
**프로덕션 DB 업데이트**로 로컬과 동기화:

#### Cloudflare Console에서 실행:

**1. job_name 업데이트 (30개)**
```sql
UPDATE competencies SET job_name = '영업' WHERE keyword = '고객관계 구축';
UPDATE competencies SET job_name = '영업' WHERE keyword = '설득/협상';
-- ... (나머지 28개)
```

**2. 중복 역량 제거 (8개)**
```sql
PRAGMA foreign_keys = OFF;

DELETE FROM behavioral_indicators 
WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN (
    '분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고',
    '리더십', '문제해결', '시장분석', '커뮤니케이션'
  )
);

DELETE FROM competencies 
WHERE id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN (
    '분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고',
    '리더십', '문제해결', '시장분석', '커뮤니케이션'
  )
);

PRAGMA foreign_keys = ON;
```

**3. 검증**
```sql
-- 전체 개수 (45개 예상)
SELECT COUNT(*) FROM competencies;

-- 중복 확인 (0개 예상)
SELECT keyword, COUNT(*) 
FROM competencies 
GROUP BY keyword 
HAVING COUNT(*) > 1;
```

---

## 📋 단계별 실행 계획

### Phase 1: 오류 메시지 개선 ✅ (완료)
- [x] 백엔드 오류 처리 개선
- [x] 빌드 및 배포
- [x] Git 커밋

### Phase 2: 프로덕션 DB 업데이트 ⏳ (대기)
- [ ] Cloudflare Dashboard 접속
- [ ] D1 Console에서 SQL 실행
- [ ] job_name 업데이트 (30개)
- [ ] 중복 역량 제거 (8개)
- [ ] 결과 검증

### Phase 3: 최종 검증 ⏳
- [ ] 프로덕션에서 진단 제출 테스트
- [ ] 직무명 검색 테스트
- [ ] 전체 역량 개수 확인 (45개)

---

## 🎯 예상 결과

### 현재 상태 (임시 조치 완료)
```
✅ 오류 메시지 개선: 명확한 피드백
⚠️ 프로덕션 DB: 여전히 52개 역량 (중복 있음)
⚠️ job_name 검색: 작동 안 함 (데이터 없음)
```

### 최종 상태 (근본 해결 후)
```
✅ 오류 메시지: 명확
✅ 프로덕션 DB: 45개 역량 (중복 제거)
✅ job_name 검색: 정상 작동
✅ 로컬-프로덕션 동기화 완료
```

---

## 📚 관련 문서

1. **START_HERE.md** - 프로덕션 DB 업데이트 시작 가이드
2. **QUICK_FIX_VISUAL_GUIDE.md** - 상세 SQL 실행 가이드
3. **API_TOKEN_FIX_GUIDE.md** - API 토큰 권한 문제 해결
4. **PRODUCTION_MANUAL_UPDATE.md** - SQL 전체 코드

---

## 💡 핵심 교훈

### 1. 에러 처리의 중요성
```typescript
// ❌ 나쁜 예
if (competency) {
  // 처리...
}

// ✅ 좋은 예
if (!competency) {
  return c.json({ 
    success: false, 
    error: '명확한 오류 메시지'
  }, 400)
}
```

### 2. 로컬-프로덕션 동기화
- 로컬에서 작동하더라도 프로덕션 DB 상태 확인 필수
- 마이그레이션은 로컬과 프로덕션 모두에 적용
- 정기적인 동기화 검증

### 3. 외래키 제약 조건
- SQLite는 기본적으로 외래키 비활성화
- 데이터 무결성을 위해 명시적 처리 필요
- 오류 발생 시 사용자 친화적 메시지 제공

---

## 🚀 다음 단계

1. **즉시**: 프로덕션 DB 업데이트 (`QUICK_FIX_VISUAL_GUIDE.md` 참조)
2. **검증**: 진단 제출 테스트
3. **완료**: 모든 기능 정상 작동 확인

**모든 가이드 문서가 준비되어 있습니다!** 🎉
