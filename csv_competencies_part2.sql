기술지원 - 정보수집 및 활용
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '정보수집 및 활용', '관련업무 및 그 이상의 주제에 대해서 관심을 갖고 여러 방법을 활용하여 정보를 수집하고, 이를 이용 가능한 정보로 가공/활용하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '정보수집 및 활용'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 직무와 관련된 대내외의 고급정보를 다양한 채널을 통하여 효율적으로 확보할 수 있음\n2. 수집한 정보를 분류, 분석하여 업무 추진에 적극 활용함\n3. 정보에 담겨 있는 의미를 도출하고 유관부서와 협의하여 계획 및 전략 수립에 반영함', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '정보수집 및 활용'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 직무와 관련된 대내외의 고급정보를 다양한 채널을 통하여 효율적으로 확보할 수 있음\n2. 수집한 정보를 분류, 분석하여 업무 추진에 적극 활용함\n3. 정보에 담겨 있는 의미를 도출하고 유관부서와 협의하여 계획 및 전략 수립에 반영함'
);

-- 마케팅 - 데이터 분석
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '데이터 분석', '마케팅 데이터를 수집, 분석하여 인사이트를 도출하고 의사결정에 활용하는 역량. 정량적 데이터와 정성적 정보를 통합하여 마케팅 전략 수립을 지원하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '데이터 분석'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 다양한 마케팅 데이터를 체계적으로 수집하고 분석한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '데이터 분석'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 다양한 마케팅 데이터를 체계적으로 수집하고 분석한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 데이터 분석 결과를 바탕으로 마케팅 인사이트를 도출한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '데이터 분석'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 데이터 분석 결과를 바탕으로 마케팅 인사이트를 도출한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 데이터 기반의 의사결정을 통해 마케팅 성과를 개선한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '데이터 분석'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 데이터 기반의 의사결정을 통해 마케팅 성과를 개선한다'
);

-- 마케팅 - 디지털 마케팅
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '디지털 마케팅', '디지털 채널과 플랫폼을 활용한 마케팅 전략을 수립하고 실행하는 역량. 데이터 기반의 디지털 마케팅 캠페인을 기획하고 성과를 분석하여 최적화하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '디지털 마케팅'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 디지털 채널별 특성을 이해하고 적합한 마케팅 전략을 수립한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '디지털 마케팅'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 디지털 채널별 특성을 이해하고 적합한 마케팅 전략을 수립한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 데이터 분석을 통해 타겟 고객을 정확히 세분화한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '디지털 마케팅'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 데이터 분석을 통해 타겟 고객을 정확히 세분화한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 디지털 캠페인의 성과를 측정하고 지속적으로 개선한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '디지털 마케팅'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 디지털 캠페인의 성과를 측정하고 지속적으로 개선한다'
);

-- 마케팅 - 브랜드 관리
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '브랜드 관리', '브랜드의 가치를 창출하고 유지하며 발전시키기 위한 전략을 수립하고 실행하는 역량. 브랜드 아이덴티티를 일관성 있게 관리하고 브랜드 경험을 최적화하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '브랜드 관리'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 브랜드 포지셔닝을 명확히 정의하고 관리한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '브랜드 관리'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 브랜드 포지셔닝을 명확히 정의하고 관리한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 일관된 브랜드 메시지를 전달한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '브랜드 관리'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 일관된 브랜드 메시지를 전달한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 브랜드 가치 향상을 위한 마케팅 활동을 기획하고 실행한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '브랜드 관리'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 브랜드 가치 향상을 위한 마케팅 활동을 기획하고 실행한다'
);

-- 마케팅 - 시장분석
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '시장분석', '비즈니스나 조직에 영향을 미칠 수 있는 현재와 미래의 시장 동향, 소비자/고객 정보, 환경 변화, 트렌드 자료 등에 대한 지식을 감지/예측하여 업무에 적용하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '시장분석'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 시장 트렌드를 정확히 파악하고 분석한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '시장분석'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 시장 트렌드를 정확히 파악하고 분석한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 경쟁사 동향을 지속적으로 모니터링한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '시장분석'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 경쟁사 동향을 지속적으로 모니터링한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 시장 정보를 바탕으로 전략적 의사결정을 지원한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '시장분석'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 시장 정보를 바탕으로 전략적 의사결정을 지원한다'
);

