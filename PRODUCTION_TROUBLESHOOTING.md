# 프로덕션 문제 해결 가이드

## 🔍 현재 상황

### 증상
- 프로덕션 URL: https://60727f5c.aiassess.pages.dev
- 검색 API: 정상 작동 (HTTP 200)
- 검색 결과: 빈 배열 반환

### 원인
프로덕션 D1 데이터베이스에 기본 데이터가 없거나, `job_name` 컬럼이 아직 추가되지 않았을 가능성이 있습니다.

## ✅ 해결 방법

### 1단계: 데이터베이스 상태 확인

Cloudflare Dashboard에서 확인:
1. https://dash.cloudflare.com 접속
2. **Workers & Pages** → **D1** → **aiassess-production**
3. **Console** 탭에서 다음 쿼리 실행:

```sql
-- 테이블 존재 확인
SELECT name FROM sqlite_master WHERE type='table';
```

**예상 결과:**
```
competency_models
competencies
behavioral_indicators
assessment_questions
assessment_sessions
respondents
assessment_responses
analysis_results
coaching_sessions
```

### 2단계: 데이터 존재 여부 확인

```sql
-- 역량 모델 확인
SELECT COUNT(*) as model_count FROM competency_models;

-- 역량 확인
SELECT COUNT(*) as competency_count FROM competencies;
```

**예상 결과:**
- 역량 모델: 3개 이상
- 역량: 10개 이상

### 3단계: job_name 컬럼 확인

```sql
-- competencies 테이블 구조 확인
PRAGMA table_info(competencies);
```

**job_name 컬럼이 있는지 확인:**
- 있으면: 4단계로
- 없으면: 5단계로

### 4단계: job_name 데이터 확인 (컬럼이 있는 경우)

```sql
SELECT COUNT(*) as count_with_job_name 
FROM competencies 
WHERE job_name IS NOT NULL;
```

**결과가 0이면:** 6단계 (데이터 업데이트) 실행 필요

### 5단계: 스키마 마이그레이션 (job_name 컬럼 추가)

```sql
ALTER TABLE competencies ADD COLUMN job_name TEXT;
CREATE INDEX IF NOT EXISTS idx_competencies_job_name ON competencies(job_name);
```

### 6단계: job_name 데이터 업데이트

GitHub에서 SQL 파일 복사:
https://raw.githubusercontent.com/now4next/web1/main/update_job_names_oneline.sql

또는 로컬 파일: `update_job_names_oneline.sql`

**30개 UPDATE 문 실행**

### 7단계: 기본 데이터 확인 및 추가

만약 역량 데이터가 없다면, 기본 데이터를 추가해야 합니다.

#### 7-1. 샘플 역량 모델 추가

```sql
-- 공통 역량 모델
INSERT INTO competency_models (name, type, description, target_level) 
VALUES ('공통 역량', 'common', '전 직원 대상 기본 역량', 'all');

-- 리더십 역량 모델
INSERT INTO competency_models (name, type, description, target_level) 
VALUES ('리더십 역량', 'leadership', '관리자 이상 대상', 'manager');
```

#### 7-2. 샘플 역량 추가

```sql
-- 커뮤니케이션 역량
INSERT INTO competencies (model_id, keyword, description) 
SELECT id, '커뮤니케이션', '명확하고 효과적인 의사소통 능력' 
FROM competency_models WHERE name = '공통 역량';

-- 문제해결 역량
INSERT INTO competencies (model_id, keyword, description) 
SELECT id, '문제해결', '복잡한 문제를 분석하고 해결하는 능력' 
FROM competency_models WHERE name = '공통 역량';

-- 리더십 역량
INSERT INTO competencies (model_id, keyword, description) 
SELECT id, '리더십', '팀을 이끌고 동기부여하는 능력' 
FROM competency_models WHERE name = '리더십 역량';
```

#### 7-3. 전체 데이터 마이그레이션

프로덕션 환경에 전체 데이터를 추가하려면:

