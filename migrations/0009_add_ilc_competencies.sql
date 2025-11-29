-- 공통ILC 역량 모델 생성
INSERT INTO competency_models (name, type, description, target_level, created_at) 
VALUES ('공통ILC', 'common', 'ILC 공통 역량 모델 - 조직 구성원 모두에게 필요한 핵심 역량', 'all', datetime('now'));

-- 리더십ILC 역량 모델 생성
INSERT INTO competency_models (name, type, description, target_level, created_at) 
VALUES ('리더십ILC', 'leadership', 'ILC 리더십 역량 모델 - 리더에게 필요한 핵심 역량', 'manager', datetime('now'));


-- 공통ILC - 상호존중 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '상호존중',
  '구성원 개개인의 다양한 의견과 스타일을 인정하고, 전문성을 배려와 존중의 자세로 발휘하여 조화로운 관계를 형성하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '상호존중' AND job_name = '공통ILC'), '자신의 생각이나 스타일을 강요하지 않고 구성원들의 다양한 의견을 존중한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '상호존중' AND job_name = '공통ILC'), '자신의 전문성을 다른 사람을 존중하고 배려하는 차원에서 도움이 되도록 발휘한다.', datetime('now'));

-- 공통ILC - 원활한 의사소통 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '원활한 의사소통',
  '개방적이고 건설적인 분위기를 조성하여 솔직하고 효과적으로 의견을 주고받으며, 명확한 의사소통을 실현하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '원활한 의사소통' AND job_name = '공통ILC'), '적극적이고 솔직하게 의견을 낼 수 있는 건설적이고 개방적인 분위기를 조성한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '원활한 의사소통' AND job_name = '공통ILC'), '솔직하고 간결하게 구성원들과 효과적으로 의사소통을 하는 편이다.', datetime('now'));

-- 리더십ILC - 동기부여 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '동기부여',
  '구성원에게 성장 기회를 제공하고 긍정적 피드백을 통해 자발적 참여와 열정을 고취시키는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '동기부여' AND job_name = '리더십ILC'), '구성원들이 실질적으로 성장할 수 있는 구체적인 과제와 기회를 부여한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '동기부여' AND job_name = '리더십ILC'), '칭찬하고 격려하는 분위기를 조성한다.', datetime('now'));

-- 리더십ILC - 코칭 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '코칭',
  '정기적인 면담과 피드백을 통해 구성원의 성과와 역량을 향상시키고, 질문과 지도로 성장을 촉진하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '코칭' AND job_name = '리더십ILC'), '공정한 평가와 보상을 위해 정기적인 성과 코칭을 실시한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '코칭' AND job_name = '리더십ILC'), '적절한 질문과 경청, 피드백을 통해 구성원이 자신의 성장과 개발을 위한 생각과 의견을 잘 개진할 수 있도록 코칭한다.', datetime('now'));

-- 공통ILC - 고객관점사고 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '고객관점사고',
  '업무 결과가 내외부 고객에게 미치는 영향을 인식하고, 고객 입장에서 효과적으로 대응하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '고객관점사고' AND job_name = '공통ILC'), '업무처리 결과가 내.외부 고객에게 미치는 영향을 명확하게 인식하고 있다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '고객관점사고' AND job_name = '공통ILC'), '고객의 입장에서 생각하여 적절히 대응한 결과 고객의 만족스러운 피드백을 들은 경험이 있다.', datetime('now'));

-- 공통ILC - 고객마인드고취 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '고객마인드고취',
  '고객 만족을 최우선으로 하고, 약속을 신속정확하게 이행하여 고객 신뢰를 구축하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '고객마인드고취' AND job_name = '공통ILC'), '업무처리 과정에 있어 내외부 고객 만족을 최우선으로 한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '고객마인드고취' AND job_name = '공통ILC'), '고객과의 약속을 최우선으로 하여 신속하고 정확하게 고객에게 대응한다.', datetime('now'));

-- 공통ILC - 도전과 집념 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '도전과 집념',
  '최고 수준에 도달하기 위해 끊임없이 도전하고, 원하는 결과를 위해 집념을 가지고 추구하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '도전과 집념' AND job_name = '공통ILC'), '최고의 수준에 이르기 위해 끊임없이 도전한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '도전과 집념' AND job_name = '공통ILC'), '한번 도전한 일은 원하는 결과를 얻기 위해 집념을 가지고 마음과 생각을 쏟는다.', datetime('now'));

-- 공통ILC - 업무열정 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '업무열정',
  '프로의식과 책임감을 가지고 업무에 몰입하며, 높은 열정으로 직무를 수행하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '업무열정' AND job_name = '공통ILC'), '프로의식과 책임감을 가지고 적극적으로 업무를 수행한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '업무열정' AND job_name = '공통ILC'), '내가 하는 일에 대한 애정을 가지고 열중하고 몰입한다.', datetime('now'));

