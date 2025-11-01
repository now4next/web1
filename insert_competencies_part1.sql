-- 경영지원 직군 역량사전 데이터 삽입
-- 총 20개 역량

-- Step 1: 경영지원 직무역량 모델 생성
INSERT INTO competency_models (name, type, description, target_level) 
SELECT '경영지원 직무역량', 'functional', '경영지원 직군의 전문 역량 모델 (감사/기획, IT, 인사, 법무, 교육 등)', 'all'
WHERE NOT EXISTS (SELECT 1 FROM competency_models WHERE name = '경영지원 직무역량');



-- 감사/기획 - 분석적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '분석적 사고', '타당한 정보를 근거로 논리적으로 사고해 의미 있는 결론을 도출하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '분석적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '사실 중심으로 정확성을 판단하고, 근본 원인을 파악하여 문제 해결 및 의사결정에 활용한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '분석적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '사실 중심으로 정확성을 판단하고, 근본 원인을 파악하여 문제 해결 및 의사결정에 활용한다.'
);

-- 감사/기획 - 의사결정/판단력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '의사결정/판단력', '객관 기준과 근거에 따라 단·장기 효과를 고려해 타당한 결론을 도출하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '의사결정/판단력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '조직에 미치는 단·장기적 영향을 고려하여 데이터를 기반으로 결정을 내린다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '의사결정/판단력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '조직에 미치는 단·장기적 영향을 고려하여 데이터를 기반으로 결정을 내린다.'
);

-- 감사/기획 - 창의적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '창의적 사고', '서로 관련성 낮은 개념 간 연계성을 발견해 새로운 아이디어를 창출하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '창의적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '새로운 아이디어를 실험적으로 시도하고 문제 해결에 적용한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '창의적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '새로운 아이디어를 실험적으로 시도하고 문제 해결에 적용한다.'
);

-- 정보기술(IT) - 분석적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '분석적 사고', '데이터 흐름을 파악하고 근본 원인을 세밀히 파악하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '분석적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '복잡한 데이터 속 패턴과 원인을 논리적으로 도출한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '분석적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '복잡한 데이터 속 패턴과 원인을 논리적으로 도출한다.'
);

-- 정보기술(IT) - 시스템 개발능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '시스템 개발능력', '요구사항에 부합하는 시스템을 계획·분석·설계·구현하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '시스템 개발능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '사용자 요구를 반영하여 시스템을 안정적으로 개발·운영한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '시스템 개발능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '사용자 요구를 반영하여 시스템을 안정적으로 개발·운영한다.'
);