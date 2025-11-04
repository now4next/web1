-- Add job_name column to competencies table
ALTER TABLE competencies ADD COLUMN job_name TEXT;

-- Create index for faster searching
CREATE INDEX IF NOT EXISTS idx_competencies_job_name ON competencies(job_name);
