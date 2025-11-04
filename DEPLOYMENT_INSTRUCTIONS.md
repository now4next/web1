# Deployment Instructions for Job Name Search Feature

## Overview
This deployment adds job name (직무명) search functionality, allowing users to search competencies by job names like "영업", "마케팅", etc.

## Changes Made
1. **Database Schema**: Added `job_name` column to `competencies` table
2. **Search API**: Modified `/api/competencies/search` to search by job_name
3. **Data**: Updated all CSV-imported competencies with job_name values

## Production Deployment Steps

### Step 1: Apply Migration to Production Database

Go to Cloudflare Dashboard → D1 → aiassess-production → Console, and execute:

```sql
ALTER TABLE competencies ADD COLUMN job_name TEXT;
CREATE INDEX IF NOT EXISTS idx_competencies_job_name ON competencies(job_name);
```

### Step 2: Update Job Names

Execute all 30 UPDATE statements from `update_job_names_oneline.sql`:

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

### Step 3: Deploy Application

```bash
cd /home/user/webapp
npm run build
wrangler pages deploy dist --project-name aiassess
```

### Step 4: Verify Deployment

Test the search API with a job name:

```bash
curl "https://aiassess.pages.dev/api/competencies/search?q=영업"
```

Expected result: Should return competencies with job_name = "영업" (관계형성, 서비스 지향, 성과지향)

## Testing

### Local Testing (Already Verified ✅)
```bash
curl "http://localhost:3000/api/competencies/search?q=영업"
curl "http://localhost:3000/api/competencies/search?q=마케팅"
```

### Production Testing
```bash
curl "https://aiassess.pages.dev/api/competencies/search?q=영업"
curl "https://aiassess.pages.dev/api/competencies/search?q=인사"
curl "https://aiassess.pages.dev/api/competencies/search?q=재무"
```

## Affected Job Names (직무명)

From CSV data (15 job categories):
- 감사/기획
- 관재시설
- 기술지원
- 마케팅
- 법무
- 비서
- 영업
- 윤리
- 인사
- 재경
- 재무
- 정보기술
- 총무
- 홍보
- 회계

## Files Changed
- `src/index.tsx` - Modified search API to include job_name
- `migrations/0003_add_job_name.sql` - Database migration
- `update_job_names.sql` - Data update statements
- `update_job_names.py` - Script to generate update statements

## Version
v0.5.2 - Job Name Search Feature
