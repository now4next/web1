# 프로덕션 데이터베이스 마이그레이션 가이드 (v0.5.5)

## 📌 개요
이 가이드는 v0.5.5 업데이트를 위한 프로덕션 데이터베이스 마이그레이션 절차를 설명합니다.

### 변경 사항
- `coaching_sessions` 테이블에 `user_id`, `assistant_type` 컬럼 추가
- 로그인 회원 기준 대화 저장 및 관리 기능 구현
- 어시스턴트별 독립적인 대화 히스토리 유지

## 🚀 프로덕션 배포 절차

### 1. 로컬 환경 확인
로컬에서 마이그레이션이 정상적으로 적용되었는지 확인:

```bash
# 로컬 마이그레이션 확인
cd /home/user/webapp
npx wrangler d1 migrations list aiassess-db --local

# 로컬 데이터베이스 상태 확인
npx wrangler d1 execute aiassess-db --local --command="PRAGMA table_info(coaching_sessions)"
```

### 2. 프로덕션 마이그레이션 적용
프로덕션 데이터베이스에 마이그레이션 적용:

```bash
# 프로덕션 마이그레이션 적용
npx wrangler d1 migrations apply aiassess-db --remote

# 또는 Cloudflare Dashboard에서 수동 적용:
# 1. Cloudflare Dashboard → Workers & Pages → D1
# 2. aiassess-db 선택
# 3. Console 탭에서 아래 SQL 실행
```

### 3. 수동 마이그레이션 SQL (Dashboard 사용 시)

Cloudflare Dashboard의 D1 Console에서 다음 SQL을 순서대로 실행:

```sql
-- Add user_id column to coaching_sessions table
ALTER TABLE coaching_sessions ADD COLUMN user_id INTEGER REFERENCES users(id) ON DELETE CASCADE;

-- Add assistant_type column to track which assistant the conversation is with
ALTER TABLE coaching_sessions ADD COLUMN assistant_type TEXT DEFAULT 'consulting';

-- Create index for faster queries by user_id
CREATE INDEX IF NOT EXISTS idx_coaching_sessions_user_id ON coaching_sessions(user_id);

-- Create index for faster queries by user_id and assistant_type
CREATE INDEX IF NOT EXISTS idx_coaching_sessions_user_assistant ON coaching_sessions(user_id, assistant_type);
```

### 4. 마이그레이션 확인

프로덕션 환경에서 마이그레이션이 정상 적용되었는지 확인:

```bash
# 프로덕션 테이블 구조 확인
npx wrangler d1 execute aiassess-db --remote --command="PRAGMA table_info(coaching_sessions)"

# 인덱스 확인
npx wrangler d1 execute aiassess-db --remote --command="SELECT name FROM sqlite_master WHERE type='index' AND tbl_name='coaching_sessions'"
```

예상 결과:
```
cid  name            type     notnull  dflt_value  pk
---  --------------  -------  -------  ----------  --
0    id              INTEGER  0                    1
1    respondent_id   INTEGER  1                    0
2    analysis_result_id  INTEGER  0                0
3    session_data    TEXT     0                    0
4    created_at      DATETIME 0        CURRENT_TIMESTAMP  0
5    updated_at      DATETIME 0        CURRENT_TIMESTAMP  0
6    user_id         INTEGER  0                    0  ← 새로 추가됨
7    assistant_type  TEXT     0        'consulting' 0  ← 새로 추가됨
```

### 5. 애플리케이션 배포

마이그레이션이 완료되면 애플리케이션을 배포:

```bash
# 빌드
npm run build

# 프로덕션 배포
npx wrangler pages deploy dist --project-name aiassess
```

### 6. 기능 테스트

프로덕션 환경에서 다음 기능들을 테스트:

1. **로그인 후 AI 어시스턴트 접근**
   - 로그인하지 않은 상태에서 AI 어시스턴트 선택 → 로그인 모달 표시 확인
   - 로그인 후 AI 어시스턴트 선택 가능 확인

