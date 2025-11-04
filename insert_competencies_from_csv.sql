-- 역량 평가표 데이터 삽입 (CSV 파일 기반)
-- 총 41개 역량, 15개 직무 분야

-- Step 1: 역량 평가표 모델 생성
INSERT INTO competency_models (name, type, description, target_level) 
SELECT '역량 평가표', 'functional', '직무별 상세 역량 평가 데이터 (감사/기획, 마케팅, 영업, 인사, 재경, 법무, 홍보 등)', 'all'
WHERE NOT EXISTS (SELECT 1 FROM competency_models WHERE name = '역량 평가표');

-- 감사/기획 - 분석적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '분석적 사고', '타당한 정보를 근거로 논리 정연하게 사고하여 정확하고 의미 있는 결론을 도출하는 역량. 정보를 체계적으로 분석하여 핵심 요소, 상호 연관성, 경향성을 파악해 상황판단, 문제해결, 의사결정 등에 활용하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '분석적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 구체적인 정보와 사실에 주의를 기울여 정보의 정확성을 판단한다\n2. 문제발생시 근본 원인을 세밀히 파악한다\n3. 사안을 다각도로 분석하여 정리한다(예, 비용, 리스크, 필요자원 및 기술 등)\n4. 수집된 정보의 분석 결과를 토대로 현상을 정확히 반영한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '분석적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 구체적인 정보와 사실에 주의를 기울여 정보의 정확성을 판단한다\n2. 문제발생시 근본 원인을 세밀히 파악한다\n3. 사안을 다각도로 분석하여 정리한다(예, 비용, 리스크, 필요자원 및 기술 등)\n4. 수집된 정보의 분석 결과를 토대로 현상을 정확히 반영한다'
);

-- 감사/기획 - 의사결정/판단력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '의사결정/판단력', '체계적 논리와 근거에 따라 요구에 맞는 타당한 결론을 내리는 역량. 객관적인 기준, 구체적인 사례, 잦은 의견 교환과 주의깊은 관찰을 통해 객관적 자료와 근거를 중심으로 의사결정을 하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '의사결정/판단력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 결정의 단기 및 장기적 효과를 모두 고려한다\n2. 의사결정이 미치는 조직구조, 프로세스, 구성원들의 태도 등을 포괄적이고 면밀하게 검토한다\n3. 객관적인 정보와 사실에 입각해서 의사결정한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '의사결정/판단력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 결정의 단기 및 장기적 효과를 모두 고려한다\n2. 의사결정이 미치는 조직구조, 프로세스, 구성원들의 태도 등을 포괄적이고 면밀하게 검토한다\n3. 객관적인 정보와 사실에 입각해서 의사결정한다'
);

-- 감사/기획 - 전략적 사고/기획
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '전략적 사고/기획', '내/외부 요인을 장기적이고 포괄적으로 고려하여 문제해결과 의사결정을 하는 역량. 높은 성과를 낼 수 있는 전략을 확인하고 업무 활동 및 프로세스를 체계적으로 계획하고 조직화하여 실행하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '전략적 사고/기획'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 계획 실행 시 조직에 미칠 영향력이나 장기적 관점에서 큰 그림을 그린다\n2. 조직 전략 방향에 부합되도록 부서/팀/구성원간의 역학 관계를 바탕으로 업무 계획을 조율·조정한다\n3. 수집된 정보의 분석 결과를 토대로 현상을 정확히 반영한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '전략적 사고/기획'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 계획 실행 시 조직에 미칠 영향력이나 장기적 관점에서 큰 그림을 그린다\n2. 조직 전략 방향에 부합되도록 부서/팀/구성원간의 역학 관계를 바탕으로 업무 계획을 조율·조정한다\n3. 수집된 정보의 분석 결과를 토대로 현상을 정확히 반영한다'
);

