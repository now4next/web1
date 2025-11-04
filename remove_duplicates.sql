-- 중복 역량 제거 스크립트
-- "경영지원 직무역량" 모델에서 중복된 역량을 삭제합니다
-- "역량 평가표" 모델의 역량이 더 상세한 정보를 가지고 있어 유지합니다

-- 1단계: 행동 지표 삭제 (외래 키 제약 조건 때문에 먼저 삭제)
DELETE FROM behavioral_indicators 
WHERE competency_id IN (
  SELECT c.id 
  FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- 2단계: 중복 역량 삭제
DELETE FROM competencies 
WHERE id IN (
  SELECT c.id 
  FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
);

-- 3단계: 검증 - 각 역량이 1개씩만 있는지 확인
SELECT keyword, COUNT(*) as count 
FROM competencies 
WHERE keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
GROUP BY keyword;

-- 예상 결과: 각 역량이 count = 1
