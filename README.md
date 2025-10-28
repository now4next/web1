# AI 역량 진단 플랫폼

AI 기술을 활용한 지능형 역량 진단 및 개발 지원 플랫폼입니다.

## 🎯 프로젝트 개요

조직의 역량 모델을 기반으로 맞춤형 진단을 자동 생성하고, 진단 결과를 분석하여 실행 지원까지 제공하는 통합 플랫폼입니다.

## 🌐 데모 URL

- **샌드박스 개발 서버**: https://3000-i2wawzlxi67qffj9y5ux8-02b9cc79.sandbox.novita.ai
- **API Base URL**: https://3000-i2wawzlxi67qffj9y5ux8-02b9cc79.sandbox.novita.ai/api

## ✅ 현재 구현된 기능

### Phase 1: ASSESS (진단 설계 및 실행) ✅
- ✅ **역량 키워드 검색 및 선택**: 조직의 역량 모델에서 키워드 검색
- ✅ **AI 문항 자동 생성**: OpenAI GPT-4o-mini를 활용한 진단 문항 생성
  - 행동 지표 (Behavioral Indicators) 자동 생성
  - 역량별 진단 문항 자동 생성
  - 진단 안내문 자동 생성
- ✅ **진단 유형 선택**: 자가진단, 다면평가, 설문조사
- ✅ **대상 직급 맞춤화**: 직급별 맞춤형 문항 생성

### Phase 2: ANALYTICS (분석 및 인사이트) ⚠️
- ⏳ 진단 데이터 수집 및 저장 (데이터베이스 스키마 준비 완료)
- ⏳ 기본 통계 분석 (평균, 표준편차, 백분위)
- ⏳ AI 기반 정성적 인사이트 리포트
- ⏳ 전사 현황 모니터링 대시보드

### Phase 3: ACTION (실행 지원) ✅
- ✅ **AI 코칭 챗봇**: 역량 진단 결과에 대한 대화형 피드백
- ⏳ AI 튜터 (맞춤형 교육 추천)
- ⏳ AI 컨설턴트 (전략 수립 가이드)

## 📊 데이터 아키텍처

### 데이터베이스: Cloudflare D1 (SQLite)

**주요 테이블:**
- `competency_models`: 역량 모델 (공통/리더십/직무)
- `competencies`: 역량 키워드
- `behavioral_indicators`: 행동 지표
- `assessment_questions`: 진단 문항
- `assessment_sessions`: 진단 세션
- `respondents`: 응답자 정보
- `assessment_responses`: 진단 응답 데이터
- `analysis_results`: 분석 결과
- `coaching_sessions`: AI 코칭 세션 기록

### 저장 서비스
- **Cloudflare D1**: 관계형 데이터 저장
- **Cloudflare KV**: (향후) 캐시 및 세션 관리
- **Cloudflare R2**: (향후) 리포트 파일 저장

## 🔧 기술 스택

- **Backend**: Hono (TypeScript)
- **Frontend**: Vanilla JavaScript + TailwindCSS
- **Database**: Cloudflare D1 (SQLite)
- **AI**: OpenAI GPT-4o-mini API
- **Deployment**: Cloudflare Pages/Workers
- **Development**: Wrangler, PM2

## 🚀 로컬 개발 환경 설정

### 1. 환경 변수 설정

`.dev.vars` 파일에 OpenAI API 키를 설정하세요:

```bash
OPENAI_API_KEY=sk-your-openai-api-key-here
```

### 2. 의존성 설치

```bash
npm install
```

### 3. 데이터베이스 마이그레이션 및 시드

```bash
# 로컬 D1 데이터베이스 마이그레이션
npm run db:migrate:local

# 샘플 데이터 삽입
npm run db:seed
```

### 4. 개발 서버 시작

```bash
# 빌드
npm run build

# PM2로 개발 서버 시작
pm2 start ecosystem.config.cjs

# 또는 직접 실행
npm run dev:sandbox
```

서버는 `http://localhost:3000`에서 실행됩니다.

## 📡 API 엔드포인트

### 역량 관리
- `GET /api/competency-models` - 역량 모델 목록
- `POST /api/competency-models` - 역량 모델 생성
- `GET /api/competencies/search?q={keyword}` - 역량 검색
- `GET /api/competencies/:modelId` - 특정 모델의 역량 목록
- `POST /api/competencies` - 역량 추가

### AI 기능
- `POST /api/ai/generate-questions` - AI 문항 생성
  ```json
  {
    "competency_keywords": ["커뮤니케이션", "리더십"],
    "target_level": "manager",
    "question_type": "self"
  }
  ```