-- 감사/기획 - 창의적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '창의적 사고', '관련성이 적은 개념들 속에서 새롭고 독창적인 연계성을 파악해 가치 있는 아이디어를 창출하는 역량. 목표 달성을 위해 새로운 아이디어와 개념을 적용하여 변화를 시도하거나 창의적인 해결안을 도출하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '창의적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 창의적 아이디어를 사업적인 기회로 전환하여 제시한다\n2. 실험적 정신으로 새로운 방법과 접근식 방식으로 업무를 수행한다\n3. 문제나 상황을 다양한 시각에서 본다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '창의적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 창의적 아이디어를 사업적인 기회로 전환하여 제시한다\n2. 실험적 정신으로 새로운 방법과 접근식 방식으로 업무를 수행한다\n3. 문제나 상황을 다양한 시각에서 본다'
);

-- 관재시설 - 설득/영향력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '설득/영향력', '정보, 논리 등을 바탕으로 개인 및 집단을 설득해서 동의와 이해를 얻어내는 역량. 자기견해, 계획, 아이디어를 수용하도록 타인으로부터 필요한 지지와 지원을 끌어내고 태도나 의견을 유도하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '설득/영향력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 상대로 하여금 유익한 점을 보도록 유도함으로써 동의와 이해를 얻어낸다\n2. 자신이 주장하고자 하는 내용과 상대의 관심사를 정확히 이해한다\n3. 질문과 저항을 예상하고 준비한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '설득/영향력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 상대로 하여금 유익한 점을 보도록 유도함으로써 동의와 이해를 얻어낸다\n2. 자신이 주장하고자 하는 내용과 상대의 관심사를 정확히 이해한다\n3. 질문과 저항을 예상하고 준비한다'
);

-- 관재시설 - 팀웍/협동
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '팀웍/협동', '공통의 목표 달성을 위해 타인과 협조하는 역량. 개인적 관심사보다 팀 목표를 우선시하고, 최종 결과에 대한 팀/부서의 공동책임을 상호 이해하고 공유하여 협조하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '팀웍/협동'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 어떤 결정을 내리거나 계획을 세울 때 아이디어와 의견을 구하고 수렴한다\n2. 팀 구성원들의 다양한 개성을 인정하고 최대한 활용한다\n3. 타 부서의 협조요청에 적극적으로 임한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '팀웍/협동'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 어떤 결정을 내리거나 계획을 세울 때 아이디어와 의견을 구하고 수렴한다\n2. 팀 구성원들의 다양한 개성을 인정하고 최대한 활용한다\n3. 타 부서의 협조요청에 적극적으로 임한다'
);

-- 관재시설 - 프로젝트 관리
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '프로젝트 관리', '프로젝트의 범위 및 산출물을 정의하고, 효과적 프로세스를 설계하고 실행하는 역량. 우선순위와 시간, 그리고 자원을 효율적으로 배분 관리하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '프로젝트 관리'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 프로젝트와 관련된 장애요인 및 핵심이슈를 파악하여 극복대안을 설계 실행한다\n2. 프로젝트 수행을 위한 인적, 물적 자원의 특징을 파악하고 이를 효과적으로 배분한다\n3. 핵심 이해관계자와 범위 및 산출에 대해 동일한 시각을 형성하고, 이들의 관심사항을 정확히 이해한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '프로젝트 관리'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 프로젝트와 관련된 장애요인 및 핵심이슈를 파악하여 극복대안을 설계 실행한다\n2. 프로젝트 수행을 위한 인적, 물적 자원의 특징을 파악하고 이를 효과적으로 배분한다\n3. 핵심 이해관계자와 범위 및 산출에 대해 동일한 시각을 형성하고, 이들의 관심사항을 정확히 이해한다'
);

-- 기술지원 - 관계형성
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '관계형성', '장/단기적 비즈니스 프로세스 및 성과를 향상시키기 위해 고객, 공급자, 협력자 등 중요한 관련 주체들과의 관계를 형성하고 상호 간 신뢰를 구축하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '관계형성'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 조직의 지속적인 성과창출과 이미지 향상에 필요한 네트워크를 발굴하고 활용함\n2. 조직에 영향을 미치는 다양한 관계 집단과의 우호적인 관계를 유지함\n3. 공식적인 관계 외에도 업무수행에 도움이 되는 비공식적인 관계를 수립함', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '관계형성'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 조직의 지속적인 성과창출과 이미지 향상에 필요한 네트워크를 발굴하고 활용함\n2. 조직에 영향을 미치는 다양한 관계 집단과의 우호적인 관계를 유지함\n3. 공식적인 관계 외에도 업무수행에 도움이 되는 비공식적인 관계를 수립함'
);

