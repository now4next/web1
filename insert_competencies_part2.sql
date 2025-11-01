정보기술(IT) - 시스템 운영능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '시스템 운영능력', '운영 환경의 문제를 인식하고 해결하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '시스템 운영능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '장애 원인을 진단하고 신속히 복구하여 운영 안정성을 확보한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '시스템 운영능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '장애 원인을 진단하고 신속히 복구하여 운영 안정성을 확보한다.'
);

-- 기획/관리 - 전략적 사고/기획
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '전략적 사고/기획', '내·외부 요인을 장기·포괄적으로 고려하여 문제 해결과 의사결정을 수행하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '전략적 사고/기획'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '조직 전략과 부합하는 기획안을 수립하고 목표 달성 경로를 설계한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '전략적 사고/기획'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '조직 전략과 부합하는 기획안을 수립하고 목표 달성 경로를 설계한다.'
);

-- 인사(HR) - 업무지식활용능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '업무지식활용능력', '업무 수행에 필요한 최신 지식과 기술을 습득·활용하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '업무지식활용능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '새로운 제도나 기법을 학습하고 이를 업무에 적용하여 개선한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '업무지식활용능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '새로운 제도나 기법을 학습하고 이를 업무에 적용하여 개선한다.'
);

-- 인사(HR) - 업무조정 및 협상력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '업무조정 및 협상력', '이해관계자 간 조정을 통해 상호 발전적 결과를 도출하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '업무조정 및 협상력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '부서 간 의견을 조율하고 합리적인 대안을 도출한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '업무조정 및 협상력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '부서 간 의견을 조율하고 합리적인 대안을 도출한다.'
);

-- 인사(HR) - 제도개선능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '제도개선능력', '조직의 성과를 높이기 위해 제도와 규정을 개선하는 능력'
FROM competency_models m
WHERE m.name = '경영지원 직무역량'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '제도개선능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '현행 제도의 문제점을 분석하고 개선안을 설계·시행한다.', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '경영지원 직무역량' AND c.keyword = '제도개선능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '현행 제도의 문제점을 분석하고 개선안을 설계·시행한다.'
);