1. **로컬에서 데이터 확인:**
   ```bash
   npx wrangler d1 execute aiassess-production --local --command="SELECT * FROM competency_models"
   ```

2. **프로덕션에 마이그레이션 적용:**
   ```bash
   npx wrangler d1 migrations apply aiassess-production --remote
   ```

   > ⚠️ 권한 오류가 발생할 경우, Cloudflare Dashboard Console에서 수동으로 실행

3. **시드 데이터 추가:**
   GitHub의 SQL 파일들을 D1 Console에서 순차적으로 실행:
   - `migrations/0001_initial_schema.sql`
   - `seed.sql` (있는 경우)
   - `insert_management_support_competencies.sql` (경영지원 역량)
   - `insert_competencies_from_csv.sql` (CSV 역량)
   - `update_job_names.sql` (직무명 매핑)

### 8단계: 검증

모든 작업 완료 후:

```sql
-- 1. 역량 수 확인
SELECT COUNT(*) as total_competencies FROM competencies;

-- 2. job_name이 있는 역량 수 확인
SELECT COUNT(*) as with_job_name FROM competencies WHERE job_name IS NOT NULL;

-- 3. 샘플 검색
SELECT keyword, description, job_name FROM competencies LIMIT 5;
```

### 9단계: API 테스트

```bash
# 역량명 검색 (기본 기능)
curl "https://60727f5c.aiassess.pages.dev/api/competencies/search?q=커뮤니케이션"

# 직무명 검색 (job_name 컬럼 및 데이터 필요)
curl "https://60727f5c.aiassess.pages.dev/api/competencies/search?q=영업"
```

## 🎯 빠른 해결 체크리스트

- [ ] 테이블 존재 확인 (1단계)
- [ ] 역량 모델 데이터 존재 (2단계) - 없으면 7-1 실행
- [ ] 역량 데이터 존재 (2단계) - 없으면 7-2 실행
- [ ] job_name 컬럼 존재 (3단계) - 없으면 5단계 실행
- [ ] job_name 데이터 존재 (4단계) - 없으면 6단계 실행
- [ ] API 검증 (9단계)

## 🆘 긴급 상황: 완전 초기화

데이터베이스를 처음부터 다시 설정해야 하는 경우:

### Option A: Wrangler CLI (권장)

```bash
# 1. 로컬에서 마이그레이션 확인
cd /home/user/webapp
npx wrangler d1 migrations list aiassess-production --local

# 2. 프로덕션에 적용 (API 권한 있는 경우)
npx wrangler d1 migrations apply aiassess-production --remote

# 3. 시드 데이터 추가
npx wrangler d1 execute aiassess-production --remote --file=./seed.sql
```

### Option B: Cloudflare Dashboard (수동)

1. **모든 SQL 파일을 순서대로 실행:**
   - `migrations/0001_initial_schema.sql` - 기본 테이블 생성
   - `migrations/0002_management_support_competencies.sql` - 경영지원 역량 (있는 경우)
   - `migrations/0003_add_job_name.sql` - job_name 컬럼 추가
   - `seed.sql` - 기본 샘플 데이터
   - `insert_management_support_competencies.sql` - 경영지원 역량 상세
   - `insert_competencies_from_csv.sql` - CSV 역량 데이터
   - `update_job_names.sql` - 직무명 매핑

2. **각 파일은 GitHub에서 확인 가능:**
   https://github.com/now4next/web1/tree/main/migrations

## 📞 추가 도움

이 가이드로 해결되지 않으면:

1. **로그 확인:**
   - Cloudflare Dashboard → Workers & Pages → aiassess → Logs

2. **이슈 제기:**
   - GitHub Issues: https://github.com/now4next/web1/issues

3. **상세 정보 제공:**
   - 어떤 단계에서 막혔는지
   - 오류 메시지 전체
   - 실행한 쿼리와 결과

---

**최종 업데이트**: 2025-11-04  
**배포 URL**: https://60727f5c.aiassess.pages.dev  
**상태**: 🟡 검색 API 작동, 데이터 설정 필요
