인사(HR) - 성과보상관리능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '성과보상관리능력', '성과 기반의 공정한 보상체계를 설계·운영하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '성과보상관리능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '조직성과와 개인성과를 연계한 보상제도를 운영한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '성과보상관리능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '조직성과와 개인성과를 연계한 보상제도를 운영한다.'
);

-- 경영기획/전략 - 경영환경/정보분석
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '경영환경/정보분석', '사업구조·시장동향 등 내·외부 환경을 분석하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '경영환경/정보분석'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '경쟁사 및 시장 트렌드를 분석하여 전략적 시사점을 도출한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '경영환경/정보분석'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '경쟁사 및 시장 트렌드를 분석하여 전략적 시사점을 도출한다.'
);

-- 경영기획/전략 - 경영성과관리능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '경영성과관리능력', '성과 목표 달성을 위한 시스템을 기획·관리·운영하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '경영성과관리능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '성과지표를 설정하고 달성률을 주기적으로 점검한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '경영성과관리능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '성과지표를 설정하고 달성률을 주기적으로 점검한다.'
);

-- 경영기획/전략 - 경영혁신 및 변화관리
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '경영혁신 및 변화관리', '프로세스를 개선하여 조직 효율성을 높이는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '경영혁신 및 변화관리'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '변화관리 계획을 수립하고 구성원의 참여를 유도한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '경영혁신 및 변화관리'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '변화관리 계획을 수립하고 구성원의 참여를 유도한다.'
);

-- 법무/컴플라이언스 - 법무실무지식활용능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '법무실무지식활용능력', '법무 절차·용어·현황 등 관련 지식을 활용하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '법무실무지식활용능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '관련 법규를 숙지하고 계약서 및 문서를 검토·관리한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '법무실무지식활용능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '관련 법규를 숙지하고 계약서 및 문서를 검토·관리한다.'
);