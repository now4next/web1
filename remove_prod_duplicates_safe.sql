-- 프로덕션 중복 제거 - 안전 버전
-- 외래 키 제약조건을 비활성화하고 실행

-- ============================================================================
-- 중요: 이 파일을 실행하기 전에 반드시 삭제할 ID를 확인하세요!
-- ============================================================================

-- 1단계: 외래 키 비활성화
PRAGMA foreign_keys = OFF;

-- 2단계: 현재 중복 상태 확인 (주석으로 처리, 실제 실행 시 제거)
-- SELECT keyword, COUNT(*) as count FROM competencies GROUP BY keyword HAVING count > 1;

-- 3단계: 각 중복 역량의 상세 정보 (주석으로 처리, 실제 실행 시 제거)
-- SELECT c.id, c.keyword, cm.name, COUNT(bi.id) as indicators
-- FROM competencies c
-- LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
-- JOIN competency_models cm ON c.model_id = cm.id
-- WHERE c.keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
-- GROUP BY c.id, c.keyword, cm.name
-- ORDER BY c.keyword, indicators DESC;

-- ============================================================================
-- 4단계: 삭제 실행
-- 아래 ID 목록을 실제 삭제할 ID로 교체하세요
-- ============================================================================

-- 경영지원 직무역량 모델의 4개 중복 제거 (확정된 항목)
DELETE FROM analysis_results WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

DELETE FROM session_competencies WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

DELETE FROM assessment_questions WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

DELETE FROM behavioral_indicators WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

DELETE FROM competencies WHERE id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- ============================================================================
-- 추가 중복 제거 (리더십, 문제해결, 시장분석, 커뮤니케이션)
-- 실제 ID를 확인한 후 아래 주석을 해제하고 ID를 입력하세요
-- ============================================================================

-- 예시: 삭제할 ID가 12, 18, 25, 28, 35, 40이라면
-- DELETE FROM analysis_results WHERE competency_id IN (12, 18, 25, 28, 35, 40);
-- DELETE FROM session_competencies WHERE competency_id IN (12, 18, 25, 28, 35, 40);
-- DELETE FROM assessment_questions WHERE competency_id IN (12, 18, 25, 28, 35, 40);
-- DELETE FROM behavioral_indicators WHERE competency_id IN (12, 18, 25, 28, 35, 40);
-- DELETE FROM competencies WHERE id IN (12, 18, 25, 28, 35, 40);

-- ============================================================================
-- 5단계: 외래 키 다시 활성화
-- ============================================================================
PRAGMA foreign_keys = ON;

-- ============================================================================
-- 6단계: 검증
-- ============================================================================

-- 경영지원 직무역량 중복 확인
SELECT keyword, COUNT(*) as count 
FROM competencies 
WHERE keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
GROUP BY keyword;

-- 전체 중복 확인
SELECT keyword, COUNT(*) as count 
FROM competencies 
GROUP BY keyword 
HAVING count > 1;

-- 총 역량 수
SELECT COUNT(*) as total_competencies FROM competencies;
