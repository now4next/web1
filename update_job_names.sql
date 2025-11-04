-- Update job_name for competencies from CSV data

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
UPDATE competencies SET job_name = '정보기술' WHERE keyword = '고객중심적 사고' AND job_name IS NULL;
UPDATE competencies SET job_name = '영업' WHERE keyword = '서비스 지향' AND job_name IS NULL;
UPDATE competencies SET job_name = '영업' WHERE keyword = '성과지향' AND job_name IS NULL;
UPDATE competencies SET job_name = '윤리' WHERE keyword = '상황판단 및 대처능력' AND job_name IS NULL;
UPDATE competencies SET job_name = '인사' WHERE keyword = '동시다중업무수행' AND job_name IS NULL;
UPDATE competencies SET job_name = '인사' WHERE keyword = '변화관리/주도' AND job_name IS NULL;
UPDATE competencies SET job_name = '재경' WHERE keyword = '손익마인드' AND job_name IS NULL;
UPDATE competencies SET job_name = '재무' WHERE keyword = '재무시스템이해능력' AND job_name IS NULL;
UPDATE competencies SET job_name = '재무' WHERE keyword = '전문지식 보유 및 활용' AND job_name IS NULL;
UPDATE competencies SET job_name = '정보기술' WHERE keyword = '프로세스 개선' AND job_name IS NULL;
UPDATE competencies SET job_name = '총무' WHERE keyword = '주도성' AND job_name IS NULL;
UPDATE competencies SET job_name = '회계' WHERE keyword = '예산운용능력' AND job_name IS NULL;

-- Total: 30 competencies updated with job names