-- 기술지원 - 문서작성 및 관리
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '문서작성 및 관리', '보고서나 전달하고자 하는 지식 및 정보를 문서로 체계적으로 표현하며 향후 업무수행에 용이하게 활용하기 위하여 이를 관리하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '문서작성 및 관리'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 복잡한 서면정보를 이해하고 해석하여 필요한 사항만을 논리적으로 간결하게 작성하며 설득력 있는 주장을 위해서 필요한 자료를 준비함\n2. 필요에 따라 숫자를 문장화 또는 문자를 도식화하여 문서를 작성함\n3. 문서를 보고 정보를 얻으려는 사람들이 가장 쉽게 이해할 수 있도록 문서를 작성함', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '문서작성 및 관리'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 복잡한 서면정보를 이해하고 해석하여 필요한 사항만을 논리적으로 간결하게 작성하며 설득력 있는 주장을 위해서 필요한 자료를 준비함\n2. 필요에 따라 숫자를 문장화 또는 문자를 도식화하여 문서를 작성함\n3. 문서를 보고 정보를 얻으려는 사람들이 가장 쉽게 이해할 수 있도록 문서를 작성함'
);

-- 기술지원 - 정보수집 및 활용
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

-- 영업 - 고객중심적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '고객중심적 사고', '고객의 비즈니스 니즈를 체계적으로 분석하여 체계적으로 이해하는 역량. 고객의 니즈에 맞춰 이를 충족시킬 수 있는 결정적 대안이나 융통성 있게 대응할 수 있는 전략을 설정하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '고객중심적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 고객의 니즈를 정확히 이해해 고객에게 높은 가치를 제공하는 솔루션을 개발한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '고객중심적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 고객의 니즈를 정확히 이해해 고객에게 높은 가치를 제공하는 솔루션을 개발한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 고객과의 지속적인 관계 유지를 위해 적극적으로 노력한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '고객중심적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 고객과의 지속적인 관계 유지를 위해 적극적으로 노력한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 고객 만족도 향상을 위한 개선 방안을 지속적으로 모색한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '고객중심적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 고객 만족도 향상을 위한 개선 방안을 지속적으로 모색한다'
);

-- 영업 - 관계형성
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '관계형성', '고객, 동료, 협력업체 등 중요한 관련 주체들과의 관계를 형성하고 상호간 신뢰를 구축하는 역량. 장기적 비즈니스 성과 향상에 필요한 네트워크를 발굴하고 활용하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '관계형성'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 다양한 이해관계자와 원활한 관계를 구축하고 유지한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '관계형성'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 다양한 이해관계자와 원활한 관계를 구축하고 유지한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 신뢰를 바탕으로 한 장기적 파트너십을 형성한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '관계형성'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 신뢰를 바탕으로 한 장기적 파트너십을 형성한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 네트워킹 활동을 통해 비즈니스 기회를 창출한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '관계형성'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 네트워킹 활동을 통해 비즈니스 기회를 창출한다'
);

-- 영업 - 서비스 지향
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '서비스 지향', '고객의 요구를 우선적으로 감안하고, 고객 만족을 위해서 최선을 다하는 자세. 고객 요청이 있는 경우, 적극적으로 경청하여 요구사항을 정확히 파악하여 직접적인 도움이 될 수 있는 양질의 서비스를 제공하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '서비스 지향'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 고객의 요구사항에 가장 효과적인 대응 방안을 수립한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '서비스 지향'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 고객의 요구사항에 가장 효과적인 대응 방안을 수립한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 고객에게 신속하고 정확한 서비스를 제공한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '서비스 지향'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 고객에게 신속하고 정확한 서비스를 제공한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 고객 불만을 사전에 예방하고 발생시 즉시 해결한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '서비스 지향'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 고객 불만을 사전에 예방하고 발생시 즉시 해결한다'
);

