# 외래 키 오류 해결 가이드

## 🔴 오류 메시지
```
제출 중 오류가 발생했습니다: D1_ERROR: FOREIGN KEY constraint failed: SQLITE_CONSTRAINT
```

## 🔍 원인

역량(competencies)을 삭제하려고 할 때, 다른 테이블들이 해당 역량을 참조하고 있어서 발생합니다.

**참조하는 테이블들:**
1. `analysis_results` - 분석 결과
2. `session_competencies` - 세션-역량 매핑
3. `assessment_questions` - 진단 문항
4. `behavioral_indicators` - 행동 지표

## ✅ 해결 방법

중복 역량을 삭제하기 전에, 해당 역량을 참조하는 모든 데이터를 먼저 삭제해야 합니다.

### 삭제 순서 (매우 중요!)

```
1. analysis_results (분석 결과)
2. session_competencies (세션-역량 매핑)
3. assessment_questions (진단 문항)
4. behavioral_indicators (행동 지표)
5. competencies (역량) ← 마지막에 삭제
```

## 📝 프로덕션 DB 중복 제거 완전 가이드

### 1단계: 삭제 대상 확인

Cloudflare Dashboard → D1 → aiassess-production → Console에서:

```sql
-- 삭제할 역량 ID 확인
SELECT c.id, c.keyword, cm.name as model_name
FROM competencies c
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
ORDER BY c.keyword, c.id;
```

**각 역량의 행동 지표 수 확인:**
```sql
SELECT c.id, c.keyword, cm.name as model_name, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
GROUP BY c.id, c.keyword, cm.name
ORDER BY c.keyword, indicator_count DESC;
```

**유지할 ID와 삭제할 ID를 결정:**
- 각 역량에서 `indicator_count`가 **가장 큰 것을 유지**
- 나머지를 삭제 대상으로 기록

**예시:**
```
유지: ID 5, 10, 15, 20
삭제: ID 3, 8, 12, 18, 25, 30
```

### 2단계: 참조 데이터 확인

삭제할 ID들이 다른 테이블에서 얼마나 참조되는지 확인:

```sql
-- analysis_results 확인
SELECT COUNT(*) as count FROM analysis_results 
WHERE competency_id IN (3, 8, 12, 18, 25, 30);

-- session_competencies 확인
SELECT COUNT(*) as count FROM session_competencies 
WHERE competency_id IN (3, 8, 12, 18, 25, 30);

-- assessment_questions 확인
SELECT COUNT(*) as count FROM assessment_questions 
WHERE competency_id IN (3, 8, 12, 18, 25, 30);

-- behavioral_indicators 확인
SELECT COUNT(*) as count FROM behavioral_indicators 
WHERE competency_id IN (3, 8, 12, 18, 25, 30);
```

### 3단계: 참조 데이터 삭제 (순서대로!)

**⚠️ 주의: 아래 SQL의 ID를 2단계에서 결정한 실제 삭제 ID로 교체하세요**

```sql
-- 3-1. analysis_results 삭제
DELETE FROM analysis_results 
WHERE competency_id IN (3, 8, 12, 18, 25, 30);

-- 3-2. session_competencies 삭제
DELETE FROM session_competencies 
WHERE competency_id IN (3, 8, 12, 18, 25, 30);

-- 3-3. assessment_questions 삭제
DELETE FROM assessment_questions 
WHERE competency_id IN (3, 8, 12, 18, 25, 30);

-- 3-4. behavioral_indicators 삭제
DELETE FROM behavioral_indicators 
WHERE competency_id IN (3, 8, 12, 18, 25, 30);

-- 3-5. competencies 삭제 (마지막!)
DELETE FROM competencies 
WHERE id IN (3, 8, 12, 18, 25, 30);
```

### 4단계: 검증

```sql
-- 해당 역량들이 1개씩만 있는지 확인
SELECT keyword, COUNT(*) as count 
FROM competencies 
WHERE keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
GROUP BY keyword;
```

