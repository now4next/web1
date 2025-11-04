DELETE FROM behavioral_indicators  WHERE competency_id IN (   SELECT c.id    FROM competencies c   JOIN competency_models cm ON c.model_id = cm.id   WHERE cm.name = '경영지원 직무역량'   AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고') );
NEWLINE
 DELETE FROM competencies  WHERE id IN (   SELECT c.id    FROM competencies c   JOIN competency_models cm ON c.model_id = cm.id   WHERE cm.name = '경영지원 직무역량'   AND c.keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고') );
NEWLINE
 SELECT keyword, COUNT(*) as count  FROM competencies  WHERE keyword IN ('분석적 사고', '의사결정/판단력', '전략적 사고/기획', '창의적 사고') GROUP BY keyword; 