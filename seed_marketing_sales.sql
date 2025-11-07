-- 마케팅 및 영업 직무역량 모델 추가

-- 역량 모델
INSERT OR IGNORE INTO competency_models (id, name, type, description, target_level) VALUES 
  (4, '마케팅 직무역량', 'functional', '마케팅 직군의 전문 역량 모델', 'all'),
  (5, '영업 직무역량', 'functional', '영업 직군의 전문 역량 모델', 'all');

-- 마케팅 역량 키워드
INSERT OR IGNORE INTO competencies (model_id, keyword, description, job_name) VALUES 
  -- 마케팅 역량
  (4, '시장조사 및 분석', '고객 니즈와 시장 트렌드를 파악하고 분석하는 능력', '마케팅'),
  (4, '브랜드 관리', '브랜드 아이덴티티를 구축하고 일관성 있게 관리하는 능력', '마케팅'),
  (4, '콘텐츠 기획', '타겟 고객에게 효과적인 콘텐츠를 기획하고 제작하는 능력', '마케팅'),
  (4, '디지털 마케팅', '온라인 채널을 활용한 마케팅 캠페인 기획 및 실행 능력', '마케팅'),
  (4, '캠페인 기획', '마케팅 목표 달성을 위한 통합 캠페인을 기획하는 능력', '마케팅'),
  (4, '성과 분석', '마케팅 성과를 측정하고 데이터 기반으로 개선하는 능력', '마케팅'),
  (4, '고객 인사이트', '고객 행동과 심리를 이해하고 인사이트를 도출하는 능력', '마케팅'),
  
  -- 영업 역량
  (5, '고객 관계 관리', '고객과 신뢰 관계를 구축하고 장기적으로 관리하는 능력', '영업'),
  (5, '제안 및 협상', '고객 니즈에 맞는 제안을 하고 효과적으로 협상하는 능력', '영업'),
  (5, '영업 전략 수립', '목표 달성을 위한 영업 전략과 계획을 수립하는 능력', '영업'),
  (5, '시장 개척', '신규 시장과 고객을 발굴하고 개척하는 능력', '영업'),
  (5, '영업 프로세스 관리', '영업 파이프라인을 효율적으로 관리하는 능력', '영업'),
  (5, '성과 지향', '목표를 설정하고 달성하기 위해 지속적으로 노력하는 능력', '영업'),
  (5, '설득 커뮤니케이션', '고객을 설득하고 의사결정을 이끌어내는 커뮤니케이션 능력', '영업');

-- 마케팅 행동 지표
INSERT OR IGNORE INTO behavioral_indicators (competency_id, indicator_text, level) VALUES 
  -- 시장조사 및 분석 (가정: competency_id는 자동 증가)
  ((SELECT id FROM competencies WHERE keyword = '시장조사 및 분석' LIMIT 1), '다양한 데이터 소스를 활용하여 시장 동향을 파악한다', 'intermediate'),
  ((SELECT id FROM competencies WHERE keyword = '시장조사 및 분석' LIMIT 1), '경쟁사 분석을 통해 전략적 인사이트를 도출한다', 'advanced'),
  
  -- 브랜드 관리
  ((SELECT id FROM competencies WHERE keyword = '브랜드 관리' LIMIT 1), '브랜드 가이드라인을 준수하여 일관된 메시지를 전달한다', 'intermediate'),
  ((SELECT id FROM competencies WHERE keyword = '브랜드 관리' LIMIT 1), '브랜드 가치를 높이는 전략적 활동을 기획한다', 'advanced'),
  
  -- 디지털 마케팅
  ((SELECT id FROM competencies WHERE keyword = '디지털 마케팅' LIMIT 1), 'SNS, 검색광고 등 디지털 채널을 효과적으로 활용한다', 'intermediate'),
  ((SELECT id FROM competencies WHERE keyword = '디지털 마케팅' LIMIT 1), '데이터 분석을 통해 디지털 캠페인을 최적화한다', 'advanced');

-- 영업 행동 지표
INSERT OR IGNORE INTO behavioral_indicators (competency_id, indicator_text, level) VALUES 
  -- 고객 관계 관리
  ((SELECT id FROM competencies WHERE keyword = '고객 관계 관리' LIMIT 1), '고객의 니즈를 정확히 파악하고 맞춤형 솔루션을 제공한다', 'intermediate'),
  ((SELECT id FROM competencies WHERE keyword = '고객 관계 관리' LIMIT 1), '장기적 관점에서 고객 가치를 극대화하는 관계를 구축한다', 'advanced'),
  
  -- 제안 및 협상
  ((SELECT id FROM competencies WHERE keyword = '제안 및 협상' LIMIT 1), '고객 상황에 맞는 설득력 있는 제안을 작성한다', 'intermediate'),
  ((SELECT id FROM competencies WHERE keyword = '제안 및 협상' LIMIT 1), 'Win-Win 협상을 통해 거래를 성사시킨다', 'advanced'),
  
  -- 시장 개척
  ((SELECT id FROM competencies WHERE keyword = '시장 개척' LIMIT 1), '신규 고객을 발굴하고 효과적으로 접근한다', 'intermediate'),
  ((SELECT id FROM competencies WHERE keyword = '시장 개척' LIMIT 1), '새로운 시장 기회를 포착하고 전략적으로 진입한다', 'advanced');
