# Cloudflare API 토큰 권한 문제 해결 가이드

## 🔍 현재 문제 상황

```
✘ [ERROR] A request to the Cloudflare API failed.
Authentication error [code: 10000]
The given account is not authorized to access this service [code: 7403]
```

**원인**: 현재 API 토큰이 D1 데이터베이스 원격 접근 권한이 없습니다.

## 🎯 해결 방법 (3가지 옵션)

---

## ✅ 옵션 1: API 토큰 권한 추가 (권장)

### 단계별 가이드

#### 1단계: Cloudflare 대시보드 접속
1. https://dash.cloudflare.com 로그인
2. 우측 상단 프로필 아이콘 클릭
3. **"My Profile"** 선택

#### 2단계: API 토큰 관리 페이지로 이동
1. 좌측 메뉴에서 **"API Tokens"** 클릭
2. 또는 직접 이동: https://dash.cloudflare.com/profile/api-tokens

#### 3단계: 현재 토큰 찾기
- 현재 사용 중인 토큰 찾기 (GenSpark에서 생성한 토큰)
- 토큰 이름 옆의 **"Edit"** 버튼 클릭

#### 4단계: 권한 추가
**필요한 권한**:
```
Account:
  ✅ D1:Edit (이미 있을 수 있음)
  ✅ Account Settings:Read

Zone: (있다면)
  ✅ Workers Scripts:Edit
  ✅ Workers Routes:Edit
```

**D1 권한 추가 방법**:
1. "Permissions" 섹션 찾기
2. **"+ Add more"** 클릭
3. 드롭다운에서 선택:
   - **Account** 선택
   - **D1** 선택  
   - **Edit** 선택
4. 하단의 **"Continue to summary"** 클릭
5. **"Update Token"** 클릭

#### 5단계: 토큰 재설정 (필요시)
- 만약 권한 추가가 안 된다면 새 토큰 생성:
  1. "Create Token" 클릭
  2. "Custom token" 템플릿 선택
  3. 아래 권한 설정:

**권장 권한 설정**:
```
Token name: GenSpark Workers D1 Full Access

Permissions:
┌─────────────────────┬────────────────────┬────────────┐
│ Resource            │ Permission         │ Access     │
├─────────────────────┼────────────────────┼────────────┤
│ Account             │ Workers Scripts    │ Edit       │
│ Account             │ D1                 │ Edit       │
│ Account             │ Workers KV Storage │ Edit       │
│ Account             │ Workers R2 Storage │ Edit       │
│ Account             │ Account Settings   │ Read       │
│ Zone                │ Workers Routes     │ Edit       │
└─────────────────────┴────────────────────┴────────────┘

Account Resources:
  Include: [Your Account Name]

Zone Resources:
  Include: All zones (또는 특정 zone 선택)

IP Filtering:
  (비워둠 - 모든 IP 허용)

TTL:
  (비워둠 - 영구)
```

#### 6단계: GenSpark에 새 토큰 등록
1. 새 토큰 생성 후 **복사** (한 번만 표시됨!)
2. GenSpark 인터페이스로 이동
3. **Deploy** 탭 선택
4. **Cloudflare API Key** 섹션에서 **"Update"** 또는 **"Configure"**
5. 새 토큰 붙여넣기
6. **"Save"** 클릭

#### 7단계: 검증
샌드박스에서 다시 시도:
```bash
cd /home/user/webapp
npx wrangler whoami
# 계정 정보가 표시되어야 함

npx wrangler d1 list
# D1 데이터베이스 목록이 표시되어야 함

npx wrangler d1 execute aiassess-production --remote --command="SELECT 1"
# 성공해야 함
```

---

## ✅ 옵션 2: Cloudflare 대시보드에서 직접 작업 (빠른 해결)

권한 문제를 해결하는 동안 대시보드에서 직접 SQL을 실행할 수 있습니다.

### 장점
- ✅ 즉시 실행 가능
- ✅ API 토큰 불필요
- ✅ 실시간 결과 확인

### 단계

#### 1. D1 Console 접속
1. https://dash.cloudflare.com 로그인
2. 좌측 메뉴: **Workers & Pages**
3. 상단 탭: **D1**
4. **aiassess-production** 클릭
5. **Console** 탭 선택

#### 2. SQL 실행
우측 쿼리 입력창에 SQL 붙여넣기:

**A. job_name 업데이트 (30개)**
```sql
UPDATE competencies SET job_name = '영업' WHERE keyword = '고객관계 구축';
UPDATE competencies SET job_name = '영업' WHERE keyword = '설득/협상';
UPDATE competencies SET job_name = '영업' WHERE keyword = '시장분석';
-- ... (나머지 27개)
```

