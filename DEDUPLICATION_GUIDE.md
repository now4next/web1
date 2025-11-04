# 중복 역량 통합 정리 가이드

## 📋 개요

데이터베이스에서 중복된 역량을 발견하여 통합 정리했습니다.

### 중복 발견 내역
- **분석적 사고** (2개 → 1개)
- **의사결정/판단력** (2개 → 1개)
- **전략적 사고/기획** (2개 → 1개)
- **창의적 사고** (2개 → 1개)

**총 8개 → 4개** (4개 중복 제거)

## 🔍 중복 원인

같은 역량이 2개의 다른 역량 모델에 중복으로 존재:
1. **경영지원 직무역량** 모델 (간단한 설명)
2. **역량 평가표** 모델 (상세한 설명)

### 제거 기준

**"역량 평가표" 모델의 역량을 유지**한 이유:
- ✅ 더 상세하고 명확한 역량 정의
- ✅ 더 많은 행동 지표 (3-5개 vs 1-2개)
- ✅ 실무에서 활용 가능한 구체적 설명

## 📊 상세 비교

### 1. 분석적 사고

**삭제됨 (경영지원 직무역량):**
- 정의: "타당한 정보를 근거로 논리적으로 사고해 의미 있는 결론을 도출하는 능력"
- 행동 지표: 2개

**유지됨 (역량 평가표):** ✅
- 정의: "타당한 정보를 근거로 논리 정연하게 사고하여 정확하고 의미 있는 결론을 도출하는 역량. 정보를 체계적으로 분석하여 핵심 요소, 상호 연관성, 경향성을 파악해 상황판단, 문제해결, 의사결정 등에 활용하는 역량"
- 행동 지표: 3개
- 직무: 재경

### 2. 의사결정/판단력

**삭제됨 (경영지원 직무역량):**
- 정의: "객관 기준과 근거에 따라 단·장기 효과를 고려해 타당한 결론을 도출하는 능력"
- 행동 지표: 1개

**유지됨 (역량 평가표):** ✅
- 정의: "체계적 논리와 근거에 따라 요구에 맞는 타당한 결론을 내리는 역량. 객관적인 기준, 구체적인 사례, 잦은 의견 교환과 주의깊은 관찰을 통해 객관적 자료와 근거를 중심으로 의사결정을 하는 역량"
- 행동 지표: 5개
- 직무: 홍보

### 3. 전략적 사고/기획

**삭제됨 (경영지원 직무역량):**
- 정의: "내·외부 요인을 장기·포괄적으로 고려하여 문제 해결과 의사결정을 수행하는 능력"
- 행동 지표: 1개

**유지됨 (역량 평가표):** ✅
- 정의: "내/외부 요인을 장기적이고 포괄적으로 고려하여 문제해결과 의사결정을 하는 역량. 높은 성과를 낼 수 있는 전략을 확인하고 업무 활동 및 프로세스를 체계적으로 계획하고 조직화하여 실행하는 역량"
- 행동 지표: 4개
- 직무: 홍보

### 4. 창의적 사고

**삭제됨 (경영지원 직무역량):**
- 정의: "서로 관련성 낮은 개념 간 연계성을 발견해 새로운 아이디어를 창출하는 능력"
- 행동 지표: 1개

**유지됨 (역량 평가표):** ✅
- 정의: "관련성이 적은 개념들 속에서 새롭고 독창적인 연계성을 파악해 가치 있는 아이디어를 창출하는 역량. 목표 달성을 위해 새로운 아이디어와 개념을 적용하여 변화를 시도하거나 창의적인 해결안을 도출하는 역량"
- 행동 지표: 4개
- 직무: 홍보

## ✅ 로컬 환경 적용 완료

로컬 개발 환경에서 중복 제거가 완료되었습니다:

```bash
# 로컬 DB에서 실행 완료 ✅
npx wrangler d1 execute aiassess-production --local --file=./remove_duplicates.sql
```

**결과:**
- 중복 역량 4개 제거 완료
- 행동 지표 5개 제거 완료
- 검증 완료: 각 역량이 1개씩만 존재

## 🚀 프로덕션 적용 방법

### Option A: Wrangler CLI (권장)

```bash
cd /home/user/webapp
npx wrangler d1 execute aiassess-production --remote --file=./remove_duplicates.sql
```

