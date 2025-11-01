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

-- 정보기술(IT) - 시스템 운영능력
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

-- 인사(HR) - 성과보상관리능력
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

-- 법무/컴플라이언스 - 소송관리능력
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

