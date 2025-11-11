-- Add user_id column to coaching_sessions table and create index
-- This migration connects coaching sessions to logged-in users instead of respondents

-- Add user_id column (nullable for backward compatibility)
ALTER TABLE coaching_sessions ADD COLUMN user_id INTEGER REFERENCES users(id) ON DELETE CASCADE;

-- Add assistant_type column to track which assistant the conversation is with
ALTER TABLE coaching_sessions ADD COLUMN assistant_type TEXT DEFAULT 'consulting';

-- Create index for faster queries by user_id and assistant_type
CREATE INDEX IF NOT EXISTS idx_coaching_sessions_user_id ON coaching_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_coaching_sessions_user_assistant ON coaching_sessions(user_id, assistant_type);
