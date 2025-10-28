-- Create test assessment session
INSERT INTO assessment_sessions (session_name, session_type, target_level, status, start_date)
VALUES ('2025 리더십 역량 진단', 'self', 'manager', 'active', datetime('now'));

-- Insert test assessment responses for respondent 1 (김철수)
-- Using session_id = 1 (the session we just created)

-- Competency: 전략적 사고 (평균: 4.2)
INSERT INTO assessment_responses (session_id, respondent_id, question_id, response_value) VALUES
(1, 1, 1, 5),  -- 전략적 사고 Q1
(1, 1, 2, 4),  -- 전략적 사고 Q2
(1, 1, 3, 4),  -- 전략적 사고 Q3
(1, 1, 4, 4),  -- 전략적 사고 Q4
(1, 1, 5, 4);  -- 전략적 사고 Q5

-- Competency: 리더십 (평균: 3.8)
INSERT INTO assessment_responses (session_id, respondent_id, question_id, response_value) VALUES
(1, 1, 6, 4),  -- 리더십 Q1
(1, 1, 7, 4),  -- 리더십 Q2
(1, 1, 8, 4),  -- 리더십 Q3
(1, 1, 9, 3),  -- 리더십 Q4
(1, 1, 10, 4); -- 리더십 Q5

-- Competency: 커뮤니케이션 (평균: 4.4 - 강점)
INSERT INTO assessment_responses (session_id, respondent_id, question_id, response_value) VALUES
(1, 1, 11, 5),  -- 커뮤니케이션 Q1
(1, 1, 12, 4),  -- 커뮤니케이션 Q2
(1, 1, 13, 5),  -- 커뮤니케이션 Q3
(1, 1, 14, 4),  -- 커뮤니케이션 Q4
(1, 1, 15, 4);  -- 커뮤니케이션 Q5

-- Competency: 문제 해결 (평균: 3.4 - 개선 영역)
INSERT INTO assessment_responses (session_id, respondent_id, question_id, response_value) VALUES
(1, 1, 16, 3),  -- 문제 해결 Q1
(1, 1, 17, 3),  -- 문제 해결 Q2
(1, 1, 18, 4),  -- 문제 해결 Q3
(1, 1, 19, 3),  -- 문제 해결 Q4
(1, 1, 20, 4);  -- 문제 해결 Q5

-- Competency: 혁신과 창의성 (평균: 3.6)
INSERT INTO assessment_responses (session_id, respondent_id, question_id, response_value) VALUES
(1, 1, 21, 4),  -- 혁신과 창의성 Q1
(1, 1, 22, 3),  -- 혁신과 창의성 Q2
(1, 1, 23, 4),  -- 혁신과 창의성 Q3
(1, 1, 24, 3),  -- 혁신과 창의성 Q4
(1, 1, 25, 4);  -- 혁신과 창의성 Q5

-- Competency: 변화 관리 (평균: 3.2 - 개선 영역)
INSERT INTO assessment_responses (session_id, respondent_id, question_id, response_value) VALUES
(1, 1, 26, 3),  -- 변화 관리 Q1
(1, 1, 27, 3),  -- 변화 관리 Q2
(1, 1, 28, 3),  -- 변화 관리 Q3
(1, 1, 29, 4),  -- 변화 관리 Q4
(1, 1, 30, 3);  -- 변화 관리 Q5

-- Insert one more response to complete 31 questions
INSERT INTO assessment_responses (session_id, respondent_id, question_id, response_value) VALUES
(1, 1, 31, 4);  -- 추가 질문