**B. 중복 제거 (8개)**
```sql
PRAGMA foreign_keys = OFF;

DELETE FROM behavioral_indicators 
WHERE competency_id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고', '리더십', '문제해결', '시장분석', '커뮤니케이션')
);

DELETE FROM competencies 
WHERE id IN (
  SELECT c.id FROM competencies c
  JOIN competency_models cm ON c.model_id = cm.id
  WHERE cm.name = '경영지원 직무역량'
  AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고', '리더십', '문제해결', '시장분석', '커뮤니케이션')
);

PRAGMA foreign_keys = ON;
```

#### 3. 결과 확인
```sql
-- 전체 역량 개수 (45개 예상)
SELECT COUNT(*) FROM competencies;

-- job_name 설정 확인
SELECT job_name, COUNT(*) 
FROM competencies 
WHERE job_name IS NOT NULL
GROUP BY job_name;

-- 중복 확인 (0개 예상)
SELECT keyword, COUNT(*) 
FROM competencies 
GROUP BY keyword 
HAVING COUNT(*) > 1;
```

---

## ✅ 옵션 3: wrangler login 사용 (OAuth 인증)

API 토큰 대신 OAuth 로그인 사용:

### 방법

#### 문제점
샌드박스 환경에서는 브라우저 인증이 어려울 수 있습니다.

#### 시도 방법
```bash
# 현재 CLOUDFLARE_API_TOKEN 환경변수 제거
unset CLOUDFLARE_API_TOKEN

# OAuth 로그인 시도 (브라우저 필요)
cd /home/user/webapp
npx wrangler login
```

이 방법은 샌드박스 환경 특성상 작동하지 않을 가능성이 높습니다.

---

## 🎯 권장 순서

### 즉시 해결 (5분)
➡️ **옵션 2**: Cloudflare 대시보드에서 직접 SQL 실행
- `PRODUCTION_MANUAL_UPDATE.md` 참조
- 모든 SQL을 Console에서 복사-붙여넣기

### 근본 해결 (10분)
➡️ **옵션 1**: API 토큰 권한 추가
1. 기존 토큰 편집 또는 새 토큰 생성
2. D1 Edit 권한 추가
3. GenSpark에 새 토큰 등록
4. `setup_cloudflare_api_key` 재실행

---

## 📋 체크리스트

### 즉시 작업 (옵션 2)
- [ ] Cloudflare Dashboard 로그인
- [ ] D1 > aiassess-production > Console 접속
- [ ] job_name 업데이트 SQL 실행 (30개)
- [ ] 중복 제거 SQL 실행 (8개)
- [ ] 결과 확인 (45개 역량)
- [ ] 웹에서 검증 (curl 테스트)

### 권한 수정 (옵션 1)
- [ ] API Tokens 페이지 접속
- [ ] 현재 토큰 찾기
- [ ] D1 Edit 권한 추가
- [ ] 또는 새 토큰 생성
- [ ] GenSpark에 토큰 등록
- [ ] wrangler 명령어로 검증

---

## 🔍 권한 확인 명령어

```bash
# 1. 현재 토큰 정보
npx wrangler whoami

# 2. D1 데이터베이스 목록 (권한 필요)
npx wrangler d1 list

# 3. 원격 쿼리 실행 테스트 (권한 필요)
npx wrangler d1 execute aiassess-production --remote --command="SELECT 1"

# 4. 원격 파일 실행 테스트 (권한 필요)
npx wrangler d1 execute aiassess-production --remote --file=./test.sql
```

---

## 💡 참고 사항

### API 토큰 vs OAuth
- **API 토큰**: 프로그래밍 방식, CI/CD에 적합
- **OAuth 로그인**: 대화형, 로컬 개발에 적합

### 필요한 최소 권한
D1 원격 작업을 위한 최소 권한:
```
Account:
  - D1:Edit
  - Account Settings:Read (optional)
```

### 보안 팁
- API 토큰은 안전하게 보관
- 필요한 최소 권한만 부여
- 정기적으로 토큰 갱신
- 사용하지 않는 토큰은 삭제

---

## 🚀 다음 단계

1. **즉시**: 옵션 2로 데이터베이스 업데이트
2. **이후**: 옵션 1로 API 토큰 권한 수정
3. **검증**: 모든 기능이 정상 작동하는지 확인

**질문이나 문제가 있으면 언제든지 알려주세요!**
