# 외래 키 오류 간단 해결법

## ❌ 계속 오류가 발생하는 이유

Cloudflare D1 Console에서 여러 SQL문을 한 번에 실행하면 서브쿼리가 제대로 작동하지 않을 수 있습니다.

## ✅ 해결: 2단계 방식

### 1단계: 삭제할 ID를 먼저 확인

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

이 ID들을 기억하세요!

### 2단계: ID를 직접 입력하여 삭제

위에서 확인한 ID들을 사용하여 (예: 1, 2, 3, 6) **하나씩** 실행:

```sql
DELETE FROM analysis_results WHERE competency_id IN (1, 2, 3, 6);
```

```sql
DELETE FROM session_competencies WHERE competency_id IN (1, 2, 3, 6);
```

```sql
DELETE FROM assessment_questions WHERE competency_id IN (1, 2, 3, 6);
```

```sql
DELETE FROM behavioral_indicators WHERE competency_id IN (1, 2, 3, 6);
```

```sql
DELETE FROM competencies WHERE id IN (1, 2, 3, 6);
```

### 3단계: 검증

```sql
SELECT keyword, COUNT(*) as count 
FROM competencies 
WHERE keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')
GROUP BY keyword;
```

**예상 결과:** 각 역량이 count = 1

---

## 🎯 만약 여전히 오류가 발생한다면

특정 ID가 다른 곳에서 참조되고 있을 수 있습니다. 어떤 테이블인지 확인:

```sql
SELECT 'assessment_responses' as table_name, COUNT(*) 
FROM assessment_responses 
WHERE competency_id IN (1, 2, 3, 6)
UNION ALL
SELECT 'coaching_sessions', COUNT(*) 
FROM coaching_sessions 
WHERE competency_id IN (1, 2, 3, 6);
```

만약 결과가 있다면, 그 테이블도 추가로 정리해야 합니다.
