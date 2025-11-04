# Production Database Migration Guide - Job Name Search

## ⚠️ Important
The application code has been deployed to https://91bedc45.aiassess.pages.dev, but the database migration must be applied manually via Cloudflare Dashboard due to API permission restrictions.

## Step-by-Step Instructions

### Step 1: Access Cloudflare D1 Console
1. Go to https://dash.cloudflare.com
2. Navigate to **Workers & Pages** → **D1**
3. Select database: **aiassess-production**
4. Click **Console** tab

### Step 2: Apply Schema Migration (2 statements)

Copy and paste these SQL statements one at a time:

```sql
ALTER TABLE competencies ADD COLUMN job_name TEXT;
```

```sql
CREATE INDEX IF NOT EXISTS idx_competencies_job_name ON competencies(job_name);
```

### Step 3: Update Job Name Data (30 statements)

Copy and paste all 30 UPDATE statements:

```sql
UPDATE competencies SET job_name = '재경' WHERE keyword = '분석적 사고' AND job_name IS NULL;
UPDATE competencies SET job_name = '홍보' WHERE keyword = '의사결정/판단력' AND job_name IS NULL;
UPDATE competencies SET job_name = '홍보' WHERE keyword = '전략적 사고/기획' AND job_name IS NULL;
UPDATE competencies SET job_name = '홍보' WHERE keyword = '창의적 사고' AND job_name IS NULL;
UPDATE competencies SET job_name = '홍보' WHERE keyword = '설득/영향력' AND job_name IS NULL;
UPDATE competencies SET job_name = '관재시설' WHERE keyword = '팀웍/협동' AND job_name IS NULL;
UPDATE competencies SET job_name = '관재시설' WHERE keyword = '프로젝트 관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '영업' WHERE keyword = '관계형성' AND job_name IS NULL;
UPDATE competencies SET job_name = '기술지원' WHERE keyword = '문서작성 및 관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '기술지원' WHERE keyword = '정보수집 및 활용' AND job_name IS NULL;
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '데이터 분석' AND job_name IS NULL;
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '디지털 마케팅' AND job_name IS NULL;
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '브랜드 관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '시장분석' AND job_name IS NULL;
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '창의적 기획' AND job_name IS NULL;
UPDATE competencies SET job_name = '총무' WHERE keyword = '세밀/정확한 일처리' AND job_name IS NULL;
UPDATE competencies SET job_name = '비서' WHERE keyword = '전략적 사고' AND job_name IS NULL;
UPDATE competencies SET job_name = '비서' WHERE keyword = '체계적 사고' AND job_name IS NULL;
UPDATE competencies SET job_name = '법무' WHERE keyword = '리스크 관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '법무' WHERE keyword = '법률 전문성' AND job_name IS NULL;
UPDATE competencies SET job_name = '재무' WHERE keyword = '비용관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '재무' WHERE keyword = '재무분석' AND job_name IS NULL;
UPDATE competencies SET job_name = '재무' WHERE keyword = '전략적 재무관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '회계' WHERE keyword = '수치감각' AND job_name IS NULL;
UPDATE competencies SET job_name = '회계' WHERE keyword = '예산수립 및 통제' AND job_name IS NULL;
UPDATE competencies SET job_name = '감사/기획' WHERE keyword = '위험분석 및 평가' AND job_name IS NULL;
UPDATE competencies SET job_name = '감사/기획' WHERE keyword = '제도 및 시스템 이해' AND job_name IS NULL;
UPDATE competencies SET job_name = '정보기술' WHERE keyword = '기술적 전문성' AND job_name IS NULL;
UPDATE competencies SET job_name = '윤리' WHERE keyword = '윤리경영' AND job_name IS NULL;
UPDATE competencies SET job_name = '인사' WHERE keyword = '인재 개발' AND job_name IS NULL;
```

### Step 4: Verify Migration

After applying all statements, verify the data with this query:

```sql
SELECT keyword, job_name FROM competencies WHERE job_name = '영업';
```

Expected result:
- 관계형성, 영업
- 서비스 지향, 영업
- 성과지향, 영업

### Step 5: Test Production API

After migration is complete, test the API:

```bash
curl "https://91bedc45.aiassess.pages.dev/api/competencies/search?q=영업"
```

Should return 3 competencies related to "영업" job.

## Alternative: Copy from Files

If copy-paste from this document has issues, the SQL files are available in the repository:

**Migration file:**
- `migrations/0003_add_job_name_oneline.sql` (2 statements)

**Update file:**
- `update_job_names_oneline.sql` (30 statements)

Or download from GitHub:
- https://raw.githubusercontent.com/now4next/web1/main/migrations/0003_add_job_name_oneline.sql
- https://raw.githubusercontent.com/now4next/web1/main/update_job_names_oneline.sql

## Troubleshooting

### Issue: Column already exists
If you see "duplicate column name" error, the migration was already applied. Skip to Step 3.

### Issue: No rows updated
If UPDATE statements return 0 rows changed, check if:
1. The competency keyword exists in the database
2. The job_name is already set (remove `AND job_name IS NULL` condition)

### Issue: API returns empty results
Verify:
1. Migration was applied successfully
2. UPDATE statements executed without errors
3. Check database has data: `SELECT COUNT(*) FROM competencies WHERE job_name IS NOT NULL;`

## Summary

**What this migration does:**
- Adds `job_name` column to store job category (직무명) for each competency
- Enables searching by job name like "영업", "마케팅", "인사" etc.
- Updates 30 competencies from CSV data with their corresponding job names

**Affected job categories:**
감사/기획, 관재시설, 기술지원, 마케팅, 법무, 비서, 영업, 윤리, 인사, 재경, 재무, 정보기술, 총무, 홍보, 회계

**Deployment URL:** https://91bedc45.aiassess.pages.dev

**Version:** v0.5.2
