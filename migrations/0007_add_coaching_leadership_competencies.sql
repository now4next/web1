-- 코칭리더십 역량 모델 생성
INSERT INTO competency_models (name, type, description, target_level, created_at) 
VALUES ('코칭리더십', 'leadership', '상대방의 잠재력을 이끌어내고 성장을 지원하는 리더십 역량 모델', 'all', datetime('now'));

-- 마지막으로 삽입된 모델 ID 가져오기
-- SQLite에서는 변수를 사용할 수 없으므로, 서브쿼리로 처리

-- 1. 경청 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '코칭리더십'),
  '경청',
  '상대방의 말과 감정에 온전히 집중하여 이해하고, 판단이나 결론 없이 끝까지 주의 깊게 듣는 능력',
  '코칭리더십',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '경청' AND job_name = '코칭리더십'), '상대방이 대화 시 말하기와 듣기 중 듣는 비율이 높다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '경청' AND job_name = '코칭리더십'), '상대가 편안하게 대화 할 수 있도록 주의를 집중하여 관심 있게 들어준다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '경청' AND job_name = '코칭리더십'), '상대방의 이야기를 판단하려 하지 않으며 대화를 끝날 때 까지 결론을 내리지 않는다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '경청' AND job_name = '코칭리더십'), '상호간 이해를 돕기 위해 상대의 말을 확인한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '경청' AND job_name = '코칭리더십'), '상대방이 한 이야기를 요약해서 말해줌으로써 자신이 모든 것에 귀기울이고 있었다는 것을 확인시켜 준다.', datetime('now'));

-- 2. 공감 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '코칭리더십'),
  '공감',
  '타인의 감정과 상황을 이해하고 그들의 입장에서 느끼며, 언어적·비언어적 표현을 통해 정서적 연결을 형성하는 능력',
  '코칭리더십',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '공감' AND job_name = '코칭리더십'), '다른 사람들과 편안히 상호작용할 수 있으며 비 언어적인 표현을 통해 타인의 감정도 잘 감지한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '공감' AND job_name = '코칭리더십'), '나는 다른 사람들과 이야기 할 때 상대방의 감정을 이입할 수 있고 공감 할 수 있다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '공감' AND job_name = '코칭리더십'), '나는 모임에서 누가 어색해 하거나 불편해 하는지 잘 안다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '공감' AND job_name = '코칭리더십'), '대화 중 상대의 숨어 있는 감정과 욕구를 알아차린다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '공감' AND job_name = '코칭리더십'), '나는 TV에서 사람이나 동물들이 고통 받는 것을 보면 마음이 아프다.', datetime('now'));

-- 3. 신뢰형성 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '코칭리더십'),
  '신뢰형성',
  '진정성 있는 태도와 비밀보장을 통해 상대방이 편안하고 안전하게 소통할 수 있는 관계를 구축하는 능력',
  '코칭리더십',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '신뢰형성' AND job_name = '코칭리더십'), '대화를 처음 시작할 때 편안한 미소와 함께 인사하며 반갑게 맞이한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '신뢰형성' AND job_name = '코칭리더십'), '상대방이 나와 함께 하는 동안 편안해 한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '신뢰형성' AND job_name = '코칭리더십'), '상대방과의 대화내용을 비밀로 한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '신뢰형성' AND job_name = '코칭리더십'), '필요한 정보를 자유롭고 편안하게 말하도록 이끈다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '신뢰형성' AND job_name = '코칭리더십'), '대화 하는 동안 상대는 편안하고 안전하며 간혹 즐거워 한다.', datetime('now'));

-- 4. 격려/칭찬 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '코칭리더십'),
  '격려/칭찬',
  '타인의 긍정적 변화와 강점을 발견하여 적시에 인정하고 지지함으로써 동기를 부여하는 능력',
  '코칭리더십',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '격려/칭찬' AND job_name = '코칭리더십'), '타인의 작은 변화나 큰 변화를  알아차리고 표현한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '격려/칭찬' AND job_name = '코칭리더십'), '적절한 시기에 인정하고 칭찬한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '격려/칭찬' AND job_name = '코칭리더십'), '나와 대화를 하면 상대는 지지 받고 고무된다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '격려/칭찬' AND job_name = '코칭리더십'), '타인에 대해 부정적인 면 보다는 긍정적인 면을 본다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '격려/칭찬' AND job_name = '코칭리더십'), '상대가 실수 할 때도 격려하고 지지한다.', datetime('now'));

-- 5. 질문 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '코칭리더십'),
  '질문',
  '상대방의 잠재력과 통찰을 이끌어내기 위해 개방적이고 탐색적인 질문을 효과적으로 활용하는 능력',
  '코칭리더십',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '질문' AND job_name = '코칭리더십'), '상대방이 실천을 장려하는 질문을 한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '질문' AND job_name = '코칭리더십'), '상대방이 대화에 계속 참여할 수 있는 질문을 한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '질문' AND job_name = '코칭리더십'), '질문을 가지고 상대방을 자신의 의도로 몰아가지 않는다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '질문' AND job_name = '코칭리더십'), '상대방이 자신의 잠재력과 가능성을 탐색할 수 있는 질문을 한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '질문' AND job_name = '코칭리더십'), '상대방의 생각을 정리할 수 있는 질문을 한다.', datetime('now'));

-- 6. 부탁/요청 역량
INSERT INTO competencies (model_id, keyword, description, job_name, created_at) 
VALUES (
  (SELECT id FROM competency_models WHERE name = '코칭리더십'),
  '부탁/요청',
  '명확하고 적절한 방식으로 기대사항을 전달하고, 필요시 조언과 도움을 요청하는 의사소통 능력',
  '코칭리더십',
  datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, created_at) VALUES
  ((SELECT id FROM competencies WHERE keyword = '부탁/요청' AND job_name = '코칭리더십'), '복잡한 내용을 단순하고 명료하게 전달한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '부탁/요청' AND job_name = '코칭리더십'), '상대에게 바라는 것을 분명하게 이야기 한다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '부탁/요청' AND job_name = '코칭리더십'), '정당한 요구와 피드백을 적절한 타이밍에 해준다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '부탁/요청' AND job_name = '코칭리더십'), '상대방의 생각을 먼저 듣고 필요할 때 조언을 해준다.', datetime('now')),
  ((SELECT id FROM competencies WHERE keyword = '부탁/요청' AND job_name = '코칭리더십'), '필요한 경우 도움을 요청하거나 부탁을 잘 한다.', datetime('now'));