- `POST /api/ai/coaching` - AI 코칭 대화
  ```json
  {
    "messages": [
      {"role": "system", "content": "..."},
      {"role": "user", "content": "..."}
    ]
  }
  ```

### 진단 관리
- `GET /api/assessment-sessions` - 진단 세션 목록
- `POST /api/assessment-sessions` - 진단 세션 생성
- `GET /api/respondents` - 응답자 목록
- `POST /api/respondents` - 응답자 등록

## 📝 사용 가이드

### 1. 역량 키워드 선택
- "진단 설계" 탭에서 역량 키워드를 검색합니다
- 예: "커뮤니케이션", "리더십", "전략적사고"
- 검색 결과에서 필요한 역량을 선택합니다

### 2. AI 문항 생성
- 대상 직급 선택 (전체/사원·대리/과장·차장/팀장 이상)
- 진단 유형 선택 (자가진단/다면평가/설문조사)
- "AI 문항 생성" 버튼 클릭
- AI가 자동으로 행동 지표와 진단 문항을 생성합니다

### 3. AI 코칭 활용
- "실행 지원" 탭으로 이동
- 진단 결과에 대해 AI 코치와 대화를 시작합니다
- 강점 강화 및 약점 보완 방안을 상담받을 수 있습니다

## 🎨 샘플 데이터

프로젝트에는 다음 샘플 데이터가 포함되어 있습니다:

### 역량 모델
- 공통 역량 (전 직원 대상)
- 리더십 역량 (관리자 이상)
- 전략기획 직무역량 (전문가)

### 역량 키워드
- 커뮤니케이션, 문제해결, 협업, 학습민첩성
- 전략적사고, 변화관리, 코칭, 의사결정
- 데이터분석, 사업기획, 시장분석

## 🔮 향후 개발 계획

### Phase 2 완성 (우선순위: 높음)
- [ ] 진단 응답 수집 UI
- [ ] 기본 통계 분석 엔진
- [ ] AI 기반 정성적 인사이트 생성
- [ ] 대시보드 시각화 (Chart.js)

### Phase 3 확장 (우선순위: 중간)
- [ ] AI 튜터: 맞춤형 학습 자료 추천
- [ ] AI 컨설턴트: 단계별 전략 수립 가이드
- [ ] 학습 콘텐츠 검색 및 추천

### 추가 기능 (우선순위: 낮음)
- [ ] 사용자 인증 및 권한 관리
- [ ] PDF 리포트 생성
- [ ] 이메일 알림
- [ ] 다국어 지원

## ⚠️ 제약사항 (Cloudflare Pages 한계)

현재 구현은 Cloudflare Pages/Workers 환경에 최적화되어 있습니다:

- ✅ **가능한 것**: 
  - 간단한 통계 분석 (평균, 표준편차, 백분위)
  - OpenAI API를 통한 AI 기능
  - D1 데이터베이스 기본 쿼리
  - 실시간 대화형 코칭

- ❌ **불가능한 것**:
  - 복잡한 통계 분석 (상관분석, 회귀분석, 요인분석)
  - Python 기반 ML 모델 실행
  - 대용량 파일 처리
  - 장시간 실행되는 백그라운드 작업

## 🔐 보안 고려사항

- **API 키 관리**: 
  - 로컬: `.dev.vars` 파일 사용 (git에 커밋되지 않음)
  - 프로덕션: `wrangler secret put` 명령으로 안전하게 관리
- **데이터 보안**: D1 데이터베이스는 Cloudflare 네트워크 내에서 보호됨
- **CORS 설정**: API 엔드포인트에만 CORS 활성화

## 🐛 문제 해결

### OpenAI API 오류
```
Error: OpenAI API key가 설정되지 않았습니다
```
→ `.dev.vars` 파일에 유효한 `OPENAI_API_KEY`를 설정하세요.

### 데이터베이스 오류
```
Error: no such table: competency_models
```
→ `npm run db:migrate:local`을 실행하여 마이그레이션을 적용하세요.

### 포트 충돌
```
Error: Port 3000 is already in use
```
→ `npm run clean-port` 또는 `fuser -k 3000/tcp`로 포트를 정리하세요.

## 📄 라이센스

This project is for demonstration purposes.

## 👥 기여

기여는 언제나 환영합니다! PR을 보내주세요.

## 📧 문의

프로젝트 관련 문의사항이 있으시면 이슈를 등록해주세요.

---

**마지막 업데이트**: 2025-10-28  
**현재 버전**: 0.1.0 (Phase 1 & 3 완료)  
**개발 상태**: ✅ Active Development