**예상 결과:**
```
keyword      | count
리더십       | 1
문제해결     | 1
시장분석     | 1
커뮤니케이션 | 1
```

```sql
-- 전체 중복 확인 (비어있어야 함)
SELECT keyword, COUNT(*) as count 
FROM competencies 
GROUP BY keyword 
HAVING count > 1;
```

## 🎯 간편 버전 (모든 중복에 대해)

만약 **모든 중복 역량**을 제거하고 싶다면:

### Option 1: 특정 모델 기준 (추천)

"경영지원 직무역량" 모델의 4개 중복만 제거:

```sql
-- 1. analysis_results
DELETE FROM analysis_results WHERE competency_id IN (
  SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량' 
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- 2. session_competencies
DELETE FROM session_competencies WHERE competency_id IN (
  SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- 3. assessment_questions
DELETE FROM assessment_questions WHERE competency_id IN (
  SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- 4. behavioral_indicators
DELETE FROM behavioral_indicators WHERE competency_id IN (
  SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- 5. competencies (마지막)
DELETE FROM competencies WHERE id IN (
  SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);
```

### Option 2: 개별 ID 지정 (가장 안전)

1단계에서 확인한 삭제 ID를 직접 지정:

```sql
-- 예시: 삭제할 ID가 1, 2, 3, 6이라고 가정
DELETE FROM analysis_results WHERE competency_id IN (1, 2, 3, 6);
DELETE FROM session_competencies WHERE competency_id IN (1, 2, 3, 6);
DELETE FROM assessment_questions WHERE competency_id IN (1, 2, 3, 6);
DELETE FROM behavioral_indicators WHERE competency_id IN (1, 2, 3, 6);
DELETE FROM competencies WHERE id IN (1, 2, 3, 6);
```

## ⚠️ 데이터 손실 주의

위 작업은 다음 데이터를 삭제합니다:
- ❌ 해당 역량으로 생성된 진단 문항
- ❌ 해당 역량이 포함된 세션 매핑
- ❌ 해당 역량의 분석 결과
- ❌ 해당 역량의 행동 지표

**권장사항:**
1. 삭제 전에 2단계의 확인 쿼리로 영향 범위 파악
2. 중요한 데이터가 있다면 백업 또는 마이그레이션 고려
3. 테스트 환경에서 먼저 실행 후 프로덕션 적용

## 🔄 데이터 마이그레이션 방법 (선택사항)

만약 삭제할 역량의 데이터를 유지하려면, 참조를 유지할 역량 ID로 변경:

```sql
-- 예시: ID 1의 데이터를 ID 20으로 이동
UPDATE analysis_results SET competency_id = 20 WHERE competency_id = 1;
UPDATE session_competencies SET competency_id = 20 WHERE competency_id = 1;
UPDATE assessment_questions SET competency_id = 20 WHERE competency_id = 1;
-- behavioral_indicators는 이동하지 않음 (삭제)

-- 그 후 역량 삭제
DELETE FROM behavioral_indicators WHERE competency_id = 1;
DELETE FROM competencies WHERE id = 1;
```

## 📚 관련 파일

- **remove_duplicates_complete.sql** - 완전한 중복 제거 SQL
- **DUPLICATE_REMOVAL_STEPS.md** - 단계별 가이드
- **check_all_duplicates.sql** - 확인용 쿼리

## ✅ 체크리스트

- [ ] 1단계: 삭제 대상 ID 확인 및 결정
- [ ] 2단계: 참조 데이터 개수 확인
- [ ] 3-1단계: analysis_results 삭제
- [ ] 3-2단계: session_competencies 삭제
- [ ] 3-3단계: assessment_questions 삭제
- [ ] 3-4단계: behavioral_indicators 삭제
- [ ] 3-5단계: competencies 삭제
- [ ] 4단계: 검증 완료

---

**작성일**: 2025-11-04  
**핵심**: 외래 키 오류 해결을 위해 참조 테이블을 먼저 정리!  
**순서**: analysis_results → session_competencies → assessment_questions → behavioral_indicators → competencies
