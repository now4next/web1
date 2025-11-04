홍보 - 창의적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '창의적 사고', '관련성이 적은 개념들 속에서 새롭고 독창적인 연계성을 파악해 가치 있는 아이디어를 창출하는 역량. 목표 달성을 위해 새로운 아이디어와 개념을 적용하여 변화를 시도하거나 창의적인 해결안을 도출하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '창의적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 브레인스토밍을 통해 제한된 시간 안에 다양한 아이디어를 제안한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '창의적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 브레인스토밍을 통해 제한된 시간 안에 다양한 아이디어를 제안한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 문제나 상황을 다양한 시각에서 본다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '창의적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 문제나 상황을 다양한 시각에서 본다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 기존의 관례적인 방법을 통해서만 문제를 해결하려 하지 않는다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '창의적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 기존의 관례적인 방법을 통해서만 문제를 해결하려 하지 않는다'
);

-- 회계 - 예산운용능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '예산운용능력', '조직의 예산을 효율적으로 계획, 실행, 통제하는 역량. 예산의 편성부터 집행, 성과분석까지 전 과정을 체계적으로 관리하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '예산운용능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 합리적인 근거를 바탕으로 예산을 편성한다\n2. 예산 집행 과정을 지속적으로 모니터링한다\n3. 예산 대비 실적을 분석하여 개선방안을 도출한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '예산운용능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 합리적인 근거를 바탕으로 예산을 편성한다\n2. 예산 집행 과정을 지속적으로 모니터링한다\n3. 예산 대비 실적을 분석하여 개선방안을 도출한다'
);

