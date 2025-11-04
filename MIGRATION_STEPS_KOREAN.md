# 프로덕션 데이터베이스 마이그레이션 가이드

## 🚀 배포 완료
- **프로덕션 URL**: https://f4544769.aiassess.pages.dev
- **프로젝트 이름**: aiassess
- **브랜치**: main
- **배포 시간**: 2025-11-04

## ⚠️ 중요: 데이터베이스 마이그레이션 필수

직무명 검색 기능을 사용하려면 프로덕션 데이터베이스에 마이그레이션을 적용해야 합니다.

## 📋 마이그레이션 절차

### 1단계: Cloudflare Dashboard 접속

1. https://dash.cloudflare.com 접속
2. **Workers & Pages** 메뉴 선택
3. **D1** 선택
4. **aiassess-production** 데이터베이스 선택
5. **Console** 탭 클릭

### 2단계: 스키마 변경 (2개 SQL문 실행)

**첫 번째 SQL:**
```sql
ALTER TABLE competencies ADD COLUMN job_name TEXT;
```
→ 실행 후 "Success" 확인

**두 번째 SQL:**
```sql
CREATE INDEX IF NOT EXISTS idx_competencies_job_name ON competencies(job_name);
```
→ 실행 후 "Success" 확인

### 3단계: 데이터 업데이트 (30개 UPDATE문 실행)

아래 30개 UPDATE문을 **한 번에** 복사하여 Console에 붙여넣고 실행:

```sql
UPDATE competencies SET job_name = '재경' WHERE keyword = '분석적 사고' AND job_name IS NULL;
UPDATE competencies SET job_name = '홍보' WHERE keyword = '의사결정/판단력' AND job_name IS NULL;
UPDATE competencies SET job_name = '홍보' WHERE keyword = '전략적 사고/기획' AND job_name IS NULL;
UPDATE competencies SET job_name = '홍보' WHERE keyword = '창의적 사고' AND job_name IS NULL;
UPDATE competencies SET job_name = '홍보' WHERE keyword = '설득/영향력' AND job_name IS NULL;
UPDATE competencies SET job_name = '관재시설' WHERE keyword = '팀웍/협동' AND job_name IS NULL;
UPDATE competencies SET job_name = '관재시설' WHERE keyword = '프로젝트 관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '영업' WHERE keyword = '관계형성' AND job_name IS NULL;
UPDATE competencies SET job_name = '기술지원' WHERE keyword = '문서작성 및 관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '기술지원' WHERE keyword = '정보수집 및 활용' AND job_name IS NULL;
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '데이터 분석' AND job_name IS NULL;
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '디지털 마케팅' AND job_name IS NULL;
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '브랜드 관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '시장분석' AND job_name IS NULL;
UPDATE competencies SET job_name = '마케팅' WHERE keyword = '창의적 기획' AND job_name IS NULL;
UPDATE competencies SET job_name = '총무' WHERE keyword = '세밀/정확한 일처리' AND job_name IS NULL;
UPDATE competencies SET job_name = '비서' WHERE keyword = '전략적 사고' AND job_name IS NULL;
UPDATE competencies SET job_name = '비서' WHERE keyword = '체계적 사고' AND job_name IS NULL;
UPDATE competencies SET job_name = '법무' WHERE keyword = '리스크 관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '법무' WHERE keyword = '법률 전문성' AND job_name IS NULL;
UPDATE competencies SET job_name = '재무' WHERE keyword = '비용관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '재무' WHERE keyword = '재무분석' AND job_name IS NULL;
UPDATE competencies SET job_name = '재무' WHERE keyword = '전략적 재무관리' AND job_name IS NULL;
UPDATE competencies SET job_name = '회계' WHERE keyword = '수치감각' AND job_name IS NULL;
UPDATE competencies SET job_name = '회계' WHERE keyword = '예산수립 및 통제' AND job_name IS NULL;
UPDATE competencies SET job_name = '감사/기획' WHERE keyword = '위험분석 및 평가' AND job_name IS NULL;
UPDATE competencies SET job_name = '감사/기획' WHERE keyword = '제도 및 시스템 이해' AND job_name IS NULL;
UPDATE competencies SET job_name = '정보기술' WHERE keyword = '기술적 전문성' AND job_name IS NULL;
UPDATE competencies SET job_name = '윤리' WHERE keyword = '윤리경영' AND job_name IS NULL;
UPDATE competencies SET job_name = '인사' WHERE keyword = '인재 개발' AND job_name IS NULL;
```

→ 실행 후 "30 commands executed successfully" 확인

### 4단계: 검증

다음 SQL로 데이터가 제대로 업데이트되었는지 확인:

```sql
SELECT keyword, job_name FROM competencies WHERE job_name = '영업';
```

**예상 결과:**
```
관계형성    | 영업
서비스 지향  | 영업
성과지향    | 영업
```

### 5단계: API 테스트

브라우저나 curl로 API 테스트:

```bash
curl "https://f4544769.aiassess.pages.dev/api/competencies/search?q=영업"
```

또는 브라우저에서:
```
https://f4544769.aiassess.pages.dev/api/competencies/search?q=영업
```

**예상 결과:** 영업 직무의 역량 3개 반환 (관계형성, 서비스 지향, 성과지향)

## ✅ 완료 확인

모든 단계를 완료하면:

1. ✅ 스키마 변경 완료 (job_name 컬럼 추가)
2. ✅ 인덱스 생성 완료 (검색 최적화)
3. ✅ 데이터 업데이트 완료 (30개 역량에 직무명 매핑)
4. ✅ API 테스트 통과

이제 **"영업", "마케팅", "인사"** 등 직무명으로 역량을 검색할 수 있습니다! 🎉

## 📚 지원되는 직무 카테고리 (15개)

- 감사/기획
- 관재시설
- 기술지원
- 마케팅
- 법무
- 비서
- **영업**
- 윤리
- 인사
- 재경
- 재무
- 정보기술
- 총무
- 홍보
- 회계

## 🔍 검색 사용 예시

### 직무명으로 검색
- 검색어: **영업** → 영업 직무 역량 3개
- 검색어: **마케팅** → 마케팅 직무 역량 5개
- 검색어: **인사** → 인사 직무 역량 1개

### 역량명으로 검색 (기존 기능 유지)
- 검색어: **분석** → "분석"이 포함된 모든 역량

### 혼합 검색
- 역량명, 역량정의, 직무명 중 어디든 매칭되면 결과에 포함

## ⚠️ 문제 해결

### "duplicate column name" 오류
→ 이미 마이그레이션이 적용되어 있습니다. 3단계(데이터 업데이트)부터 진행하세요.

### UPDATE문 실행 후 0 rows changed
→ 이미 데이터가 업데이트되어 있거나, 해당 역량이 데이터베이스에 없습니다.

### API 테스트 시 빈 결과
→ 1-3단계를 모두 완료했는지 확인하고, 4단계 검증 쿼리를 실행하여 데이터를 확인하세요.

## 📞 도움이 필요하신가요?

마이그레이션 중 문제가 발생하면:
1. 오류 메시지를 확인하세요
2. 4단계 검증 쿼리로 현재 상태를 확인하세요
3. GitHub Issues에 질문을 남겨주세요

---

**버전**: v0.5.2  
**마이그레이션 작성일**: 2025-11-04  
**예상 소요 시간**: 5-10분
