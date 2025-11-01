법무/컴플라이언스 - 소송관리능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '소송관리능력', '법적 분쟁 상황에서 유리한 소송 환경을 조성하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '소송관리능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '소송 진행 절차를 관리하고 변호사와 협업하여 대응한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '소송관리능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '소송 진행 절차를 관리하고 변호사와 협업하여 대응한다.'
);

-- 교육/조직개발 - 교육과정개발능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '교육과정개발능력', '교육과정을 설계·개발하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '교육과정개발능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '교육대상과 목적에 맞는 커리큘럼을 설계하고 콘텐츠를 제작한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '교육과정개발능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '교육대상과 목적에 맞는 커리큘럼을 설계하고 콘텐츠를 제작한다.'
);

-- 교육/조직개발 - 교육과정운영능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '교육과정운영능력', '교육과정을 효과적으로 운영하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '교육과정운영능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '강사 및 참여자 관리, 일정 조정 등 교육 실행을 원활히 진행한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '교육과정운영능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '강사 및 참여자 관리, 일정 조정 등 교육 실행을 원활히 진행한다.'
);

-- 교육/조직개발 - 교육효과평가기법활용능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '교육효과평가기법활용능력', '교육성과를 평가하고 개선하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '교육효과평가기법활용능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '평가도구를 활용하여 교육효과를 분석하고 개선안을 도출한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '교육효과평가기법활용능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '평가도구를 활용하여 교육효과를 분석하고 개선안을 도출한다.'
);

-- 시설/안전 - 시설유지관리능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '시설유지관리능력', '시설물의 유지·보수를 관리하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '시설유지관리능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '법규를 준수하며 시설물의 점검·보수를 체계적으로 수행한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '시설유지관리능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '법규를 준수하며 시설물의 점검·보수를 체계적으로 수행한다.'
);

