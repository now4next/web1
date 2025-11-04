ALTER TABLE competencies ADD COLUMN job_name TEXT;
CREATE INDEX IF NOT EXISTS idx_competencies_job_name ON competencies(job_name);