-- 영업 - 성과지향
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '성과지향', '목표한 성과를 달성하기 위해 지속적으로 노력하고 결과에 대한 책임을 지는 역량. 높은 목표를 설정하고 이를 달성하기 위한 전략과 실행력을 발휘하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '성과지향'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 명확하고 도전적인 목표를 설정한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '성과지향'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 명확하고 도전적인 목표를 설정한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 목표 달성을 위한 구체적인 실행 계획을 수립하고 추진한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '성과지향'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 목표 달성을 위한 구체적인 실행 계획을 수립하고 추진한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 성과 결과에 대해 책임감을 갖고 지속적으로 개선한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '성과지향'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 성과 결과에 대해 책임감을 갖고 지속적으로 개선한다'
);

-- 윤리 - 상황판단 및 대처능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '상황판단 및 대처능력', '다양한 상황에서 적절한 판단을 내리고 효과적으로 대처하는 역량. 예상치 못한 상황이나 위기 상황에서도 신속하고 정확한 판단으로 적절히 대응하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '상황판단 및 대처능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 상황의 긴급성과 중요성을 정확히 판단한다\n2. 제한된 정보 하에서도 합리적인 의사결정을 내린다\n3. 위기 상황에서 침착하게 대응방안을 수립하고 실행한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '상황판단 및 대처능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 상황의 긴급성과 중요성을 정확히 판단한다\n2. 제한된 정보 하에서도 합리적인 의사결정을 내린다\n3. 위기 상황에서 침착하게 대응방안을 수립하고 실행한다'
);

-- 인사 - 동시다중업무수행
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '동시다중업무수행', '다양한 업무를 동시에 수행하면서 업무의 진척도와 품질을 유지하는 역량. 여러 상황적 요인으로 인해 새로운 업무가 부과되더라도 기존 업무를 효과적으로 조정하여 새로운 업무를 동시에 처리하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '동시다중업무수행'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 업무 진행 과정에 대해 효율적으로 모니터링 하여 진척 상황 및 결과를 체크한다\n2. 아웃소싱이나 업무 협조를 효과적으로 활용하여 직접 업무수행을 최소화하고 이들을 효과적으로 관리 모니터링한다\n3. 업무의 우선순위 및 시간할당을 정확하게 관리한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '동시다중업무수행'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 업무 진행 과정에 대해 효율적으로 모니터링 하여 진척 상황 및 결과를 체크한다\n2. 아웃소싱이나 업무 협조를 효과적으로 활용하여 직접 업무수행을 최소화하고 이들을 효과적으로 관리 모니터링한다\n3. 업무의 우선순위 및 시간할당을 정확하게 관리한다'
);

-- 인사 - 변화관리/주도
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '변화관리/주도', '조직의 변화를 주도적으로 이끌어가고 구성원들이 변화에 적응할 수 있도록 지원하는 역량. 변화의 필요성을 인식하고 변화 추진 과정에서 발생하는 저항을 효과적으로 관리하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '변화관리/주도'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 조직 변화의 필요성을 명확히 인식하고 전파한다\n2. 변화 과정에서 구성원들의 저항을 이해하고 적절히 대응한다\n3. 변화 목표와 방향을 구체적으로 설정하고 실행한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '변화관리/주도'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 조직 변화의 필요성을 명확히 인식하고 전파한다\n2. 변화 과정에서 구성원들의 저항을 이해하고 적절히 대응한다\n3. 변화 목표와 방향을 구체적으로 설정하고 실행한다'
);

