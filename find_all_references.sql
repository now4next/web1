-- 특정 역량 ID들이 어느 테이블에서 참조되는지 모두 찾기
-- 1단계에서 확인한 ID들을 여기에 입력하세요

-- 예시: ID 1, 2, 3, 6을 삭제하려는 경우
-- 아래 쿼리의 (1, 2, 3, 6) 부분을 실제 ID로 교체

-- ============================================================================
-- 모든 테이블에서 참조 확인
-- ============================================================================

-- analysis_results
SELECT 'analysis_results' as table_name, competency_id, COUNT(*) as count
FROM analysis_results 
WHERE competency_id IN (1, 2, 3, 6)
GROUP BY competency_id;

-- session_competencies  
SELECT 'session_competencies' as table_name, competency_id, COUNT(*) as count
FROM session_competencies 
WHERE competency_id IN (1, 2, 3, 6)
GROUP BY competency_id;

-- assessment_questions
SELECT 'assessment_questions' as table_name, competency_id, COUNT(*) as count
FROM assessment_questions 
WHERE competency_id IN (1, 2, 3, 6)
GROUP BY competency_id;

-- behavioral_indicators
SELECT 'behavioral_indicators' as table_name, competency_id, COUNT(*) as count
FROM behavioral_indicators 
WHERE competency_id IN (1, 2, 3, 6)
GROUP BY competency_id;

-- assessment_responses (혹시 있을 수 있음)
SELECT 'assessment_responses' as table_name, competency_id, COUNT(*) as count
FROM assessment_responses 
WHERE competency_id IN (1, 2, 3, 6)
GROUP BY competency_id;

-- ============================================================================
-- 결과 해석
-- ============================================================================
-- count > 0 인 테이블들에서 해당 역량을 참조하고 있음
-- 그 테이블들을 먼저 정리해야 함
