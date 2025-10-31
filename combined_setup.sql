-- 역량 모델 (Competency Models)
CREATE TABLE IF NOT EXISTS competency_models (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('common', 'leadership', 'functional')),
  description TEXT,
  target_level TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 역량 키워드 (Competency Keywords)
CREATE TABLE IF NOT EXISTS competencies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  model_id INTEGER NOT NULL,
  keyword TEXT NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (model_id) REFERENCES competency_models(id) ON DELETE CASCADE
);

-- 행동 지표 (Behavioral Indicators)
CREATE TABLE IF NOT EXISTS behavioral_indicators (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  competency_id INTEGER NOT NULL,
  indicator_text TEXT NOT NULL,
  level TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (competency_id) REFERENCES competencies(id) ON DELETE CASCADE
);

-- 진단 문항 (Assessment Questions)
CREATE TABLE IF NOT EXISTS assessment_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  competency_id INTEGER NOT NULL,
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL CHECK(question_type IN ('self', 'multi', 'survey')),
  scale_type TEXT DEFAULT 'likert_5',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (competency_id) REFERENCES competencies(id) ON DELETE CASCADE
);

-- 진단 세션 (Assessment Sessions)
CREATE TABLE IF NOT EXISTS assessment_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_name TEXT NOT NULL,
  session_type TEXT NOT NULL CHECK(session_type IN ('self', 'multi', 'survey')),
  target_level TEXT,
  status TEXT DEFAULT 'draft' CHECK(status IN ('draft', 'active', 'completed', 'archived')),
  start_date DATETIME,
  end_date DATETIME,
  analysis_date DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 진단 세션 - 역량 매핑
CREATE TABLE IF NOT EXISTS session_competencies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  competency_id INTEGER NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE,
  FOREIGN KEY (competency_id) REFERENCES competencies(id) ON DELETE CASCADE
);

-- 응답자 (Respondents)
CREATE TABLE IF NOT EXISTS respondents (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  department TEXT,
  position TEXT,
  level TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 진단 응답 (Assessment Responses)
CREATE TABLE IF NOT EXISTS assessment_responses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  respondent_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  response_value INTEGER NOT NULL,
  response_text TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE,
  FOREIGN KEY (respondent_id) REFERENCES respondents(id) ON DELETE CASCADE,
  FOREIGN KEY (question_id) REFERENCES assessment_questions(id) ON DELETE CASCADE
);

-- 분석 결과 (Analysis Results)
CREATE TABLE IF NOT EXISTS analysis_results (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  respondent_id INTEGER NOT NULL,
  competency_id INTEGER NOT NULL,
  avg_score REAL,
  percentile REAL,
  strength_level TEXT,
  ai_insight TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE,
  FOREIGN KEY (respondent_id) REFERENCES respondents(id) ON DELETE CASCADE,
  FOREIGN KEY (competency_id) REFERENCES competencies(id) ON DELETE CASCADE
);

-- AI 코칭 세션 (AI Coaching Sessions)
CREATE TABLE IF NOT EXISTS coaching_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  respondent_id INTEGER NOT NULL,
  analysis_result_id INTEGER,
  session_data TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (respondent_id) REFERENCES respondents(id) ON DELETE CASCADE,
  FOREIGN KEY (analysis_result_id) REFERENCES analysis_results(id) ON DELETE SET NULL
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_competencies_model_id ON competencies(model_id);
CREATE INDEX IF NOT EXISTS idx_behavioral_indicators_competency_id ON behavioral_indicators(competency_id);
CREATE INDEX IF NOT EXISTS idx_assessment_questions_competency_id ON assessment_questions(competency_id);
CREATE INDEX IF NOT EXISTS idx_session_competencies_session_id ON session_competencies(session_id);
CREATE INDEX IF NOT EXISTS idx_assessment_responses_session_id ON assessment_responses(session_id);
CREATE INDEX IF NOT EXISTS idx_assessment_responses_respondent_id ON assessment_responses(respondent_id);
CREATE INDEX IF NOT EXISTS idx_analysis_results_session_id ON analysis_results(session_id);
CREATE INDEX IF NOT EXISTS idx_analysis_results_respondent_id ON analysis_results(respondent_id);
CREATE INDEX IF NOT EXISTS idx_respondents_email ON respondents(email);


-- ============================================
-- SEED DATA
-- ============================================

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
