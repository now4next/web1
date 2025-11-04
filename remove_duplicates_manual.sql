-- 중복 역량 제거 - Cloudflare D1 Console용
-- 다음 3개 SQL문을 순서대로 실행하세요

-- 1단계: 행동 지표 삭제
DELETE FROM behavioral_indicators WHERE competency_id IN (SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id WHERE cm.name = '경영지원 직무역량' AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고'));

-- 2단계: 중복 역량 삭제
DELETE FROM competencies WHERE id IN (SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id WHERE cm.name = '경영지원 직무역량' AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고'));

-- 3단계: 검증 (각 역량이 1개씩만 있어야 함)
SELECT keyword, COUNT(*) as count FROM competencies WHERE keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고') GROUP BY keyword;
