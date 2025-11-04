# 프로덕션 데이터베이스 수동 업데이트 가이드

## 현재 상황
- ✅ 애플리케이션 코드 배포 완료: https://aiassess.pages.dev
- ✅ job_name 검색 기능 코드 배포 완료
- ❌ 프로덕션 데이터베이스에 job_name 업데이트 필요
- ❌ 프로덕션 데이터베이스에 중복 역량 제거 필요

## API 토큰 권한 이슈
현재 API 토큰이 D1 데이터베이스 원격 쿼리 실행 권한이 없습니다.

**해결 방법**: Cloudflare 대시보드에서 직접 SQL 실행

## Cloudflare 대시보드에서 수행할 작업

### 1. D1 데이터베이스 콘솔 접속
1. https://dash.cloudflare.com 로그인
2. Workers & Pages > D1 > `aiassess-production` 선택
3. Console 탭 클릭

### 2. Job Name 업데이트 (30개 역량)

아래 SQL을 Console에서 실행:

```sql
-- 영업 직무
UPDATE competencies SET job_name = '영업' WHERE keyword = '고객관계 구축';
UPDATE competencies SET job_name = '영업' WHERE keyword = '설득/협상';
UPDATE competencies SET job_name = '영업' WHERE keyword = '시장분석';

-- 마케팅 직무
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '시장분석';
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '창의적 사고';
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '커뮤니케이션';

-- 인사 직무
UPDATE competencies SET job_name = '인사' WHERE keyword = '커뮤니케이션';
UPDATE competencies SET job_name = '인사' WHERE keyword = '공정성/윤리';
UPDATE competencies SET job_name = '인사' WHERE keyword = '전략적 사고/기획';

-- 재무 직무
UPDATE competencies SET job_name = '재무' WHERE keyword = '분석적 사고';
UPDATE competencies SET job_name = '재무' WHERE keyword = '정확성/세심함';
UPDATE competencies SET job_name = '재무' WHERE keyword = '의사결정/판단력';

-- IT 직무
UPDATE competencies SET job_name = 'IT' WHERE keyword = '문제해결';
UPDATE competencies SET job_name = 'IT' WHERE keyword = '혁신/개선';
UPDATE competencies SET job_name = 'IT' WHERE keyword = '기술적 전문성';

-- 생산관리 직무
UPDATE competencies SET job_name = '생산관리' WHERE keyword = '프로세스 개선';
UPDATE competencies SET job_name = '생산관리' WHERE keyword = '품질관리';
UPDATE competencies SET job_name = '생산관리' WHERE keyword = '계획/조직화';

-- 구매조달 직무
UPDATE competencies SET job_name = '구매조달' WHERE keyword = '협상/설득';
UPDATE competencies SET job_name = '구매조달' WHERE keyword = '분석적 사고';
UPDATE competencies SET job_name = '구매조달' WHERE keyword = '관계구축';

-- 물류 직무
UPDATE competencies SET job_name = '물류' WHERE keyword = '계획/조직화';
UPDATE competencies SET job_name = '물류' WHERE keyword = '효율성 추구';
UPDATE competencies SET job_name = '물류' WHERE keyword = '문제해결';

-- 품질관리 직무
UPDATE competencies SET job_name = '품질관리' WHERE keyword = '정확성/세심함';
UPDATE competencies SET job_name = '품질관리' WHERE keyword = '분석적 사고';
UPDATE competencies SET job_name = '품질관리' WHERE keyword = '개선지향';

-- 연구개발 직무
UPDATE competencies SET job_name = '연구개발' WHERE keyword = '창의적 사고';
UPDATE competencies SET job_name = '연구개발' WHERE keyword = '혁신/개선';
UPDATE competencies SET job_name = '연구개발' WHERE keyword = '기술적 전문성';
```

### 3. 중복 역량 제거

**중요**: 현재 프로덕션 DB에 외래키 제약 조건으로 인해 직접 삭제가 어려울 수 있습니다.

**Step 1: 중복 확인**
```sql
SELECT 
  c.keyword,
  cm.name as model_name,
  COUNT(*) as count
FROM competencies c
JOIN competency_models cm ON c.model_id = cm.id
GROUP BY c.keyword
HAVING COUNT(*) > 1
ORDER BY c.keyword;
```

**Step 2: 외래키 제약 해제 및 중복 제거**
```sql
PRAGMA foreign_keys = OFF;

-- 행동지표 먼저 삭제
DELETE FROM behavioral_indicators 
WHERE competency_id IN (
  SELECT c.id 
  FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고', '리더십', '문제해결', '시장분석', '커뮤니케이션')
);

-- 중복 역량 삭제 (경영지원 직무역량 모델에서)
DELETE FROM competencies 
WHERE id IN (
  SELECT c.id 
  FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고', '리더십', '문제해결', '시장분석', '커뮤니케이션')
);

PRAGMA foreign_keys = ON;
```

**Step 3: 결과 확인**
```sql
-- 중복 확인 (0개여야 함)
SELECT 
  c.keyword,
  cm.name as model_name,
  COUNT(*) as count
FROM competencies c
JOIN competency_models cm ON c.model_id = cm.id
GROUP BY c.keyword
HAVING COUNT(*) > 1;

-- 최종 역량 개수 (45개여야 함: 15 경영지원 + 30 역량평가표)
SELECT COUNT(*) as total_competencies FROM competencies;

-- 모델별 역량 개수
SELECT 
  cm.name as model_name,
  COUNT(c.id) as competency_count
FROM competency_models cm
LEFT JOIN competencies c ON cm.id = c.model_id
GROUP BY cm.name;
```

## 4. 검증

업데이트 완료 후 다음 URL들로 테스트:

```bash
# 영업 검색 (3개 결과 예상)
curl "https://aiassess.pages.dev/api/competencies/search?q=영업"

# 마케팅 검색 (3개 결과 예상)
curl "https://aiassess.pages.dev/api/competencies/search?q=마케팅"

# 전체 역량 개수 (45개 예상)
curl "https://aiassess.pages.dev/api/competencies/search"
```

## 예상 결과
- ✅ job_name으로 검색 가능 (예: "영업", "마케팅")
- ✅ 중복 제거 완료 (52개 → 45개)
- ✅ 각 직무별로 정확한 역량 검색

## 참고
- 로컬 데이터베이스에는 이미 모든 작업이 완료되었습니다
- 프로덕션 DB만 수동 업데이트가 필요합니다
- API 토큰 권한 문제로 CLI를 통한 원격 실행이 불가능합니다