-- 공통ILC - 계획수립 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '계획수립',
  '발생 가능한 문제와 향후 상황을 예측하여 실행 가능한 계획을 수립하고, 균형 있게 사고하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '계획수립' AND job_name = '공통ILC'), '발생 가능한 문제점 및 향후의 상황을 예측하여 실행 가능한 계획을 수립한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '계획수립' AND job_name = '공통ILC'), '최적의 상태에서 행동하기 위해 균형 있게 생각한다.', datetime('now'));

-- 공통ILC - 실행행동력 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '실행행동력',
  '결정된 사항을 즉각 실행하고, 우선순위를 판단하여 신속정확하게 업무를 완수하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '실행행동력' AND job_name = '공통ILC'), '결정된 사항에 대해서는 확신을 가지며 즉각적으로 실행에 옮긴다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '실행행동력' AND job_name = '공통ILC'), '업무를 수행함에 있어서 실행의 우선순위를 경험의 직관과 분석적인 판단으로 정할 수 있고, 우선순위에 따라 신속하고 정확하게 실행할 수 있다.', datetime('now'));

-- 공통ILC - 문제분석력 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '문제분석력',
  '상황의 논리적 관계와 인과관계를 파악하고, 체계적 기법으로 문제를 분석하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '문제분석력' AND job_name = '공통ILC'), '상황 및 현상에 대한 논리적인 이해와 인과관계를 파악하여 설명할 수 있다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '문제분석력' AND job_name = '공통ILC'), '문제분석기법을 활용하여 체계적으로 문제를 분석할 수 있다.', datetime('now'));

-- 공통ILC - 문제해결력 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '문제해결력',
  '문제의 상호 연관성과 핵심 원인을 파악하여 효과적인 해결 대안을 도출하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '문제해결력' AND job_name = '공통ILC'), '문제의 상호 연관성과 인과관계를 잘 파악하여 효과적인 해결 대안을 마련할 수 있다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '문제해결력' AND job_name = '공통ILC'), '문제 상황 발생 시 가장 핵심적인 원인 및 해결방법을 경험적 직관과 분석적 판단에 의해 찾을 수 있다.', datetime('now'));

-- 리더십ILC - 전문지식/기술 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '전문지식/기술',
  '직무의 핵심 전문지식과 기술을 보유하고, 지속적으로 새로운 지식을 습득하여 활용하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '전문지식/기술' AND job_name = '리더십ILC'), '현재 자신의 업무에 가장 핵심적인 전문 지식과 기술을 보유하고 있다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '전문지식/기술' AND job_name = '리더십ILC'), '자신의 업무 전문 영역에 해당되는 새로운 지식과 기술을 지속적으로 습득하고 활용한다.', datetime('now'));

-- 리더십ILC - 폭넓은 직무경험 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '폭넓은 직무경험',
  '다양한 과제에서 전문가로서 성과를 창출하고, 시행착오를 통해 효과적인 방법을 체득한 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '폭넓은 직무경험' AND job_name = '리더십ILC'), '자신의 업무 영역에서 다양한 과제에 대한 전문가로써의 성과 창출 경험이 있다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '폭넓은 직무경험' AND job_name = '리더십ILC'), '자신의 업무 전문 영역에서 다양한 시행착오를 통한 효과적이고 효율적인 결과 창출 방법을 알고 있다.', datetime('now'));

-- 공통ILC - 종합적 사고력 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '종합적 사고력',
  '지식과 통찰을 활용하여 미경험 상황에서도 해결책을 도출하고, 새로운 지식을 종합적으로 판단하여 활용하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '종합적 사고력' AND job_name = '공통ILC'), '지식, 기술, 통찰을 활용하여 경험하지 않은 상황에서도 해결책을 도출할 수 있다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '종합적 사고력' AND job_name = '공통ILC'), '새로운 지식, 기술, 노하우 등을 기존 것들과의 차이와 장점 및 약점을 종합적으로 판단하여 활용할 수 있다.', datetime('now'));

-- 공통ILC - 습득/활용 능력 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '습득/활용 능력',
  '새로운 지식과 기술을 지속적으로 습득하고, 다양한 경험을 업무에 적극 활용하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '습득/활용 능력' AND job_name = '공통ILC'), '새로운 지식, 기술, 노하우 등을 지속적으로 습득하고 업무에 활용한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '습득/활용 능력' AND job_name = '공통ILC'), '다양한 분야의 지식과 경험 및 통찰을 지속적으로 학습하고 업무에 활용할 수 있는지를 지속적으로 생각하고 시도해본다.', datetime('now'));

