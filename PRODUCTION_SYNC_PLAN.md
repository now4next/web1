# 🎯 프로덕션 동기화 계획

## 📊 현재 상태

### 로컬 (AI Developer 미리보기)
```
역량 개수: 45개
job_name: 30개 설정됨 ✅
중복 제거: 완료 ✅
코드: 최신 버전 (개선된 검색)
```

### 프로덕션 (https://aiassess.pages.dev)
```
역량 개수: 52개
job_name: 0개 (모두 NULL) ❌
중복 제거: 필요 없음 (중복 없음) ✅
코드: 최신 버전 (개선된 검색) ✅
```

---

## 🎯 동기화 작업

### ✅ 이미 완료된 작업
1. **코드 개선**: 3단계 역량 검색 로직 배포 완료
2. **오류 처리**: 명확한 메시지 및 유사 키워드 제안
3. **빌드 & 배포**: 프로덕션 적용 완료

### ⚠️ 필요한 작업
**job_name 데이터 입력** (30개 역량)

---

## 📋 실행 계획

### 방법 1: Cloudflare Dashboard Console (추천)

#### Step 1: Console 접속
```
1. https://dash.cloudflare.com 로그인
2. Workers & Pages > D1 > aiassess-production
3. Console 탭 클릭
```

#### Step 2: 현재 상태 확인
```sql
-- 1. 역량 평가표 역량 확인
SELECT keyword, job_name 
FROM competencies c
JOIN competency_models cm ON c.model_id = cm.id
WHERE cm.name = '역량 평가표'
ORDER BY keyword;

-- 2. job_name이 NULL인 개수
SELECT COUNT(*) as null_count
FROM competencies 
WHERE job_name IS NULL;
```

#### Step 3: job_name 업데이트 (30개)

**프로덕션 DB의 실제 역량 키워드 기준**:

```sql
-- 영업 직무 (3개)
UPDATE competencies SET job_name = '영업' 
WHERE keyword IN ('관계형성', '설득/영향력', '시장분석');

-- 마케팅 직무 (4개)
UPDATE competencies SET job_name = '마케팅' 
WHERE keyword IN ('디지털 마케팅', '브랜드 관리', '창의적 사고', '창의적 기획');

-- 인사 직무 (2개)
UPDATE competencies SET job_name = '인사' 
WHERE keyword IN ('팀웍/협동', '변화관리/주도');

-- 재무 직무 (4개)
UPDATE competencies SET job_name = '재무' 
WHERE keyword IN ('분석적 사고', '재무시스템이해능력', '예산운용능력', '손익마인드');

-- IT 직무 (3개)
UPDATE competencies SET job_name = 'IT' 
WHERE keyword IN ('데이터 분석', '프로젝트 관리', '체계적 사고');

-- 기획 직무 (3개)
UPDATE competencies SET job_name = '기획' 
WHERE keyword IN ('전략적 사고', '전략적 사고/기획', '정보수집 및 활용');

-- 생산관리 직무 (2개)
UPDATE competencies SET job_name = '생산관리' 
WHERE keyword IN ('프로세스 개선', '세밀/정확한 일처리');

-- 고객서비스 직무 (3개)
UPDATE competencies SET job_name = '고객서비스' 
WHERE keyword IN ('고객중심적 사고', '서비스 지향', '상황판단 및 대처능력');

-- 공통 (기타) (6개)
UPDATE competencies SET job_name = '공통' 
WHERE keyword IN ('성과지향', '주도성', '의사결정/판단력', '전문지식 보유 및 활용', '문서작성 및 관리', '동시다중업무수행');
```

#### Step 4: 검증
```sql
-- 1. job_name별 역량 개수
SELECT job_name, COUNT(*) as count 
FROM competencies 
WHERE job_name IS NOT NULL
GROUP BY job_name
ORDER BY job_name;

-- 2. 여전히 NULL인 역량 확인
SELECT keyword, description
FROM competencies c
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.job_name IS NULL
ORDER BY cm.name, keyword;

-- 3. 전체 개수 확인
SELECT 
  COUNT(*) as total,
  COUNT(job_name) as with_job_name,
  COUNT(*) - COUNT(job_name) as null_count
FROM competencies;
```