-- 인사 - 설득/영향력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '설득/영향력', '정보, 논리 등을 바탕으로 개인 및 집단을 설득해서 동의와 이해를 얻어내는 역량. 자기견해, 계획, 아이디어를 수용하도록 타인으로부터 필요한 지지와 지원을 끌어내고 태도나 의견을 유도하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '설득/영향력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 상대로 하여금 유익한 점을 보도록 유도함으로써 동의와 이해를 얻어낸다\n2. 자신이 주장하고자 하는 내용과 상대의 관심사를 정확히 이해한다\n3. 질문과 저항을 예상하고 준비한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '설득/영향력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 상대로 하여금 유익한 점을 보도록 유도함으로써 동의와 이해를 얻어낸다\n2. 자신이 주장하고자 하는 내용과 상대의 관심사를 정확히 이해한다\n3. 질문과 저항을 예상하고 준비한다'
);

-- 재경 - 분석적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '분석적 사고', '타당한 정보를 근거로 논리 정연하게 사고하여 정확하고 의미 있는 결론을 도출하는 역량. 정보를 체계적으로 분석하여 핵심 요소, 상호 연관성, 경향성을 파악해 상황판단, 문제해결, 의사결정 등에 활용하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '분석적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 재무 데이터를 체계적으로 분석하여 경영상 시사점을 도출한다\n2. 복잡한 재무 현상을 핵심 요소별로 분해하여 이해한다\n3. 과거 데이터의 경향성을 분석하여 미래 예측에 활용한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '분석적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 재무 데이터를 체계적으로 분석하여 경영상 시사점을 도출한다\n2. 복잡한 재무 현상을 핵심 요소별로 분해하여 이해한다\n3. 과거 데이터의 경향성을 분석하여 미래 예측에 활용한다'
);

-- 재경 - 손익마인드
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '손익마인드', '투입 대비 산출과 비용의 경제성을 기초로 손익을 관리하는 역량. 비용 대비 효과성이 뛰어난 상품이나 서비스의 개발, 손익 구조 개선 등 이윤 창출의 기회를 파악해 내는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '손익마인드'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 불확실한 상황에서 정확한 의사결정으로 이익을 창출한다\n2. 비용대비 효과성을 중요하게 여긴다\n3. 사업비 절감 및 손익구조 개선을 위한 방안을 수립한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '손익마인드'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 불확실한 상황에서 정확한 의사결정으로 이익을 창출한다\n2. 비용대비 효과성을 중요하게 여긴다\n3. 사업비 절감 및 손익구조 개선을 위한 방안을 수립한다'
);

-- 재무 - 재무시스템이해능력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '재무시스템이해능력', '조직의 재무시스템과 프로세스를 이해하고 효과적으로 활용하는 역량. 재무 데이터의 흐름과 구조를 파악하여 업무에 적용하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '재무시스템이해능력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 재무시스템의 구조와 기능을 정확히 이해한다\n2. 시스템을 활용하여 필요한 재무정보를 효율적으로 추출한다\n3. 시스템 개선사항을 발견하고 제안한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '재무시스템이해능력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 재무시스템의 구조와 기능을 정확히 이해한다\n2. 시스템을 활용하여 필요한 재무정보를 효율적으로 추출한다\n3. 시스템 개선사항을 발견하고 제안한다'
);

-- 재무 - 전문지식 보유 및 활용
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '전문지식 보유 및 활용', '해당 분야의 전문지식을 지속적으로 습득하고 실무에 적용하는 역량. 최신 동향과 기법을 파악하여 업무의 질을 향상시키는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '전문지식 보유 및 활용'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 전문분야의 최신 동향과 기법을 지속적으로 학습한다\n2. 전문지식을 실무에 적절히 적용한다\n3. 전문지식을 동료들과 공유하고 확산시킨다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '전문지식 보유 및 활용'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 전문분야의 최신 동향과 기법을 지속적으로 학습한다\n2. 전문지식을 실무에 적절히 적용한다\n3. 전문지식을 동료들과 공유하고 확산시킨다'
);