2. **대화 저장 및 로드**
   - AI 컨설팅, 코칭, 멘토링, 티칭 각각 대화 진행
   - 페이지 새로고침 후 각 어시스턴트별 대화 이력 유지 확인
   - "이전 대화를 불러왔습니다" 알림 표시 확인

3. **어시스턴트별 독립성**
   - 각 어시스턴트별로 독립적인 대화 히스토리 유지 확인
   - A 어시스턴트 대화가 B 어시스턴트에 영향 없는지 확인

4. **세션 만료 처리**
   - 장시간 방치 후 대화 시도 → 세션 만료 메시지 확인
   - 자동 로그아웃 및 로그인 모달 표시 확인

## 🔄 롤백 절차 (문제 발생 시)

마이그레이션에 문제가 발생한 경우 롤백:

```sql
-- 인덱스 삭제
DROP INDEX IF EXISTS idx_coaching_sessions_user_assistant;
DROP INDEX IF EXISTS idx_coaching_sessions_user_id;

-- 컬럼 삭제 (SQLite는 ALTER TABLE DROP COLUMN 미지원)
-- 따라서 테이블 재생성 필요:

-- 1. 기존 데이터 백업
CREATE TABLE coaching_sessions_backup AS SELECT id, respondent_id, analysis_result_id, session_data, created_at, updated_at FROM coaching_sessions;

-- 2. 기존 테이블 삭제
DROP TABLE coaching_sessions;

-- 3. 원래 스키마로 테이블 재생성
CREATE TABLE coaching_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  respondent_id INTEGER NOT NULL,
  analysis_result_id INTEGER,
  session_data TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (respondent_id) REFERENCES respondents(id) ON DELETE CASCADE,
  FOREIGN KEY (analysis_result_id) REFERENCES analysis_results(id) ON DELETE SET NULL
);

-- 4. 백업 데이터 복원
INSERT INTO coaching_sessions SELECT * FROM coaching_sessions_backup;

-- 5. 백업 테이블 삭제
DROP TABLE coaching_sessions_backup;
```

## 📊 데이터 마이그레이션 (기존 데이터가 있는 경우)

기존 `coaching_sessions` 데이터를 새 스키마로 마이그레이션:

```sql
-- 기존 데이터에 user_id 할당 (respondent_id 기준)
-- 이 쿼리는 환경에 따라 조정 필요
UPDATE coaching_sessions
SET user_id = (
  SELECT user_id FROM some_mapping_table WHERE respondent_id = coaching_sessions.respondent_id
)
WHERE user_id IS NULL;

-- assistant_type 추출 (session_data JSON에서)
-- 이 쿼리는 SQLite JSON 함수 사용
UPDATE coaching_sessions
SET assistant_type = json_extract(session_data, '$.assistantType')
WHERE assistant_type = 'consulting' AND json_extract(session_data, '$.assistantType') IS NOT NULL;
```

## ✅ 완료 체크리스트

- [ ] 로컬 마이그레이션 테스트 완료
- [ ] 프로덕션 데이터베이스 백업 완료
- [ ] 프로덕션 마이그레이션 적용 완료
- [ ] 테이블 구조 확인 (user_id, assistant_type 컬럼 존재)
- [ ] 인덱스 생성 확인
- [ ] 애플리케이션 배포 완료
- [ ] 로그인 필수 기능 테스트 완료
- [ ] 대화 저장/로드 기능 테스트 완료
- [ ] 어시스턴트별 독립성 테스트 완료
- [ ] 세션 만료 처리 테스트 완료

## 📞 지원

문제가 발생하면 다음 정보를 포함하여 이슈 등록:
- 오류 메시지
- 실행한 명령어
- 데이터베이스 상태 (PRAGMA table_info 결과)
- 브라우저 콘솔 로그
- 네트워크 요청/응답 (API 호출 관련)

---

**작성일**: 2025-11-11  
**버전**: 0.5.5  
**마이그레이션**: 0006_update_coaching_sessions_for_users.sql
