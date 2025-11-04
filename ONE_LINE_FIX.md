# 한 줄로 중복 제거하기

## 🚀 가장 빠른 방법

Cloudflare D1 Console에서 **아래 SQL 전체**를 복사-붙여넣기하여 한 번에 실행:

### Step 1: 삭제할 ID 확인 (먼저 실행)

```sql
SELECT c.id, c.keyword, cm.name as model, COUNT(bi.id) as indicators FROM competencies c LEFT JOIN behavioral_indicators bi ON c.id = bi.competency_id JOIN competency_models cm ON c.model_id = cm.id WHERE c.keyword IN ('리더십', '문제해결', '시장분석', '커뮤니케이션', '분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고') GROUP BY c.id, c.keyword, cm.name ORDER BY c.keyword, indicators DESC;
```

**결과에서**:
- 각 keyword의 첫 번째 행(indicators 가장 큼) → **유지**
- 나머지 행들의 ID → **삭제 대상**

예시 결과:
```
id  | keyword      | model       | indicators
5   | 리더십       | 역량평가표  | 5     ← 유지
12  | 리더십       | 공통역량    | 2     ← 삭제 (ID=12)
```

✏️ **삭제할 ID를 메모** (예: 1, 2, 3, 6, 12, 18, 25)

---

### Step 2: 한 줄 삭제 실행

**⚠️ 중요: 아래 (1,2,3,6,12,18,25) 부분을 Step 1에서 메모한 실제 ID로 교체!**

```sql
PRAGMA foreign_keys = OFF; DELETE FROM analysis_results WHERE competency_id IN (1,2,3,6,12,18,25); DELETE FROM session_competencies WHERE competency_id IN (1,2,3,6,12,18,25); DELETE FROM assessment_questions WHERE competency_id IN (1,2,3,6,12,18,25); DELETE FROM behavioral_indicators WHERE competency_id IN (1,2,3,6,12,18,25); DELETE FROM competencies WHERE id IN (1,2,3,6,12,18,25); PRAGMA foreign_keys = ON;
```

---

### Step 3: 검증 (실행)

```sql
SELECT keyword, COUNT(*) as count FROM competencies GROUP BY keyword HAVING count > 1;
```

**예상 결과**: 빈 배열 (중복 없음) ✅

---

## 📋 요약

1. **Step 1 실행** → 삭제할 ID 확인 및 메모
2. **Step 2 실행** → ID 교체 후 한 줄 삭제
3. **Step 3 실행** → 검증

---

## 💡 주의사항

- **세미콜론 주의**: 모든 SQL이 세미콜론으로 연결되어 한 세션에서 실행됩니다
- **ID 교체 필수**: (1,2,3,6,12,18,25) 부분을 실제 삭제할 ID로 **반드시** 교체
- **복사-붙여넣기**: 전체 SQL을 한 번에 복사하여 Console에 붙여넣기
- **공백 제거**: 불필요한 공백이나 줄바꿈이 있으면 제거

---

## 🎯 경영지원 직무역량만 제거 (확정 버전)

"경영지원 직무역량" 모델의 4개 중복만 제거하려면:

```sql
PRAGMA foreign_keys = OFF; DELETE FROM analysis_results WHERE competency_id IN (SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id WHERE cm.name = '경영지원 직무역량' AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')); DELETE FROM session_competencies WHERE competency_id IN (SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id WHERE cm.name = '경영지원 직무역량' AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')); DELETE FROM assessment_questions WHERE competency_id IN (SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id WHERE cm.name = '경영지원 직무역량' AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')); DELETE FROM behavioral_indicators WHERE competency_id IN (SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id WHERE cm.name = '경영지원 직무역량' AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')); DELETE FROM competencies WHERE id IN (SELECT c.id FROM competencies c JOIN competency_models cm ON c.model_id = cm.id WHERE cm.name = '경영지원 직무역량' AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고')); PRAGMA foreign_keys = ON;
```

이것은 로컬에서 이미 제거한 4개 역량을 프로덕션에서도 제거합니다.

---

## ✅ 성공 확인

검증 쿼리 결과가 빈 배열이면 **완전히 성공**한 것입니다! 🎉

```sql
SELECT keyword, COUNT(*) as count FROM competencies GROUP BY keyword HAVING count > 1;
```

결과: `[]` (no rows)