-- 정보기술 - 고객중심적 사고
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '고객중심적 사고', '고객의 비즈니스 니즈를 체계적으로 분석하여 체계적으로 이해하는 역량. 고객의 니즈에 맞춰 이를 충족시킬 수 있는 결정적 대안이나 융통성 있게 대응할 수 있는 전략을 설정하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '고객중심적 사고'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 모든 정보의 검토를 바탕으로 한 고객의 니즈를 밝혀내고 우선순위를 정한다\n2. 고객의 니즈를 원가절감 측면이나 효율성 측면에서 충족시켜 줄 수 있는 다양한 방법을 모색한다\n3. 내외부 고객만족 정도를 확인할 수 있는 지표들을 가지고 수시로 만족 여부를 점검한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '고객중심적 사고'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 모든 정보의 검토를 바탕으로 한 고객의 니즈를 밝혀내고 우선순위를 정한다\n2. 고객의 니즈를 원가절감 측면이나 효율성 측면에서 충족시켜 줄 수 있는 다양한 방법을 모색한다\n3. 내외부 고객만족 정도를 확인할 수 있는 지표들을 가지고 수시로 만족 여부를 점검한다'
);

-- 정보기술 - 프로세스 개선
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '프로세스 개선', '기존 업무 프로세스를 분석하여 비효율적인 요소를 발견하고 개선방안을 도출하는 역량. 시스템적 사고를 바탕으로 전체적인 업무 흐름을 최적화하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '프로세스 개선'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 현재 프로세스의 문제점을 체계적으로 분석한다\n2. 개선된 프로세스의 효과를 정량적으로 측정한다\n3. 이해관계자들과의 협의를 통해 개선방안을 실행한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '프로세스 개선'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 현재 프로세스의 문제점을 체계적으로 분석한다\n2. 개선된 프로세스의 효과를 정량적으로 측정한다\n3. 이해관계자들과의 협의를 통해 개선방안을 실행한다'
);

-- 총무 - 세밀/정확한 일처리
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '세밀/정확한 일처리', '세세하고 철저하게 개입하여 업무 및 그 결과물을 관리하여 품질수준을 확보하고 정확하게 업무를 처리하는 역량. 업무 목표를 염두에 두면서 세부사항을 정확하고 치밀하게 처리하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '세밀/정확한 일처리'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 각종 정보나 데이터의 정확성을 이중으로 확인한다\n2. 정확성과 관련된 세세한 내용을 매뉴얼화하여 활용한다\n3. 구성원들이 생소한 업무에 처했을 때 정확한 업무처리 프로세스를 찾아 해결할 수 있도록 지원한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '세밀/정확한 일처리'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 각종 정보나 데이터의 정확성을 이중으로 확인한다\n2. 정확성과 관련된 세세한 내용을 매뉴얼화하여 활용한다\n3. 구성원들이 생소한 업무에 처했을 때 정확한 업무처리 프로세스를 찾아 해결할 수 있도록 지원한다'
);

-- 총무 - 의사결정/판단력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '의사결정/판단력', '체계적 논리와 근거에 따라 요구에 맞는 타당한 결론을 내리는 역량. 객관적인 기준, 구체적인 사례, 잦은 의견 교환과 주의깊은 관찰을 통해 객관적 자료와 근거를 중심으로 의사결정을 하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '의사결정/판단력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 결정의 단기 및 장기적 효과를 모두 고려한다\n2. 다양한 이해관계자의 의견을 수렴하여 의사결정한다\n3. 객관적인 데이터와 사실에 근거하여 판단한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '의사결정/판단력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 결정의 단기 및 장기적 효과를 모두 고려한다\n2. 다양한 이해관계자의 의견을 수렴하여 의사결정한다\n3. 객관적인 데이터와 사실에 근거하여 판단한다'
);

-- 총무 - 주도성
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '주도성', '자발적으로 행동하고 기회를 만들어 새로운 일에 적극적으로 도전하는 역량. 현재 상황에 안주하지 않고 더 나은 결과를 위해 적극적으로 행동하고 변화를 추구하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '주도성'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 업무 개선을 위한 아이디어를 적극적으로 제안한다\n2. 새로운 업무나 프로젝트에 자발적으로 참여한다\n3. 문제 상황에서 해결책을 적극적으로 모색한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '주도성'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 업무 개선을 위한 아이디어를 적극적으로 제안한다\n2. 새로운 업무나 프로젝트에 자발적으로 참여한다\n3. 문제 상황에서 해결책을 적극적으로 모색한다'
);

