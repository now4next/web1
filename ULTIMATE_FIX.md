# 외래 키 오류 완전 해결 가이드

## 🔍 근본 원인 분석

### 문제 1: 외래 키 제약조건 활성화 상태
SQLite(D1)는 기본적으로 외래 키 제약조건이 **비활성화**되어 있습니다.
하지만 일부 작업에서는 자동으로 활성화되어 충돌이 발생합니다.

### 문제 2: CASCADE 작동 안 함
스키마에는 `ON DELETE CASCADE`가 설정되어 있지만, 외래 키가 비활성화되면 작동하지 않습니다.

### 문제 3: Cloudflare D1 Console의 제한
서브쿼리와 복잡한 SQL이 제대로 작동하지 않을 수 있습니다.

---

## ✅ 완전한 해결책

### 방법 1: 외래 키를 비활성화하고 삭제 (가장 확실함)

Cloudflare Dashboard → D1 → aiassess-production → Console

#### Step 1: 외래 키 비활성화 확인
```sql
PRAGMA foreign_keys;
```
결과: `0` (비활성화) 또는 `1` (활성화)

#### Step 2: 외래 키 비활성화 (이미 0이면 Skip)
```sql
PRAGMA foreign_keys = OFF;
```

#### Step 3: 삭제할 역량 ID 확인
```sql
SELECT c.id, c.keyword, cm.name as model_name
FROM competencies c
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
ORDER BY c.keyword, c.id;
```

각 역량의 행동 지표 수도 확인:
```sql
SELECT c.id, c.keyword, cm.name, COUNT(bi.id) as indicators
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
GROUP BY c.id, c.keyword, cm.name
ORDER BY c.keyword, indicators DESC;
```

**결정**: 각 keyword에서 indicators가 **가장 큰 것을 유지**, 나머지를 삭제

예시 결과:
```
id | keyword      | name        | indicators
5  | 리더십       | 역량평가표  | 5    ← 유지
12 | 리더십       | 공통역량    | 2    ← 삭제
8  | 문제해결     | 역량평가표  | 4    ← 유지
18 | 문제해결     | 공통역량    | 3    ← 삭제
25 | 문제해결     | 기타        | 1    ← 삭제
...
```

✏️ **삭제할 ID 메모**: 예) `12, 18, 25, 28, 35, 40`

#### Step 4: 삭제 실행 (외래 키 OFF 상태에서)

**중요: 아래 (12, 18, 25, 28, 35, 40) 부분을 실제 삭제할 ID로 교체**

```sql
DELETE FROM analysis_results WHERE competency_id IN (12, 18, 25, 28, 35, 40);
```

```sql
DELETE FROM session_competencies WHERE competency_id IN (12, 18, 25, 28, 35, 40);
```

```sql
DELETE FROM assessment_questions WHERE competency_id IN (12, 18, 25, 28, 35, 40);
```

```sql
DELETE FROM behavioral_indicators WHERE competency_id IN (12, 18, 25, 28, 35, 40);
```

```sql
DELETE FROM competencies WHERE id IN (12, 18, 25, 28, 35, 40);
```

#### Step 5: 외래 키 다시 활성화 (선택사항)
```sql
PRAGMA foreign_keys = ON;
```

#### Step 6: 검증
```sql
SELECT keyword, COUNT(*) as count 
FROM competencies 
WHERE keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
GROUP BY keyword;
```

예상: 각 역량이 `count = 1`

```sql
SELECT keyword, COUNT(*) as count 
FROM competencies 
GROUP BY keyword 
HAVING count > 1;
```

예상: 빈 결과 (중복 없음)

---

### 방법 2: 트랜잭션으로 한 번에 실행

```sql
BEGIN TRANSACTION;

PRAGMA foreign_keys = OFF;

DELETE FROM analysis_results WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM session_competencies WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM assessment_questions WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM behavioral_indicators WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM competencies WHERE id IN (12, 18, 25, 28, 35, 40);

PRAGMA foreign_keys = ON;

COMMIT;
```

**주의**: Cloudflare D1 Console에서 트랜잭션이 지원되지 않을 수 있습니다.

---

### 방법 3: Wrangler CLI 사용 (권장 - 가장 안전)

로컬에서 SQL 파일 생성 후 실행:

#### 1. SQL 파일 생성 (remove_production_duplicates.sql)

```sql
-- 외래 키 비활성화
PRAGMA foreign_keys = OFF;

-- 삭제할 ID: Step 3에서 확인한 실제 ID로 교체
DELETE FROM analysis_results WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM session_competencies WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM assessment_questions WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM behavioral_indicators WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM competencies WHERE id IN (12, 18, 25, 28, 35, 40);

-- 외래 키 활성화
PRAGMA foreign_keys = ON;

-- 검증
SELECT keyword, COUNT(*) as count FROM competencies GROUP BY keyword HAVING count > 1;
```

