-- Assessment Sessions Table
CREATE TABLE IF NOT EXISTS assessment_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_name TEXT NOT NULL,
  session_type TEXT DEFAULT 'self',
  target_level TEXT,
  status TEXT DEFAULT 'draft',
  start_date TEXT DEFAULT (datetime('now')),
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

-- Respondents Table
CREATE TABLE IF NOT EXISTS respondents (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  department TEXT,
  position TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

-- Assessment Questions Table
CREATE TABLE IF NOT EXISTS assessment_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  competency_id INTEGER NOT NULL,
  question_text TEXT NOT NULL,
  question_type TEXT DEFAULT 'self',
  scale_type TEXT DEFAULT 'likert_5',
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (competency_id) REFERENCES competencies(id)
);

-- Assessment Responses Table
CREATE TABLE IF NOT EXISTS assessment_responses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  respondent_id INTEGER,
  question_id INTEGER NOT NULL,
  response_value INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id),
  FOREIGN KEY (respondent_id) REFERENCES respondents(id),
  FOREIGN KEY (question_id) REFERENCES assessment_questions(id)
);

-- Session-Competencies Mapping Table (optional, for tracking which competencies are in a session)
CREATE TABLE IF NOT EXISTS session_competencies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  competency_id INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id),
  FOREIGN KEY (competency_id) REFERENCES competencies(id),
  UNIQUE(session_id, competency_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_assessment_responses_session ON assessment_responses(session_id);
CREATE INDEX IF NOT EXISTS idx_assessment_responses_respondent ON assessment_responses(respondent_id);
CREATE INDEX IF NOT EXISTS idx_assessment_responses_question ON assessment_responses(question_id);
CREATE INDEX IF NOT EXISTS idx_assessment_questions_competency ON assessment_questions(competency_id);
CREATE INDEX IF NOT EXISTS idx_session_competencies_session ON session_competencies(session_id);
CREATE INDEX IF NOT EXISTS idx_session_competencies_competency ON session_competencies(competency_id);
CREATE INDEX IF NOT EXISTS idx_respondents_email ON respondents(email);