-- 리더십ILC - 전략설정 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '전략설정',
  '조직의 강점을 향상시키고 미흡한 점을 개선하는 방향을 제시하며, 비전과 연계된 전략을 설정하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '전략설정' AND job_name = '리더십ILC'), '조직의 강점은 보다 안정적으로 향상시키고, 미흡한 점은 강점으로 만들 수 있는 방향을 제시한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '전략설정' AND job_name = '리더십ILC'), '회사의 비전과 연계된 목표 달성을 위해 다양한 제약조건을 감안하여 전략을 설정할 수 있다.', datetime('now'));

-- 리더십ILC - 전략실행 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '전략실행',
  '전략 달성을 위한 구체적 과제와 실천계획을 수립하고, 현실적이면서 이상적으로 실행하여 성과를 창출하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '전략실행' AND job_name = '리더십ILC'), '조직의 전략 달성을 위한 구체적인 과제 및 실천계획을 수립한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '전략실행' AND job_name = '리더십ILC'), '조직의 비전과 연계된 전략의 실행에 있어서 가장 현실적이면서 이상적인 실행을 통해 긍정적인 결과를 얻어낸 경험이 있다.', datetime('now'));

-- 리더십ILC - 프로세스 개선 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '프로세스 개선',
  '기존 프로세스의 문제를 인식하고, 효과적이고 효율적인 개선을 위해 지속적으로 노력하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '프로세스 개선' AND job_name = '리더십ILC'), '기존의 작업 프로세스에 대한 문제의식을 갖고 지속적으로 개선한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '프로세스 개선' AND job_name = '리더십ILC'), '효과적이고 효율적인 프로세스 개선을 위해 지속적으로 노력한다.', datetime('now'));

-- 공통ILC - 적극적 협업 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '적극적 협업',
  '개인/부서 이기주의를 지양하고, 전사 목표를 위해 적극적인 협력 방안을 모색하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '적극적 협업' AND job_name = '공통ILC'), '개인/부서 이기주의를 지양하고 전사 공동의 목표를 위해 적극적인 상호 협력 방안을 모색한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '적극적 협업' AND job_name = '공통ILC'), '조직의 중요한 프로젝트 진행 시 명확한 책임자 선정과 유관부서를 참여시키고 공동의 성과에 대한 보상과 잘못된 결과에 대한 처벌 규정이 명확하다.', datetime('now'));

-- 리더십ILC - 합리적 결정 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '합리적 결정',
  '윤리규범에 따라 판단하고, 다양한 이해관계자의 의견을 균형 있게 반영하여 합리적으로 의사결정하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '합리적 결정' AND job_name = '리더십ILC'), '불편함이 있더라도 우회하지 않고 회사의 윤리규범에 따라 판단하고 행동한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '합리적 결정' AND job_name = '리더십ILC'), '다양한 이해관계집단의 의견을 청취하여 균형 있게 판단하고 행동한다.', datetime('now'));

-- 리더십ILC - 신속한 조치 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '신속한 조치',
  '모호한 상황에서도 신속하게 의사결정하고, 현실적 제약을 고려하여 효율적으로 행동하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '신속한 조치' AND job_name = '리더십ILC'), '어렵고 모호한 상황에서도 신속한 의사결정을 내린다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '신속한 조치' AND job_name = '리더십ILC'), '주어진 상황에서 현실적 제약 요소를 종합적으로 검토하여 가장 효율적인 행동을 취한다.', datetime('now'));

-- 공통ILC - 창의적 사고 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '창의적 사고',
  '기존 틀을 뛰어넘는 독창적이고 실현 가능한 방안을 제시하고, 문제를 심층 분석하여 대안적 접근법을 모색하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '창의적 사고' AND job_name = '공통ILC'), '기존의 틀을 뛰어넘는 독창적이면서도 실현 가능한 방안을 제시한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '창의적 사고' AND job_name = '공통ILC'), '기존 방식의 문제점과 한계를 인식하고, 그 사실과 원인에 대해서 심층적으로 분석하고 파고들어, 다른 접근의 가능성을 파악한다.', datetime('now'));

-- 공통ILC - 혁신/개선 의지 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '혁신/개선 의지',
  '독창적 아이디어를 끈질기게 시도하고, 혁신적 방식으로 기존 방법으로 해결 어려운 문제를 해결하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '혁신/개선 의지' AND job_name = '공통ILC'), '기존의 것이 있기는 하지만 차별적인 독창적 아이디어를 제안하고, 이것을 검증하기 위해 끈질기게 시도한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '혁신/개선 의지' AND job_name = '공통ILC'), '독창적이고, 혁신적인 방식을 제안해 기존 방식으로 해결하기 어렵거나, 상상할 수 없었던 문제를 해결한다.', datetime('now'));

