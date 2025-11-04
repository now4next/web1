-- 모든 중복 역량 상세 조회
-- 프로덕션 DB에서 실행하여 중복 상황을 파악

-- 1. 중복된 역량 키워드 목록
SELECT keyword, COUNT(*) as count 
FROM competencies 
GROUP BY keyword 
HAVING count > 1 
ORDER BY count DESC, keyword;

-- 2. 리더십 중복 상세
SELECT c.id, c.keyword, c.description, c.job_name, cm.name as model_name, cm.type as model_type
FROM competencies c 
JOIN competency_models cm ON c.model_id = cm.id 
WHERE c.keyword = '리더십'
ORDER BY c.id;

-- 3. 문제해결 중복 상세
SELECT c.id, c.keyword, c.description, c.job_name, cm.name as model_name, cm.type as model_type
FROM competencies c 
JOIN competency_models cm ON c.model_id = cm.id 
WHERE c.keyword = '문제해결'
ORDER BY c.id;

-- 4. 시장분석 중복 상세
SELECT c.id, c.keyword, c.description, c.job_name, cm.name as model_name, cm.type as model_type
FROM competencies c 
JOIN competency_models cm ON c.model_id = cm.id 
WHERE c.keyword = '시장분석'
ORDER BY c.id;

-- 5. 커뮤니케이션 중복 상세
SELECT c.id, c.keyword, c.description, c.job_name, cm.name as model_name, cm.type as model_type
FROM competencies c 
JOIN competency_models cm ON c.model_id = cm.id 
WHERE c.keyword = '커뮤니케이션'
ORDER BY c.id;

-- 6. 각 중복의 행동 지표 개수 확인
SELECT c.keyword, c.id, cm.name as model_name, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
GROUP BY c.keyword, c.id, cm.name
ORDER BY c.keyword, c.id;
