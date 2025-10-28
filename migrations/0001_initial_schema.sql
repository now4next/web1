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