-- 마케팅 - 창의적 기획
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '창의적 기획', '혁신적이고 차별화된 마케팅 아이디어를 창출하고 이를 실행 가능한 캠페인으로 기획하는 역량. 시장과 고객의 니즈를 반영한 창의적 솔루션을 개발하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '창의적 기획'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 독창적이고 차별화된 마케팅 아이디어를 개발한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '창의적 기획'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 독창적이고 차별화된 마케팅 아이디어를 개발한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 창의적 아이디어를 실행 가능한 마케팅 전략으로 구체화한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '창의적 기획'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 창의적 아이디어를 실행 가능한 마케팅 전략으로 구체화한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 혁신적인 마케팅 캠페인을 통해 브랜드 차별화를 실현한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '창의적 기획'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 혁신적인 마케팅 캠페인을 통해 브랜드 차별화를 실현한다'
);

-- 법무 - 분석적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '분석적 사고', '타당한 정보를 근거로 논리 정연하게 사고하여 정확하고 의미 있는 결론을 도출하는 역량. 정보를 체계적으로 분석하여 핵심 요소, 상호 연관성, 경향성을 파악해 상황판단, 문제해결, 의사결정 등에 활용하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '분석적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 편파적이거나 상반되는 복잡한 자료를 분석하여 핵심 이슈를 파악한다\n2. 문제발생시 근본 원인을 세밀히 파악한다\n3. 가정/가설을 피하고 이해하지 못한 부분을 찾아 명확화 한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '분석적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 편파적이거나 상반되는 복잡한 자료를 분석하여 핵심 이슈를 파악한다\n2. 문제발생시 근본 원인을 세밀히 파악한다\n3. 가정/가설을 피하고 이해하지 못한 부분을 찾아 명확화 한다'
);

-- 법무 - 세밀/정확한 일처리
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '세밀/정확한 일처리', '세세하고 철저하게 개입하여 업무 및 그 결과물을 관리하여 품질수준을 확보하고 정확하게 업무를 처리하는 역량. 업무 목표를 염두에 두면서 세부사항을 정확하고 치밀하게 처리하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '세밀/정확한 일처리'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 각종 정보나 데이터의 정확성을 이중으로 확인한다\n2. 향후 오류 발생을 줄이고 조기에 발견할 수 있도록 업무 및 기타 활동 사항을 관리한다\n3. 업무 목표를 염두에 두면서 업무의 기한과 질(質)을 유지하기 위해 시간 및 자원을 철저히 관리한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '세밀/정확한 일처리'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 각종 정보나 데이터의 정확성을 이중으로 확인한다\n2. 향후 오류 발생을 줄이고 조기에 발견할 수 있도록 업무 및 기타 활동 사항을 관리한다\n3. 업무 목표를 염두에 두면서 업무의 기한과 질(質)을 유지하기 위해 시간 및 자원을 철저히 관리한다'
);

-- 비서 - 전략적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '전략적 사고', '각종 전략의 수립과정에서 산업환경 변화가 조직의 장기적인 경쟁 우위에 미치는 영향을 체계적으로 분석하고 평가하여 전략 대안을 도출하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '전략적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 장기적 관점에서 조직의 비전과 목표를 설정한다\n2. 내외부 환경 변화를 지속적으로 모니터링한다\n3. 전략적 의사결정을 위한 다양한 대안을 검토한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '전략적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 장기적 관점에서 조직의 비전과 목표를 설정한다\n2. 내외부 환경 변화를 지속적으로 모니터링한다\n3. 전략적 의사결정을 위한 다양한 대안을 검토한다'
);

-- 비서 - 체계적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '체계적 사고', '업무나 상황을 체계적이고 논리적으로 분석하여 전체적인 맥락에서 이해하고 접근하는 역량. 복잡한 문제를 단계별로 분해하여 해결방안을 도출하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '체계적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 복잡한 업무를 체계적으로 분류하고 우선순위를 정한다\n2. 전체적인 업무 흐름을 파악하여 효율적으로 처리한다\n3. 논리적 순서에 따라 업무를 계획하고 실행한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '체계적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 복잡한 업무를 체계적으로 분류하고 우선순위를 정한다\n2. 전체적인 업무 흐름을 파악하여 효율적으로 처리한다\n3. 논리적 순서에 따라 업무를 계획하고 실행한다'
);