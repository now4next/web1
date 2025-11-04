# 중복 역량 제거 단계별 가이드

## 📋 발견된 중복

프로덕션 데이터베이스에서 다음 중복이 발견되었습니다:
- **리더십**: 2개
- **문제해결**: 3개
- **시장분석**: 2개
- **커뮤니케이션**: 3개

## 🎯 제거 전략

**행동 지표가 가장 많고 상세한 정의를 가진 역량을 유지합니다.**

## 📝 단계별 실행 가이드

### 1단계: Cloudflare Dashboard 접속

1. https://dash.cloudflare.com 접속
2. **Workers & Pages** → **D1** 선택
3. **aiassess-production** 데이터베이스 선택
4. **Console** 탭 클릭

### 2단계: 중복 역량 상세 확인

다음 쿼리들을 순서대로 실행하여 각 중복의 정보를 확인하세요:

#### 리더십 중복 확인
```sql
SELECT c.id, c.keyword, cm.name as model_name, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword = '리더십'
GROUP BY c.id, c.keyword, cm.name
ORDER BY indicator_count DESC;
```

**결과 예시:**
```
id | keyword | model_name | indicator_count
5  | 리더십  | 역량평가표 | 5
12 | 리더십  | 공통역량   | 2
```
→ **ID 5를 유지**, ID 12를 삭제

#### 문제해결 중복 확인
```sql
SELECT c.id, c.keyword, cm.name as model_name, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword = '문제해결'
GROUP BY c.id, c.keyword, cm.name
ORDER BY indicator_count DESC;
```

#### 시장분석 중복 확인
```sql
SELECT c.id, c.keyword, cm.name as model_name, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword = '시장분석'
GROUP BY c.id, c.keyword, cm.name
ORDER BY indicator_count DESC;
```

#### 커뮤니케이션 중복 확인
```sql
SELECT c.id, c.keyword, cm.name as model_name, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword = '커뮤니케이션'
GROUP BY c.id, c.keyword, cm.name
ORDER BY indicator_count DESC;
```

### 3단계: 삭제할 ID 결정

위의 쿼리 결과를 보고:
1. 각 역량에서 **indicator_count가 가장 큰 것**을 **유지**
2. 나머지 ID를 **삭제 대상**으로 기록

**예시:**
```
유지: ID 5, 8, 15, 20
삭제: ID 12, 18, 25, 28, 35, 40
```

### 4단계: 중복 역량 삭제

삭제할 ID를 확정했으면, 다음 2개 SQL을 실행:

#### 4-1. 행동 지표 삭제 (먼저 실행)
```sql
DELETE FROM behavioral_indicators 
WHERE competency_id IN (삭제할ID1, 삭제할ID2, 삭제할ID3, ...);
```

**예시:**
```sql
DELETE FROM behavioral_indicators 
WHERE competency_id IN (12, 18, 25, 28, 35, 40);
```

#### 4-2. 역량 삭제 (다음 실행)
```sql
DELETE FROM competencies 
WHERE id IN (삭제할ID1, 삭제할ID2, 삭제할ID3, ...);
```

**예시:**
```sql
DELETE FROM competencies 
WHERE id IN (12, 18, 25, 28, 35, 40);
```

### 5단계: 검증

삭제 후 검증 쿼리 실행:

```sql
-- 중복 확인 (결과가 비어있어야 함)
SELECT keyword, COUNT(*) as count 
FROM competencies 
GROUP BY keyword 
HAVING count > 1;
```

**예상 결과:** 빈 배열 (중복 없음)

```sql
-- 해당 역량들이 1개씩만 있는지 확인
SELECT keyword, COUNT(*) as count 
FROM competencies 
WHERE keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
GROUP BY keyword;
```

**예상 결과:**
```
keyword        | count
리더십         | 1
문제해결       | 1
시장분석       | 1
커뮤니케이션   | 1
```

## 📊 빠른 참조 테이블

| 역량명 | 중복 수 | 조치 |
|--------|---------|------|
| 리더십 | 2개 | indicator_count 가장 큰 것 유지 |
| 문제해결 | 3개 | indicator_count 가장 큰 것 유지 |
| 시장분석 | 2개 | indicator_count 가장 큰 것 유지 |
| 커뮤니케이션 | 3개 | indicator_count 가장 큰 것 유지 |

## ⚠️ 주의사항

1. **반드시 2단계의 확인 쿼리를 먼저 실행**하여 어떤 ID를 삭제할지 결정
2. **행동 지표를 먼저 삭제** (외래 키 제약 조건 때문)
3. **삭제 후 반드시 검증** 쿼리 실행
4. 잘못 삭제한 경우 복구 어려움 - 신중하게 진행

## 🔧 편의 도구

### 전체 상세 정보 한 번에 보기
```sql
SELECT 
  c.id, 
  c.keyword, 
  c.description,
  c.job_name,
  cm.name as model_name, 
  COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
GROUP BY c.id, c.keyword, c.description, c.job_name, cm.name
ORDER BY c.keyword, indicator_count DESC;
```

이 쿼리 결과에서:
- 각 keyword의 **첫 번째 행 (indicator_count 가장 큰 것)** → 유지
- 나머지 행들 → 삭제 대상

## 📚 관련 파일

- **check_all_duplicates.sql** - 상세 확인용 쿼리 모음
- **remove_duplicates_smart.sql** - 스마트 제거 스크립트
- **DEDUPLICATION_GUIDE.md** - 이전 중복 제거 가이드

## ✅ 완료 체크리스트

- [ ] 1단계: Cloudflare Dashboard 접속
- [ ] 2단계: 각 중복의 상세 정보 확인
- [ ] 3단계: 삭제할 ID 목록 작성
- [ ] 4-1단계: 행동 지표 삭제 실행
- [ ] 4-2단계: 역량 삭제 실행
- [ ] 5단계: 검증 쿼리 실행 및 확인

---

**작성일**: 2025-11-04  
**대상**: 프로덕션 DB (aiassess-production)  
**중복 수**: 10개 역량 → 4개 역량 (6개 제거 예상)
