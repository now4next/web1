-- 샘플 역량 모델
INSERT OR IGNORE INTO competency_models (id, name, type, description, target_level) VALUES 
  (1, '공통 역량', 'common', '전 직원 대상 공통 역량', 'all'),
  (2, '리더십 역량', 'leadership', '관리자 이상 리더십 역량', 'manager+'),
  (3, '전략기획 직무역량', 'functional', '전략기획 직무 전문역량', 'specialist');

-- 샘플 역량 키워드
INSERT OR IGNORE INTO competencies (id, model_id, keyword, description) VALUES 
  -- 공통 역량
  (1, 1, '커뮤니케이션', '효과적인 의사소통 능력'),
  (2, 1, '문제해결', '논리적 문제 분석 및 해결 능력'),
  (3, 1, '협업', '팀워크 및 협력 능력'),
  (4, 1, '학습민첩성', '빠른 학습 및 적응 능력'),
  -- 리더십 역량
  (5, 2, '전략적사고', '장기적 비전 및 전략 수립 능력'),
  (6, 2, '변화관리', '조직 변화 주도 및 관리 능력'),
  (7, 2, '코칭', '구성원 육성 및 피드백 제공 능력'),
  (8, 2, '의사결정', '신속하고 합리적인 의사결정 능력'),
  -- 전략기획 직무역량
  (9, 3, '데이터분석', '데이터 기반 인사이트 도출 능력'),
  (10, 3, '사업기획', '사업 모델 설계 및 기획 능력'),
  (11, 3, '시장분석', '시장 동향 파악 및 분석 능력');

-- 샘플 행동 지표
INSERT OR IGNORE INTO behavioral_indicators (competency_id, indicator_text, level) VALUES 
  (1, '다양한 이해관계자와 명확하게 의사소통한다', 'intermediate'),
  (1, '복잡한 내용을 간결하게 전달한다', 'advanced'),
  (2, '문제의 근본 원인을 파악한다', 'intermediate'),
  (2, '창의적인 해결책을 제시한다', 'advanced'),
  (5, '시장 트렌드를 분석하여 전략에 반영한다', 'advanced'),
  (5, '조직의 장기 비전을 수립한다', 'expert');

-- 샘플 진단 문항
INSERT OR IGNORE INTO assessment_questions (competency_id, question_text, question_type) VALUES 
  (1, '나는 이해관계자들과 효과적으로 소통한다', 'self'),
  (1, '나는 복잡한 개념을 쉽게 설명할 수 있다', 'self'),
  (2, '나는 문제 발생 시 체계적으로 분석한다', 'self'),
  (2, '나는 창의적인 해결 방안을 찾아낸다', 'self'),
  (5, '나는 장기적 관점에서 전략을 수립한다', 'self'),
  (5, '나는 시장 변화를 전략에 반영한다', 'self');

-- 샘플 응답자
INSERT OR IGNORE INTO respondents (id, name, email, department, position, level) VALUES 
  (1, '김철수', 'kim@example.com', '전략기획팀', '팀장', 'manager'),
  (2, '이영희', 'lee@example.com', '마케팅팀', '과장', 'senior'),
  (3, '박민수', 'park@example.com', 'IT팀', '대리', 'intermediate');
