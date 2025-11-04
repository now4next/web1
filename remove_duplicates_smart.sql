-- 스마트 중복 제거 스크립트
-- 전략: 각 중복 역량에서 행동 지표가 가장 많은 것을 유지하고 나머지 삭제

-- ============================================================================
-- 1단계: 유지할 역량 ID 확인 (행동 지표가 가장 많은 것)
-- ============================================================================

-- 리더십 - 행동 지표가 가장 많은 ID 확인
SELECT c.id, c.keyword, cm.name as model_name, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword = '리더십'
GROUP BY c.id, c.keyword, cm.name
ORDER BY indicator_count DESC;

-- 문제해결 - 행동 지표가 가장 많은 ID 확인
SELECT c.id, c.keyword, cm.name as model_name, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword = '문제해결'
GROUP BY c.id, c.keyword, cm.name
ORDER BY indicator_count DESC;

-- 시장분석 - 행동 지표가 가장 많은 ID 확인
SELECT c.id, c.keyword, cm.name as model_name, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword = '시장분석'
GROUP BY c.id, c.keyword, cm.name
ORDER BY indicator_count DESC;

-- 커뮤니케이션 - 행동 지표가 가장 많은 ID 확인
SELECT c.id, c.keyword, cm.name as model_name, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword = '커뮤니케이션'
GROUP BY c.id, c.keyword, cm.name
ORDER BY indicator_count DESC;

-- ============================================================================
-- 2단계: 위 결과를 보고 삭제할 ID를 수동으로 결정
-- ============================================================================
-- 예시: 
-- 리더십 - ID 5 (지표 3개), ID 12 (지표 1개), ID 25 (지표 2개)
-- → ID 5를 유지하고 ID 12, 25를 삭제

-- ============================================================================
-- 3단계: 실제 삭제 (아래 템플릿을 사용하여 실제 ID로 교체)
-- ============================================================================

-- 템플릿:
-- DELETE FROM behavioral_indicators WHERE competency_id IN (삭제할ID1, 삭제할ID2, ...);
-- DELETE FROM competencies WHERE id IN (삭제할ID1, 삭제할ID2, ...);

-- 예시 (실제 ID로 교체하세요):
-- DELETE FROM behavioral_indicators WHERE competency_id IN (12, 25, 35, 40);
-- DELETE FROM competencies WHERE id IN (12, 25, 35, 40);

-- ============================================================================
-- 4단계: 검증
-- ============================================================================

-- 중복 확인 (결과가 비어있어야 함)
SELECT keyword, COUNT(*) as count 
FROM competencies 
WHERE keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
GROUP BY keyword;

-- 전체 중복 확인
SELECT keyword, COUNT(*) as count 
FROM competencies 
GROUP BY keyword 
HAVING count > 1;