⚠️ API 권한 오류가 발생하면 Option B 사용

### Option B: Cloudflare Dashboard (수동)

1. **https://dash.cloudflare.com 접속**
2. **Workers & Pages** → **D1** → **aiassess-production** → **Console**
3. **다음 3개 SQL문을 순서대로 실행:**

#### 1단계: 행동 지표 삭제
```sql
DELETE FROM behavioral_indicators WHERE competency_id IN (SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id WHERE cm.name = '경영지원 직무역량' AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고'));
```

#### 2단계: 중복 역량 삭제
```sql
DELETE FROM competencies WHERE id IN (SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id WHERE cm.name = '경영지원 직무역량' AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고'));
```

#### 3단계: 검증
```sql
SELECT keyword, COUNT(*) as count FROM competencies WHERE keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고') GROUP BY keyword;
```

**예상 결과:** 각 역량이 count = 1

### SQL 파일 위치

- **주석 포함 버전**: `remove_duplicates.sql`
- **Console 전용 버전**: `remove_duplicates_manual.sql`
- **GitHub**: https://raw.githubusercontent.com/now4next/web1/main/remove_duplicates_manual.sql

## 🧪 검증 방법

### 1. 중복 확인
```sql
SELECT keyword, COUNT(*) as count 
FROM competencies 
GROUP BY keyword 
HAVING count > 1;
```
**예상 결과:** 빈 배열 (중복 없음)

### 2. 총 역량 수 확인
```sql
SELECT cm.name as model, COUNT(c.id) as count 
FROM competencies c 
JOIN competency_models cm ON c.model_id = cm.id 
GROUP BY cm.name;
```
**예상 결과:**
- 역량 평가표: 30개
- 경영지원 직무역량: 15개
- **총합: 45개** (이전 49개에서 4개 감소)

### 3. API 테스트
```bash
# "분석" 검색 시 1개의 "분석적 사고"만 반환되어야 함
curl "https://60727f5c.aiassess.pages.dev/api/competencies/search?q=분석적사고"
```

## 📈 개선 효과

### Before (중복 있음)
- 총 역량: 49개 (중복 포함)
- 분석적 사고: 2개 (혼란 발생)
- 행동 지표: 불일치

### After (중복 제거)
- 총 역량: 45개 (중복 없음) ✅
- 분석적 사고: 1개 (명확함) ✅
- 행동 지표: 통일됨 ✅

### 사용자 경험 개선
- ✅ 검색 결과가 명확함 (같은 역량이 2번 나오지 않음)
- ✅ 더 상세한 역량 정의 제공
- ✅ 더 많은 행동 지표 활용 가능
- ✅ 데이터 일관성 향상

## 🔄 향후 데이터 추가 시 주의사항

새로운 역량을 추가할 때:

1. **중복 확인**: 먼저 같은 키워드가 있는지 확인
   ```sql
   SELECT * FROM competencies WHERE keyword = '새역량명';
   ```

2. **모델 선택**: 적절한 역량 모델에만 추가
   - 공통 역량: 전 직원 대상
   - 리더십 역량: 관리자 대상
   - 직무 역량: 특정 직무 대상

3. **정의 품질**: 구체적이고 명확한 정의 작성
   - 역량의 의미와 목적
   - 구체적인 행동 예시
   - 활용 상황 설명

4. **행동 지표**: 최소 3개 이상 작성
   - 관찰 가능한 구체적 행동
   - 측정 가능한 기준
   - 실무 적용 사례

## 📝 변경 이력

- **2025-11-04**: 중복 역량 4개 제거
  - 분석적 사고, 의사결정/판단력, 전략적 사고/기획, 창의적 사고
  - "경영지원 직무역량" 모델의 중복 항목 삭제
  - "역량 평가표" 모델의 상세 버전 유지
  - 로컬 DB 적용 완료 ✅
  - 프로덕션 DB 적용 대기중 ⏳

## 📞 문의 및 지원

중복 제거 과정에서 문제가 발생하면:
- GitHub Issues: https://github.com/now4next/web1/issues
- 관련 문서: PRODUCTION_TROUBLESHOOTING.md

---

**작성일**: 2025-11-04  
**상태**: 로컬 적용 완료, 프로덕션 대기중  
**영향**: 검색 결과 명확화, 데이터 품질 향상
