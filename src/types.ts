// Cloudflare Workers 환경 타입 정의
export type Bindings = {
  DB: D1Database;
  OPENAI_API_KEY: string;
}

// 역량 모델 타입
export type CompetencyModel = {
  id?: number;
  name: string;
  type: 'common' | 'leadership' | 'functional';
  description: string;
  target_level: string;
  created_at?: string;
  updated_at?: string;
}

// 역량 키워드 타입
export type Competency = {
  id?: number;
  model_id: number;
  keyword: string;
  description: string;
  created_at?: string;
}

// 행동 지표 타입
export type BehavioralIndicator = {
  id?: number;
  competency_id: number;
  indicator_text: string;
  level: string;
  created_at?: string;
}

// 진단 문항 타입
export type AssessmentQuestion = {
  id?: number;
  competency_id: number;
  question_text: string;
  question_type: 'self' | 'multi' | 'survey';
  scale_type: string;
  created_at?: string;
}

// 진단 세션 타입
export type AssessmentSession = {
  id?: number;
  session_name: string;
  session_type: 'self' | 'multi' | 'survey';
  target_level: string;
  status: 'draft' | 'active' | 'completed' | 'archived';
  start_date?: string;
  end_date?: string;
  analysis_date?: string;
  created_at?: string;
  updated_at?: string;
}

// 응답자 타입
export type Respondent = {
  id?: number;
  name: string;
  email: string;
  department: string;
  position: string;
  level: string;
  created_at?: string;
}

// 진단 응답 타입
export type AssessmentResponse = {
  id?: number;
  session_id: number;
  respondent_id: number;
  question_id: number;
  response_value: number;
  response_text?: string;
  created_at?: string;
}

// 분석 결과 타입
export type AnalysisResult = {
  id?: number;
  session_id: number;
  respondent_id: number;
  competency_id: number;
  avg_score: number;
  percentile: number;
  strength_level: string;
  ai_insight: string;
  created_at?: string;
}

// AI 생성 요청/응답 타입
export type AIGenerationRequest = {
  competency_keywords: string[];
  target_level: string;
  question_type: 'self' | 'multi' | 'survey';
  count?: number;
}

export type AIGenerationResponse = {
  behavioral_indicators: Array<{
    competency: string;
    indicators: string[];
  }>;
  questions: Array<{
    competency: string;
    question_text: string;
    question_type: string;
  }>;
  guide: string;
}
