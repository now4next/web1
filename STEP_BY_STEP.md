# 중복 제거 단계별 실행 가이드 (초간단)

## 🎯 목표
프로덕션 DB에서 중복된 역량 제거하기

## 📍 현재 위치
Cloudflare Dashboard → Workers & Pages → D1 → aiassess-production → **Console** 탭

---

## Step 1: 삭제할 ID 찾기 (복사하기)

Console에 이 쿼리를 붙여넣고 실행:

```sql
SELECT c.id 
FROM competencies c 
JOIN competency_models cm ON c.model_id = cm.id 
WHERE cm.name = '경영지원 직무역량' 
AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고');
```

**결과 예시:**
```
id
1
2
3
6
```

✏️ **이 ID들을 메모장에 복사하세요**: 예) `1, 2, 3, 6`

---

## Step 2: 어디서 참조되는지 확인

아래 쿼리에서 **(1, 2, 3, 6)** 부분을 **Step 1에서 복사한 ID들**로 교체:

```sql
SELECT 'analysis_results' as table_name, COUNT(*) as count FROM analysis_results WHERE competency_id IN (1, 2, 3, 6)
UNION ALL
SELECT 'session_competencies', COUNT(*) FROM session_competencies WHERE competency_id IN (1, 2, 3, 6)
UNION ALL
SELECT 'assessment_questions', COUNT(*) FROM assessment_questions WHERE competency_id IN (1, 2, 3, 6)
UNION ALL
SELECT 'behavioral_indicators', COUNT(*) FROM behavioral_indicators WHERE competency_id IN (1, 2, 3, 6);
```

**결과 예시:**
```
table_name              | count
analysis_results        | 0
session_competencies    | 5
assessment_questions    | 12
behavioral_indicators   | 8
```

✏️ **count > 0 인 테이블들을 메모하세요**

---

## Step 3: 삭제 실행 (하나씩!)

아래 SQL들에서 **(1, 2, 3, 6)** 부분을 **Step 1의 ID들**로 교체하고, **하나씩** 실행:

### 3-1. analysis_results 삭제

```sql
DELETE FROM analysis_results WHERE competency_id IN (1, 2, 3, 6);
```

**✅ 실행 후 결과**: `X rows deleted` 또는 `0 rows deleted`

### 3-2. session_competencies 삭제

```sql
DELETE FROM session_competencies WHERE competency_id IN (1, 2, 3, 6);
```

**✅ 실행 후 결과**: `X rows deleted`

### 3-3. assessment_questions 삭제

```sql
DELETE FROM assessment_questions WHERE competency_id IN (1, 2, 3, 6);
```

**✅ 실행 후 결과**: `X rows deleted`

### 3-4. behavioral_indicators 삭제

```sql
DELETE FROM behavioral_indicators WHERE competency_id IN (1, 2, 3, 6);
```

**✅ 실행 후 결과**: `X rows deleted`

### 3-5. competencies 삭제 (마지막!)

```sql
DELETE FROM competencies WHERE id IN (1, 2, 3, 6);
```

**✅ 실행 후 결과**: `4 rows deleted` (또는 삭제한 ID 개수만큼)

---

## Step 4: 검증

```sql
SELECT keyword, COUNT(*) as count 
FROM competencies 
WHERE keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
GROUP BY keyword;
```

**✅ 예상 결과**: 각 역량이 `count = 1`

```
keyword            | count
분석적 사고        | 1
의사결정/판단력    | 1
전략적 사고/기획   | 1
창의적 사고        | 1
```

---

## Step 5: 전체 중복 확인

```sql
SELECT keyword, COUNT(*) as count 
FROM competencies 
GROUP BY keyword 
HAVING count > 1;
```

**✅ 예상 결과**: 빈 배열 (중복 없음)

---

## 🎉 완료!

만약 여전히 다른 중복이 있다면 (리더십, 문제해결, 시장분석, 커뮤니케이션):

1. **Step 1**로 돌아가서 다른 중복 역량의 ID 찾기
2. 각 역량에서 **행동 지표가 적은 것**의 ID를 메모
3. **Step 2-5** 반복

---

## ⚠️ 문제 해결

### "여전히 FOREIGN KEY 오류가 발생해요"

다른 테이블에서도 참조하고 있을 수 있습니다. 다음 쿼리로 확인:

```sql
SELECT name FROM sqlite_master WHERE type='table' AND sql LIKE '%competency_id%';
```

결과로 나온 테이블들을 Step 2의 쿼리에 추가하여 확인하세요.

### "ID를 어떻게 선택하나요?"

중복된 역량 중에서:
- ✅ **행동 지표가 많은 것 유지**
- ❌ 행동 지표가 적은 것 삭제

확인 방법:
```sql
SELECT c.id, c.keyword, COUNT(bi.id) as indicator_count
FROM competencies c
LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id
WHERE c.keyword = '분석적 사고'
GROUP BY c.id, c.keyword
ORDER BY indicator_count DESC;
```

첫 번째 행(indicator_count가 가장 큰 것)의 ID는 **유지**, 나머지는 **삭제**

---

**중요**: 각 DELETE 문을 **하나씩** 실행하고 결과를 확인하세요!