#### 2. Wrangler로 실행

```bash
npx wrangler d1 execute aiassess-production --remote --file=./remove_production_duplicates.sql
```

---

## 🎯 실전 예제 (전체 프로세스)

### 1. 프로덕션에서 중복 확인

```sql
SELECT keyword, COUNT(*) as count 
FROM competencies 
GROUP BY keyword 
HAVING count > 1
ORDER BY count DESC;
```

결과:
```
keyword      | count
문제해결     | 3
커뮤니케이션 | 3
리더십       | 2
시장분석     | 2
```

### 2. 각 중복의 상세 정보 확인

```sql
SELECT 
  c.id, 
  c.keyword, 
  cm.name as model_name, 
  cm.type,
  COUNT(bi.id) as indicators,
  c.description
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
JOIN competency_models cm ON c.model_id = cm.id
WHERE c.keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션')
GROUP BY c.id, c.keyword, cm.name, cm.type, c.description
ORDER BY c.keyword, indicators DESC;
```

### 3. 유지/삭제 결정

각 keyword 그룹에서:
- ✅ **첫 번째 행 (indicators 가장 많음)** → 유지
- ❌ **나머지 행들** → 삭제

예시:
```
ID 유지: 5, 8, 15, 20
ID 삭제: 12, 18, 25, 28, 35, 40
```

### 4. 외래 키 OFF → 삭제 → 검증

```sql
PRAGMA foreign_keys = OFF;
```

```sql
DELETE FROM analysis_results WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM session_competencies WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM assessment_questions WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM behavioral_indicators WHERE competency_id IN (12, 18, 25, 28, 35, 40);
DELETE FROM competencies WHERE id IN (12, 18, 25, 28, 35, 40);
```

```sql
SELECT keyword, COUNT(*) as count FROM competencies GROUP BY keyword HAVING count > 1;
```

결과: 빈 배열 ✅

---

## 📋 체크리스트

- [ ] 1. `PRAGMA foreign_keys;` 실행하여 상태 확인
- [ ] 2. `PRAGMA foreign_keys = OFF;` 실행
- [ ] 3. 중복 역량 ID 조회 및 기록
- [ ] 4. 각 역량의 indicators 수 확인
- [ ] 5. 유지/삭제 ID 결정
- [ ] 6. `DELETE FROM analysis_results` 실행
- [ ] 7. `DELETE FROM session_competencies` 실행
- [ ] 8. `DELETE FROM assessment_questions` 실행
- [ ] 9. `DELETE FROM behavioral_indicators` 실행
- [ ] 10. `DELETE FROM competencies` 실행
- [ ] 11. 검증 쿼리 실행
- [ ] 12. `PRAGMA foreign_keys = ON;` 실행 (선택)

---

## 🔧 문제 해결

### "PRAGMA foreign_keys = OFF가 안 먹혀요"

Cloudflare D1 Console에서는 PRAGMA가 세션별로 작동합니다.
각 쿼리를 **같은 세션에서** 실행해야 합니다.

**해결**: 여러 DELETE문을 세미콜론으로 연결하여 한 번에 실행
```sql
DELETE FROM analysis_results WHERE competency_id IN (12, 18, 25); DELETE FROM session_competencies WHERE competency_id IN (12, 18, 25); DELETE FROM assessment_questions WHERE competency_id IN (12, 18, 25); DELETE FROM behavioral_indicators WHERE competency_id IN (12, 18, 25); DELETE FROM competencies WHERE id IN (12, 18, 25);
```

### "여전히 외래 키 오류가 나요"

다른 테이블이 참조하고 있을 수 있습니다.

모든 테이블 확인:
```sql
SELECT name, sql FROM sqlite_master 
WHERE type='table' 
AND sql LIKE '%competency_id%';
```

결과로 나온 테이블들에서도 데이터를 삭제해야 합니다.

---

## 💡 핵심 팁

1. **PRAGMA foreign_keys = OFF**: 외래 키를 일시적으로 비활성화
2. **한 번에 실행**: 세미콜론으로 연결하여 같은 세션에서 실행
3. **순서 중요**: 참조하는 테이블 먼저, 참조되는 테이블 나중
4. **검증 필수**: 삭제 후 중복 확인 쿼리 실행

---

## 🎉 성공 기준

```sql
SELECT keyword, COUNT(*) as count FROM competencies GROUP BY keyword HAVING count > 1;
```

**결과: 빈 배열 (no rows)**

이것이 나오면 완전히 성공한 것입니다! 🎊

---

**가장 확실한 방법**: `PRAGMA foreign_keys = OFF` → 삭제 → 검증
