-- 완전한 중복 제거 스크립트
-- 모든 참조 테이블까지 포함하여 외래 키 오류 방지

-- ============================================================================
-- 주의: 이 스크립트는 다음 순서로 삭제합니다
-- 1. analysis_results (분석 결과)
-- 2. session_competencies (세션-역량 매핑)
-- 3. assessment_questions (진단 문항)
-- 4. behavioral_indicators (행동 지표)
-- 5. competencies (역량)
-- ============================================================================

-- ============================================================================
-- 1단계: 삭제할 역량 ID 확인
-- ============================================================================

-- 중복된 역량 중에서 삭제할 ID 조회
SELECT c.id, c.keyword, cm.name as model_name
FROM competencies c
JOIN competency_models cm ON c.model_id = cm.id
WHERE cm.name = '경영지원 직무역량'
AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고');

-- ============================================================================
-- 2단계: 각 테이블에서 참조 개수 확인
-- ============================================================================

-- analysis_results 확인
SELECT 'analysis_results' as table_name, COUNT(*) as count
FROM analysis_results 
WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- session_competencies 확인
SELECT 'session_competencies' as table_name, COUNT(*) as count
FROM session_competencies 
WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- assessment_questions 확인
SELECT 'assessment_questions' as table_name, COUNT(*) as count
FROM assessment_questions 
WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- behavioral_indicators 확인
SELECT 'behavioral_indicators' as table_name, COUNT(*) as count
FROM behavioral_indicators 
WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- ============================================================================
-- 3단계: 모든 참조 데이터 삭제 (순서대로 실행)
-- ============================================================================

-- 3-1. analysis_results 삭제
DELETE FROM analysis_results 
WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- 3-2. session_competencies 삭제
DELETE FROM session_competencies 
WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- 3-3. assessment_questions 삭제
DELETE FROM assessment_questions 
WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- 3-4. behavioral_indicators 삭제
DELETE FROM behavioral_indicators 
WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- 3-5. competencies 삭제
DELETE FROM competencies 
WHERE id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- ============================================================================
-- 4단계: 검증
-- ============================================================================

-- 중복 확인 (결과가 비어있어야 함)
SELECT keyword, COUNT(*) as count 
FROM competencies 
WHERE keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
GROUP BY keyword;

-- 전체 중복 확인
SELECT keyword, COUNT(*) as count 
FROM competencies 
GROUP BY keyword 
HAVING count > 1;