---

## 📊 예상 결과

### 업데이트 전
```
총 역량: 52개
job_name 설정: 0개
job_name NULL: 52개
```

### 업데이트 후
```
총 역량: 52개
job_name 설정: 30개 (역량 평가표)
job_name NULL: 22개 (경영지원 직무역량, 리더십 역량 등)
```

### 역량 분포 (예상)
```
영업: 3개
마케팅: 4개
인사: 2개
재무: 4개
IT: 3개
기획: 3개
생산관리: 2개
고객서비스: 3개
공통: 6개
───────────
총: 30개
```

---

## 🚀 실행 순서

### 1단계: 정보 수집 ✅
- [x] 로컬 DB 상태 확인
- [x] 프로덕션 DB 상태 확인
- [x] 필요한 작업 파악

### 2단계: 계획 수립 ✅
- [x] job_name 매핑 정의
- [x] SQL 스크립트 작성
- [x] 검증 쿼리 준비

### 3단계: 실행 ⏳ (사용자 작업)
- [ ] Cloudflare Dashboard 접속
- [ ] Console에서 SQL 실행
- [ ] 결과 검증

### 4단계: 최종 테스트 ⏳
- [ ] 직무명 검색 테스트 (`curl "https://aiassess.pages.dev/api/competencies/search?q=영업"`)
- [ ] 진단 제출 테스트
- [ ] 완료 확인

---

## 💡 중요 사항

### 1. 역량 매핑 기준
- **역량 평가표 30개만** job_name 설정
- 나머지 22개는 다른 모델에 속하므로 NULL 유지
- 각 역량은 1개의 job_name만 가질 수 있음

### 2. 중복 제거 불필요
- 프로덕션에 실제 중복 없음 (이미 확인됨)
- 52개 역량 모두 고유함

### 3. 검증 필수
- SQL 실행 후 반드시 검증 쿼리 실행
- 예상 결과와 일치하는지 확인

---

## 📞 실행 안내

### Cloudflare Console 접속 방법
```
브라우저에서:
1. https://dash.cloudflare.com
2. 로그인
3. 좌측 메뉴: Workers & Pages
4. 상단 탭: D1
5. 데이터베이스 선택: aiassess-production
6. Console 탭 클릭
```

### SQL 실행 방법
```
1. Step 2의 확인 쿼리 실행 (현재 상태 파악)
2. Step 3의 UPDATE 문 실행 (한 번에 또는 하나씩)
3. Step 4의 검증 쿼리 실행 (결과 확인)
```

### API 테스트 방법
```bash
# 직무명 검색 테스트
curl "https://aiassess.pages.dev/api/competencies/search?q=영업"
curl "https://aiassess.pages.dev/api/competencies/search?q=마케팅"
curl "https://aiassess.pages.dev/api/competencies/search?q=IT"

# 결과 개수 확인
curl "https://aiassess.pages.dev/api/competencies/search?q=영업" | jq '.data | length'
# 예상: 3개
```

---

## ✅ 완료 체크리스트

### 준비 (완료 ✅)
- [x] 현재 상태 분석
- [x] SQL 스크립트 작성
- [x] 검증 쿼리 준비
- [x] 실행 가이드 작성

### 실행 (대기 중 ⏳)
- [ ] Cloudflare Console 접속
- [ ] 현재 상태 확인 SQL 실행
- [ ] job_name UPDATE SQL 실행
- [ ] 검증 SQL 실행
- [ ] API 테스트

### 완료 (목표 🎯)
- [ ] job_name 30개 설정 완료
- [ ] 직무명 검색 정상 작동
- [ ] 진단 제출 정상 작동
- [ ] 모든 기능 최종 검증

---

**모든 준비가 완료되었습니다!**

이제 Cloudflare Dashboard Console에서 SQL을 실행하시면 됩니다. 🚀