-- 리더십ILC - 비전공유 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '비전공유',
  '회사 비전이 개인 수준까지 실천되도록 격려하고, 정기적으로 업무 현황과 방향을 구성원과 공유하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '비전공유' AND job_name = '리더십ILC'), '회사의 비전이 조직의 목표뿐만 아니라 개인적 수준에서도 실천되도록 격려한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '비전공유' AND job_name = '리더십ILC'), '정기적으로 구성원들과 부서의 업무 현황 및 진행 방향에 대한 정보를 공유한다.', datetime('now'));

-- 리더십ILC - 변화촉진 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '변화촉진',
  '단기 성과에 매몰되지 않고 중장기 변화를 일관되게 추진하며, 확고한 의지로 관행을 혁신하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '변화촉진' AND job_name = '리더십ILC'), '단기 성과에만 매몰되지 않고 중장기 관점의 변화 활동을 일관되게 추진한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '변화촉진' AND job_name = '리더십ILC'), '오랜 기간의 관행이나 문화를, 혁신에 대한 확고한 비전과 강한 의지를 가지고 다양한 시도 및 노력을 통해 변화를 추진한다.', datetime('now'));

-- 공통ILC - 상호협력 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '상호협력',
  '관련 부서와 업무를 적극 조율하여 갈등을 예방하고, 동료를 신뢰하고 인정하여 협력적 팀워크를 형성하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '상호협력' AND job_name = '공통ILC'), '관련 부서와 업무를 적극적으로 조율하여 갈등 요인을 사전에 예방한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '상호협력' AND job_name = '공통ILC'), '조직의 일원으로서 동료들(구성원들)을 신뢰하고 인정하여 협력적인 팀웍을 만들어 낸다.', datetime('now'));

-- 리더십ILC - 팀워크 형성 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '팀워크 형성',
  '이해관계자와 유대관계를 구축하고, 동료의 의견과 조언을 적극 구하여 업무에 반영하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '팀워크 형성' AND job_name = '리더십ILC'), '관련 조직의 이해관계자와 적절한 교류를 통해 유대관계를 구축한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '팀워크 형성' AND job_name = '리더십ILC'), '동료들(구성원들)의 의견/조언/도움을 적극적으로 구하고, 이를 업무에 반영하거나, 동료들로부터 진심으로 배우고자 하는 의사를 표현한다.', datetime('now'));

-- 공통ILC - 책임감 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '책임감',
  '자신의 결정과 결과에 대한 책임을 전가하지 않고, 언행의 일관성을 유지하는 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '책임감' AND job_name = '공통ILC'), '자신이 내린 결정과 그에 따른 결과에 대한 책임을 구성원들에게 전가하지 않는다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '책임감' AND job_name = '공통ILC'), '자신의 결정과 언급한 내용에 대해 일관성을 지키는 편이다.', datetime('now'));

-- 리더십ILC - 솔선수범 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '솔선수범',
  '먼저 실천하여 본보기를 보이고, 행동기준을 준수하며 일관성과 책임감으로 어려운 상황을 해결하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '솔선수범' AND job_name = '리더십ILC'), '자신이 먼저 실천하여 부하직원에게 본보기를 보인다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '솔선수범' AND job_name = '리더십ILC'), '회사의 방침이나 행동기준을 잘 따르는 본보기를 보이고, 일관성과 책임감을 가지고 적극적으로 어려운 상황을 해결해 나간다.', datetime('now'));

-- 공통ILC - 정직/윤리의식 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '공통ILC'),
  '정직/윤리의식',
  '공정한 가치와 신념을 바탕으로 업무를 수행하고, 법규와 윤리를 준수하는 건전한 기업관을 가진 능력',
  '공통ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '정직/윤리의식' AND job_name = '공통ILC'), '올바르거나 사회적으로 공정한 가치와 신념에 근거를 두고 일을 하고 있다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '정직/윤리의식' AND job_name = '공통ILC'), '올바른 가치와 신념을 바탕으로 법과 윤리를 준수하고 건전한 기업관을 갖고 현재의 조직에서 일하고 있다.', datetime('now'));

-- 리더십ILC - 글로벌관점 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '리더십ILC'),
  '글로벌관점',
  '글로벌 역량 확보를 위해 지속 노력하고, 다양한 문화를 이해하며 이문화 환경에 유연하게 적응하는 능력',
  '리더십ILC',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '글로벌관점' AND job_name = '리더십ILC'), '조직의 영속적인 성장을 위하고, 세계화에 발맞춘 경쟁력을 확보하기 위해 글로벌 역량을 갖추기 위한 노력을 지속한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '글로벌관점' AND job_name = '리더십ILC'), '글로벌 비즈니스 환경에 유연하게 대응하기 위해 다양한 문화의 특성과 차이점을 이해하고 수용하며 이문화 환경에 잘 적용할 수 있도록 준비되어 있다.', datetime('now'));