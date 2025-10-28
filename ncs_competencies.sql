-- NCS 기반 직무 전문 역량 추가
-- 출처: https://www.ncs.go.kr/th04/dutyCompeDgn.do

-- NCS 직업기초능력 (10개 영역) - 공통 역량 모델에 추가
INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  -- 직업기초능력 (model_id = 1: 공통 역량)
  (1, '의사소통능력', '문서이해, 문서작성, 경청, 의사표현, 기초외국어 능력'),
  (1, '수리능력', '기초연산, 기초통계, 도표분석, 도표작성 능력'),
  (1, '문제해결능력', '사고력, 문제처리 능력'),
  (1, '자기개발능력', '자아인식, 자기관리, 경력개발 능력'),
  (1, '자원관리능력', '시간관리, 예산관리, 물적자원관리, 인적자원관리 능력'),
  (1, '대인관계능력', '팀워크, 리더십, 갈등관리, 협상 능력'),
  (1, '정보능력', '컴퓨터활용, 정보처리 능력'),
  (1, '기술능력', '기술이해, 기술선택, 기술적용 능력'),
  (1, '조직이해능력', '경영이해, 체제이해, 업무이해, 국제감각 능력'),
  (1, '직업윤리', '근로윤리, 공동체윤리 의식');

-- NCS 24개 대분류별 직무 전문 역량 모델 추가
-- 사업관리 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('사업관리', 'functional', 'NCS 대분류: 사업관리 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '사업관리'), '프로젝트 관리', '프로젝트 계획, 실행, 통제, 종료 능력'),
  ((SELECT id FROM competency_models WHERE name = '사업관리'), '사업기획', '사업 타당성 분석 및 사업계획 수립 능력'),
  ((SELECT id FROM competency_models WHERE name = '사업관리'), '품질관리', '품질 계획 및 품질 보증·개선 능력'),
  ((SELECT id FROM competency_models WHERE name = '사업관리'), '생산관리', '생산 계획, 자재관리, 공정관리 능력');

-- 경영·회계·사무 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('경영·회계·사무', 'functional', 'NCS 대분류: 경영·회계·사무 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '경영·회계·사무'), '전략기획', '경영 전략 수립 및 사업계획 수립 능력'),
  ((SELECT id FROM competency_models WHERE name = '경영·회계·사무'), '재무회계', '재무제표 작성 및 회계감사 능력'),
  ((SELECT id FROM competency_models WHERE name = '경영·회계·사무'), '세무', '세무 신고 및 세무 조정 능력'),
  ((SELECT id FROM competency_models WHERE name = '경영·회계·사무'), '인사관리', '인력계획, 채용, 평가, 보상 관리 능력'),
  ((SELECT id FROM competency_models WHERE name = '경영·회계·사무'), '노무관리', '근로계약, 급여관리, 노사관계 관리 능력'),
  ((SELECT id FROM competency_models WHERE name = '경영·회계·사무'), '총무', '문서관리, 자산관리, 시설관리 능력');

-- 금융·보험 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('금융·보험', 'functional', 'NCS 대분류: 금융·보험 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '금융·보험'), '여신관리', '대출 심사 및 여신 관리 능력'),
  ((SELECT id FROM competency_models WHERE name = '금융·보험'), '자산운용', '포트폴리오 구성 및 투자 전략 수립 능력'),
  ((SELECT id FROM competency_models WHERE name = '금융·보험'), '보험상품개발', '보험상품 설계 및 언더라이팅 능력'),
  ((SELECT id FROM competency_models WHERE name = '금융·보험'), '리스크관리', '금융 리스크 측정 및 관리 능력');

-- 교육·자연·사회과학 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('교육·자연·사회과학', 'functional', 'NCS 대분류: 교육·자연·사회과학 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '교육·자연·사회과학'), '교수설계', '교육 프로그램 설계 및 개발 능력'),
  ((SELECT id FROM competency_models WHERE name = '교육·자연·사회과학'), '교육훈련운영', '교육과정 운영 및 평가 능력'),
  ((SELECT id FROM competency_models WHERE name = '교육·자연·사회과학'), '연구개발', '연구 기획, 수행, 성과 분석 능력'),
  ((SELECT id FROM competency_models WHERE name = '교육·자연·사회과학'), '통계분석', '데이터 수집, 분석, 해석 능력');

-- 보건·의료 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('보건·의료', 'functional', 'NCS 대분류: 보건·의료 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '보건·의료'), '진단검사', '임상병리 검사 및 진단 능력'),
  ((SELECT id FROM competency_models WHERE name = '보건·의료'), '환자관리', '환자 간호 및 치료 보조 능력'),
  ((SELECT id FROM competency_models WHERE name = '보건·의료'), '의료정보관리', '의무기록 관리 및 의료정보 분석 능력'),
  ((SELECT id FROM competency_models WHERE name = '보건·의료'), '보건교육', '건강증진 프로그램 기획 및 운영 능력');

-- 사회복지·종교 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('사회복지·종교', 'functional', 'NCS 대분류: 사회복지·종교 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '사회복지·종교'), '사례관리', '클라이언트 욕구 파악 및 서비스 계획 수립 능력'),
  ((SELECT id FROM competency_models WHERE name = '사회복지·종교'), '프로그램 개발', '사회복지 프로그램 기획 및 평가 능력'),
  ((SELECT id FROM competency_models WHERE name = '사회복지·종교'), '상담', '개인 및 집단 상담 수행 능력');

-- 문화·예술·디자인·방송 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('문화·예술·디자인·방송', 'functional', 'NCS 대분류: 문화·예술·디자인·방송 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '문화·예술·디자인·방송'), '시각디자인', '브랜드 디자인 및 편집디자인 능력'),
  ((SELECT id FROM competency_models WHERE name = '문화·예술·디자인·방송'), '영상제작', '촬영, 편집, 후반작업 능력'),
  ((SELECT id FROM competency_models WHERE name = '문화·예술·디자인·방송'), '콘텐츠 기획', '문화콘텐츠 기획 및 제작 능력'),
  ((SELECT id FROM competency_models WHERE name = '문화·예술·디자인·방송'), 'UX/UI 디자인', '사용자 경험 설계 및 인터페이스 디자인 능력');

-- 영업판매 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('영업판매', 'functional', 'NCS 대분류: 영업판매 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '영업판매'), '고객관계관리', '고객 니즈 파악 및 관계 구축 능력'),
  ((SELECT id FROM competency_models WHERE name = '영업판매'), '제안영업', '제안서 작성 및 프레젠테이션 능력'),
  ((SELECT id FROM competency_models WHERE name = '영업판매'), '유통관리', '유통채널 관리 및 재고관리 능력'),
  ((SELECT id FROM competency_models WHERE name = '영업판매'), '매장관리', '매장 운영 및 상품진열 관리 능력');

-- 건설 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('건설', 'functional', 'NCS 대분류: 건설 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '건설'), '건축설계', '건축 계획 및 설계도서 작성 능력'),
  ((SELECT id FROM competency_models WHERE name = '건설'), '토목설계', '토목구조물 설계 및 시공계획 수립 능력'),
  ((SELECT id FROM competency_models WHERE name = '건설'), '건설시공관리', '공정관리, 품질관리, 안전관리 능력'),
  ((SELECT id FROM competency_models WHERE name = '건설'), '적산', '공사비 산정 및 견적 작성 능력');

-- 기계 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('기계', 'functional', 'NCS 대분류: 기계 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '기계'), '기계설계', '기계요소 설계 및 CAD 도면 작성 능력'),
  ((SELECT id FROM competency_models WHERE name = '기계'), '기계가공', '선반, 밀링, 연삭 등 가공 능력'),
  ((SELECT id FROM competency_models WHERE name = '기계'), '금형설계', '프레스, 사출금형 설계 능력'),
  ((SELECT id FROM competency_models WHERE name = '기계'), '설비보전', '설비 점검, 진단, 정비 능력');

-- 전기·전자 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('전기·전자', 'functional', 'NCS 대분류: 전기·전자 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '전기·전자'), '전기설비설계', '수변전, 배전, 조명설비 설계 능력'),
  ((SELECT id FROM competency_models WHERE name = '전기·전자'), '전자회로설계', '아날로그/디지털 회로 설계 능력'),
  ((SELECT id FROM competency_models WHERE name = '전기·전자'), '반도체제조', '반도체 공정 및 검사 능력'),
  ((SELECT id FROM competency_models WHERE name = '전기·전자'), '임베디드시스템', '마이크로프로세서 프로그래밍 능력');

-- 정보통신 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('정보통신', 'functional', 'NCS 대분류: 정보통신 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '정보통신'), '응용SW개발', '프로그래밍 및 애플리케이션 개발 능력'),
  ((SELECT id FROM competency_models WHERE name = '정보통신'), '시스템SW개발', 'OS, 미들웨어, 임베디드SW 개발 능력'),
  ((SELECT id FROM competency_models WHERE name = '정보통신'), '데이터베이스', 'DB 설계, 구축, 관리 능력'),
  ((SELECT id FROM competency_models WHERE name = '정보통신'), '네트워크구축', '네트워크 설계 및 서버 구축 능력'),
  ((SELECT id FROM competency_models WHERE name = '정보통신'), '정보보안', '보안 시스템 구축 및 취약점 분석 능력'),
  ((SELECT id FROM competency_models WHERE name = '정보통신'), '빅데이터', '데이터 수집, 저장, 분석 능력'),
  ((SELECT id FROM competency_models WHERE name = '정보통신'), '인공지능', 'AI 모델 설계 및 학습 능력');

-- 화학·바이오 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('화학·바이오', 'functional', 'NCS 대분류: 화학·바이오 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '화학·바이오'), '화학제품제조', '화학공정 운전 및 품질관리 능력'),
  ((SELECT id FROM competency_models WHERE name = '화학·바이오'), '바이오실험', '세포배양, 유전자분석 등 실험 수행 능력'),
  ((SELECT id FROM competency_models WHERE name = '화학·바이오'), '의약품제조', 'GMP 기준 의약품 생산 및 품질관리 능력');

-- 환경·에너지·안전 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('환경·에너지·안전', 'functional', 'NCS 대분류: 환경·에너지·안전 분야 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '환경·에너지·안전'), '환경관리', '환경영향평가 및 오염물질 관리 능력'),
  ((SELECT id FROM competency_models WHERE name = '환경·에너지·안전'), '신재생에너지', '태양광, 풍력 등 신재생에너지 설비 운영 능력'),
  ((SELECT id FROM competency_models WHERE name = '환경·에너지·안전'), '산업안전', '위험성 평가 및 안전관리 계획 수립 능력'),
  ((SELECT id FROM competency_models WHERE name = '환경·에너지·안전'), '소방', '화재예방, 소화설비 점검 능력');

-- 마케팅 분야 (영업판매와 별도로 추가)
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('마케팅', 'functional', '마케팅 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '마케팅'), '시장조사', '시장 동향 분석 및 소비자 조사 능력'),
  ((SELECT id FROM competency_models WHERE name = '마케팅'), '브랜드관리', '브랜드 전략 수립 및 포지셔닝 능력'),
  ((SELECT id FROM competency_models WHERE name = '마케팅'), '디지털마케팅', 'SNS, 콘텐츠, 퍼포먼스 마케팅 능력'),
  ((SELECT id FROM competency_models WHERE name = '마케팅'), '광고기획', '광고 전략 수립 및 캠페인 기획 능력');

-- IT 프로젝트 관리 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('IT프로젝트관리', 'functional', 'IT 프로젝트 관리 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = 'IT프로젝트관리'), 'IT 프로젝트 기획', 'IT 프로젝트 범위, 일정, 예산 계획 수립 능력'),
  ((SELECT id FROM competency_models WHERE name = 'IT프로젝트관리'), 'IT 요구사항 분석', '사용자 요구사항 도출 및 분석 능력'),
  ((SELECT id FROM competency_models WHERE name = 'IT프로젝트관리'), 'IT 테스트 관리', '테스트 계획 수립 및 결함 관리 능력'),
  ((SELECT id FROM competency_models WHERE name = 'IT프로젝트관리'), 'IT 서비스 운영', 'IT 서비스 모니터링 및 장애 대응 능력');

-- 데이터 분석 분야
INSERT OR IGNORE INTO competency_models (name, type, description, target_level) VALUES 
  ('데이터분석', 'functional', '데이터 분석 전문 역량', 'specialist');

INSERT OR IGNORE INTO competencies (model_id, keyword, description) VALUES 
  ((SELECT id FROM competency_models WHERE name = '데이터분석'), '데이터 수집', '다양한 소스에서 데이터 수집 및 전처리 능력'),
  ((SELECT id FROM competency_models WHERE name = '데이터분석'), '데이터 시각화', '차트, 대시보드 등 시각화 도구 활용 능력'),
  ((SELECT id FROM competency_models WHERE name = '데이터분석'), '통계분석', '가설검정, 회귀분석 등 통계 기법 활용 능력'),
  ((SELECT id FROM competency_models WHERE name = '데이터분석'), '머신러닝', '예측 모델 개발 및 평가 능력');