-- 홍보 - 설득/영향력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '설득/영향력', '정보, 논리 등을 바탕으로 개인 및 집단을 설득해서 인정을 유도하는 역량. 자기견해, 계획, 아이디어를 수용하도록 타인으로부터 필요한 지지와 지원을 끌어내고 태도나 의견에 영향을 미치는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '설득/영향력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 필요하면 언제나 내외로 움직이면서 스스로의 영향력을 발휘하고 타인을 설득하거나 회유할 수 있다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '설득/영향력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 필요하면 언제나 내외로 움직이면서 스스로의 영향력을 발휘하고 타인을 설득하거나 회유할 수 있다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 자신이 주장하고자 하는 내용과 상대의 관심사를 정확히 이해한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '설득/영향력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 자신이 주장하고자 하는 내용과 상대의 관심사를 정확히 이해한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 상대로 하여금 유익한 점을 보도록 유도함으로써 동의와 이해를 얻어낸다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '설득/영향력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 상대로 하여금 유익한 점을 보도록 유도함으로써 동의와 이해를 얻어낸다'
);

-- 홍보 - 의사결정/판단력
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '의사결정/판단력', '체계적 논리와 근거에 따라 요구에 맞는 타당한 결론을 내리는 역량. 객관적인 기준, 구체적인 사례, 잦은 의견 교환과 주의깊은 관찰을 통해 객관적 자료와 근거를 중심으로 의사결정을 하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '의사결정/판단력'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 의사결정 전에 대안의 장점과 단점을 고려하여 판단의 초점을 명확히 한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '의사결정/판단력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 의사결정 전에 대안의 장점과 단점을 고려하여 판단의 초점을 명확히 한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 실현가능성과 가용성 등의 실제적인 측면에서 의사결정한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '의사결정/판단력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 실현가능성과 가용성 등의 실제적인 측면에서 의사결정한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 시의적절하고 정확한 결정을 내리고 행동방안을 제시한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '의사결정/판단력'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 시의적절하고 정확한 결정을 내리고 행동방안을 제시한다'
);

-- 홍보 - 전략적 사고/기획
INSERT INTO competencies (model_id, keyword, description) 
SELECT m.id, '전략적 사고/기획', '내/외부 요인을 장기적이고 포괄적으로 고려하여 문제해결과 의사결정을 하는 역량. 높은 성과를 낼 수 있는 전략을 확인하고 업무 활동 및 프로세스를 체계적으로 계획하고 조직화하여 실행하는 역량'
FROM competency_models m
WHERE m.name = '역량 평가표'
AND NOT EXISTS (
    SELECT 1 FROM competencies c
    WHERE c.model_id = m.id AND c.keyword = '전략적 사고/기획'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '1. 시장 및 경영 환경의 동향을 체계적으로 분석한 결과를 토대로 적합한 대응방안을 제시한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '전략적 사고/기획'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '1. 시장 및 경영 환경의 동향을 체계적으로 분석한 결과를 토대로 적합한 대응방안을 제시한다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '2. 핵심 비즈니스 이슈를 구체화하고 조직의 이익 창출을 위한 핵심 성공 요건을 밝힌다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '전략적 사고/기획'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '2. 핵심 비즈니스 이슈를 구체화하고 조직의 이익 창출을 위한 핵심 성공 요건을 밝힌다'
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, level) 
SELECT c.id, '3. 조직 전략 방향에 부합되도록 이해관계자간의 역학 관계를 바탕으로 업무를 조율·조정한다', 'general'
FROM competencies c
JOIN competency_models m ON c.model_id = m.id
WHERE m.name = '역량 평가표' AND c.keyword = '전략적 사고/기획'
AND NOT EXISTS (
    SELECT 1 FROM behavioral_indicators bi
    WHERE bi.competency_id = c.id AND bi.indicator_text = '3. 조직 전략 방향에 부합되도록 이해관계자간의 역학 관계를 바탕으로 업무를 조율·조정한다'
);

-- 홍보 - 창의적 사고
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

