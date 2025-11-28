-- 공통 직무 추가
INSERT INTO jobs (name, description, is_active, sort_order, created_at, updated_at)
VALUES ('공통', '조직 구성원 모두에게 필요한 공통 역량 직무', 1, 200, datetime('now'), datetime('now'));

-- 리더십 직무 추가
INSERT INTO jobs (name, description, is_active, sort_order, created_at, updated_at)
VALUES ('리더십', '조직의 리더에게 필요한 리더십 역량 직무', 1, 201, datetime('now'), datetime('now'));


-- 공통 - 직무윤리 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '직무윤리',
  '평소 원칙과 윤리적 기준에 맞는 행동을 하며, 
청렴한 자세를 견지할수 있는 자세',
  1, 1, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '직무윤리' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '언행일치 및 바람직한 행동양식을 지속적으로 보여주어, 윤리적으로 모범이 된다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '직무윤리' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '투명한 업무체계를 만들기 위해 노력하며, 업무시간/예산/자원을 정직하고 투명하게 활용한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '직무윤리' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '사내 규칙/사규, 업무와 관련된 규정과 기준을 이해하고 있으며 업무수행 시 이를 준수하고 있다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 로열티(Loyalty) 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '로열티(Loyalty)',
  '회사에 대한 로열티(Loyalty)를 갖추고, 
회사생활에 몰입하는 모습',
  1, 2, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '로열티(Loyalty)' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '우리 회사에 대한 Loyalty를 충분히 갖고 있으며, 회사에 대한 자부심을 지니고 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '로열티(Loyalty)' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '평소 ''나의 행동이 회사를 대표한다''는 책임있는 자세를 가지고 있다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '로열티(Loyalty)' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '우리 회사의 비전과 가치를 이해하고 실천하기 위해 노력한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 신뢰형성 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '신뢰형성',
  '구성원들과 원만한 관계를 유지하고 
상호 존중과 신뢰의 조직문화를 추구함',
  1, 3, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '신뢰형성' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '회사 내 구성원들과 원만한 관계를 형성하며, 상호 신뢰감을 가지고 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '신뢰형성' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무적, 인격적으로 회사 내에서 좋은 평판을 유지하고 있다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '신뢰형성' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '존중과 겸손의 자세로 회사 내 구성원들을 대한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 변화주도 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '변화주도',
  '시장 및 환경의 흐름을 읽고 
변화에 민첩하게 대응할 수 있는 능력',
  1, 4, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '변화주도' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '새로운 정보를 꾸준히 탐색하고, 변화하는 시장환경(트렌드)의 흐름을 이해하기 위해 노력한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '변화주도' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '현재 지식 수준에 안주하지 않고, 업무지식 및 기술의 변화를 수시로 파악하고 반영한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '변화주도' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '조직의 변화노력(경영방침 및 조직문화)에 공감하고 함께 참여하고자 노력한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 문제해결능력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '문제해결능력',
  '문제의 내용을 명확히 이해하고, 문제해결을 위한 창의적 방법을 모색하여 해결방안을 제시함',
  1, 5, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '문제해결능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '문제발생 시, 최대한 상황을 객관적으로 바라보고 문제의 핵심을 이해하기 위해 노력한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '문제해결능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '관련 정보간의 상관 관계 및 핵심 고려사항을 분석하여 논리적으로 대안에 접근한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '문제해결능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '해당 문제 및 업무 과제와 관련된 다양하고 창의적인 아이디어를 모색한다.', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 고객지향 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '고객지향',
  '자신의 업무와 관계된 내외부 고객을 인식하고, 
고객의 요구(니즈)에 적절하게 대응함',
  1, 6, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '고객지향' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '고객(내부/외부)과의 미팅/회의 시, 약속 시간에 늦지 않으며 사전 준비(자료준비/일정안내 등)를 충실히 한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '고객지향' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '고객(내부/외부) 대면시 상황에 맞는 복장, 대화, 태도 등 비즈니스 에티겟을 이해하고 있으며 이를 준수하고 있다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '고객지향' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '평소 고객(내부/외부)의 관점에서 생각하며, 간결하고 정확하게 고객이 필요로 하는 정보를 제공한다.', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 업무관리능력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '업무관리능력',
  '업무계획을 수립하고, 이를 효과적으로 
관리함으로써 업무목표를 달성함',
  1, 7, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '업무관리능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무목표와 계획을 체계적으로 수립할 수 있으며, 이를 점검하면서 수행하고 있다.', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '업무관리능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무 우선순위를 파악하고 있으며 일정(시간)관리를 통해, 고객(내/외부)과의 납기를 잘 지키고 있다.', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '업무관리능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무 수행시, 발생할 수 있는 리스크를 미리 파악하고 업무단계에 고려하고 있다.', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 업무커뮤니케이션 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '업무커뮤니케이션',
  '정확한 업무 수명 및 시의적절한 보고를 통해
 효율적으로 업무를 수행함',
  1, 8, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '업무커뮤니케이션' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '관리자(팀리더)의 지시사항과 의도를 정확하게 파악해서 업무에 반영하고 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '업무커뮤니케이션' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '문서 보고 작성 시 본인의 의도를 상대방에게 효과적(통계/차트 활용)으로 전달하고 있다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '업무커뮤니케이션' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '구두 보고 시 전달하고자 하는 내용과 메시지를 간결하게 전달하고 있다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 자기관리 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '자기관리',
  '스스로를 관리할 수 있는 셀프리더십과 
자기개발을 통해 지속적인 성장을 유도함',
  1, 9, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '자기관리' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '평소 자신의 감정 및 스트레스를 건설적인 방법으로 관리함으로써 활력을 유지한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '자기관리' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무영역 뿐만 아니라, 자기개발(독서/강의/네트워크활동 등)을 위한 활동을 꾸준히 하고 있다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '자기관리' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '조직 내 본인의 직무전문성/커리어개발을 위한 목표를 가지고 있다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 프로정신 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '프로정신',
  '주도적이고 적극적인 자세로 업무에 몰입하며, 어떠한 상황에서도 흔들림 없이 업무를 추진하는 
프로 정신을 보여줌',
  1, 10, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '프로정신' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '역할이 주어졌을 때 주도적이고 적극적으로 업무에 임한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '프로정신' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '스스로의 역량과 성장 가능성에 대해 긍정적인 인식과 기대를 가지고 있다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '프로정신' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '어려움이나 장애에 부딪혀도 좌절하지 않고 흔들림없이 업무를 추진해 나간다.', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 협업마인드 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '협업마인드',
  '업무협업 시 적극적이고 수용적인 태도를 통해
조직 목표달성에 기여하고자 함',
  1, 11, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '협업마인드' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '협력 업무와 관련된 이슈에 대하여 요청자/관련 부서와의 사전 공감대를 형성하기 위해 노력한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '협업마인드' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무수행 시 유관부서 및 담당자들에게 필요한 정보를 요청 및 제공하고 있으며, 유기적으로 협력하고 있다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '협업마인드' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '타부서의 업무요청 시, (방어적인 자세가 아닌) 적극적이고 수용적인 태도로 응대한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 의사소통능력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '의사소통능력',
  '관행적인 업무와 행동에 대해 개선점을 찾고자 노력하며,새로운 시도를 통해 차별화된 결과를 창출함',
  1, 12, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '의사소통능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '마음을 열고 상대방의 의견을 적극적으로 경청한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '의사소통능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '상대방의 상황(배경,역할, 기대)에 맞춰 적절한 메시지를 전달하고, 이해시킨다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '의사소통능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '제시하는 의견 및 아이디어가 ''왜 필요하며, 어떤 이익이 있는지'' 명확하게 설명하여 설득력을 높인다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 창의적사고력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '창의적사고력',
  '관행적인 업무와 행동에 대해 개선점을 찾고자 노력하며,새로운 시도를 통해 차별화된 결과를 창출함',
  1, 13, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '창의적사고력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '아이디어를 독창적으로 결합하거나 서로 다른 아이디어를 연결시키는 전혀 다른 종류의 사고를 시도한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '창의적사고력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무 목표달성과 연결될 수 있는 창의적 아이디어/방안을 지속적으로 탐색하고, 제안한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '창의적사고력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '관행적인 업무방식을 점검하고, 새로운 접근방법 및 개선점을 찾고자 노력한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 정보처리능력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '정보처리능력',
  '업무과제에 맞춰 필요한 정보를 수집하고 이를 비교, 분석, 정리하여 효과적 업무추진에 활용할 수 있음',
  1, 14, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '정보처리능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무수행과정에서 발생되는 각종 데이터를 수집, 분류하여 효과적으로 관리할 수 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '정보처리능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '전략 과제나 문제를 이해하기 위해 필요한 정보나 자료를 비교,분석하여 근본적인 요인/맥락을 파악한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '정보처리능력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무를 수행할 때 유의미한 정보를 바탕으로, 그 결과가 조직에 미치는 영향을 분석 및 예측할 수 있다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 업무추진력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '업무추진력',
  '상세한 업무추진 계획과 업무 프로세스에 대한 이해를 바탕으로 차질없이 업무를 완수함',
  1, 15, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '업무추진력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '목표달성에 도움이 되는 자원을 찾고, 장애요인을 예측하여 계획을 수립할 수 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '업무추진력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '수행 업무 역할과 프로세스를 숙지하고 있으며 관련 부서 업무 과업(Task)를 파악하고 있다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '업무추진력' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '수행 업무에 대한 책임감을 가지고, 업무단계 전체에 걸쳐 오류/누락/결함이 없는 업무완수를 위해 노력한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 프리젠테이션스킬 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '프리젠테이션스킬',
  '프리젠테이션(발표 및 보고)상황에서,
전달하고자 하는 내용을 효과적이고 능숙하게 
표현할 수 있는 능력',
  1, 16, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '프리젠테이션스킬' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '자신이 의도한 바가 정확하게 표현되고 전달될 수 있도록 프리젠테이션(발표 및 보고) 할 수 있다.', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '프리젠테이션스킬' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '일관된 흐름을 유지하며, 중언부언하지 않고 간결하게 프리젠테이션(발표 및 보고)할 수 있다.', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '프리젠테이션스킬' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '적절한 비유와 예시를 활용할 수 있으며, 듣는 사람의 반응이나 상황에 맞추어 순발력있게 대응할 수 있다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 업무몰입 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '업무몰입',
  '업무에 몰입함으로써 자신의 목표를 달성해나가고, 주변인에게 긍정적 영향력을 전달할 수 있음',
  1, 17, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '업무몰입' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '과업 및 목표 달성에 대해, 자기 스스로에 대한 강한 의지와 믿음(신념)을 가지고 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '업무몰입' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무에 최대한 몰입할 수 있는 환경을 조성하기 위해 노력한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '업무몰입' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '업무에 몰입함으로써, 자신뿐만 아니라 구성원들(동료 및 후배)의 열정을 불러일으킨다', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 전문성 추구 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '전문성 추구',
  '전문적 지식/스킬 및 글로벌 역량을 습득하고, 
해당 분야 실무자로서 업무 전문성을 끊임없이 개발함',
  1, 18, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '전문성 추구' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '맡은 업무의 전문성을 높여감으로써 담당분야의 전문가(스폐셜리스트)가 되기위해 적극적으로 노력한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '전문성 추구' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '우수한 성과 및 품질/서비스 향상을 위해 도전적 업무과제를 설정하고 이를 달성하기 위해 최선을 다한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '전문성 추구' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '글로벌 역량을 갖추기 위한 관련 전문지식 및 외국어 학습, 네트워크 구축 등 다양한 노력을 기울인다 ', 3, 1, 3, datetime('now'), datetime('now'));

-- 공통 - 파트너십 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '공통'),
  '파트너십',
  '상호협력 및 전략적 관계 구축을 통해
성과향상에 기여하고자 함',
  1, 19, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '파트너십' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '회사 내 이해관련자(혹은 부서)들과 전략/정보/자원 공유활동을 통해 필요시 상호 협력 방안을 모색하고 실행한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '파트너십' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '구성원들, 특히 후배들에게 회사 업무에 필요한 정보 및 자료를 공유해주고 필요시 업무 노하우를 전수해준다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '파트너십' AND job_id = (SELECT id FROM jobs WHERE name = '공통')), '구성원들(동료/후배들)과 업무적/관계적 조화를 이루어 탁월한 업무성과를 창출하기 위해 노력한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 갈등조정능력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '갈등조정능력',
  '조직 내 갈등 상황을 인지하고, 원인을 파악하여
적절하게 갈등을 조정해 나갈 수 있는 능력',
  1, 20, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '갈등조정능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '평소 직급 상.하간(혹은 부서 내/외부)개방적인 의견교류와 솔직한 대화를 통해 갈등의 소지를 최소화 한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '갈등조정능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '부서 내/외부의 갈등상황을 인지하고 갈등의 원인을 밝히기 위해 다각도로 정보를 구한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '갈등조정능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '갈등에 관련된 다양한 사람들이 적절한 합의점을 찾을 수 있도록 촉진자 역할을 한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 협상력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '협상력',
  '부서 내/외부의 다양한 협상과정에서
서로가 윈-윈할 수 있는 협상력을 발휘할 수 있는 능력',
  1, 21, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '협상력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '협상의 쟁점(이슈)을 예상하고 적절한 양보와 타협안을 미리 생각한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '협상력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '나의 제안이 상대의 요구에도 부합한다는 것을 강조하며, 불공평한 요구에 대해서는 명확한 의사표시(문제제기)를 한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '협상력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '협상 과정을 통해 상호간 핵심적인 요구를 충분히 이해하고, 최대한 잡음없이(관계의 손상없이)이견을 조정하는데 집중한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 조직화능력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '조직화능력',
  '목표 및 과업수행 절차/역량을 구체적으로 
조직화하여 시너지를 창출함',
  1, 22, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '조직화능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '팀(부서)단위 목표 및 과제의 우선순위를 정할 수 있고, 현재와 미래의 상황을 예측하여 구체적인 실행계획을 구성할 수 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '조직화능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '팀(부서)과업의 목적, 범위, 절차를 결정하고, 과업 수행에 필요한 구성원의 역량을 통합 및 조정 할 수 있다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '조직화능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '업무의 상호 연계성을 잘 파악하고 있으며, 각 업무간 가장 효율적인 연계(사람 및 조직)를 통해 시너지를 만들어내고 있다.', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 성과관리 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '성과관리',
  '성과 및 목표달성을 위해 필요한 환경을 마련하고 목표달성 과정을 체계적으로 점검하고 관리함',
  1, 23, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '성과관리' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '목표를 달성할 수 있도록 끝까지 추진하며, 그 과정에서 조직간에 발생하는 크고 작은 문제들을 조정하고 원칙을 제시한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '성과관리' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '객관적 지표를 활용하여 목표 달성 여부에 대해 지속적으로 점검한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '성과관리' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '목표달성을 위해 구성원들의 역할을 명확히 인식시키고, 목표달성에 집중할수 있도록 적극적으로 지원한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 회의진행스킬 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '회의진행스킬',
  '회의시 효과적으로 결론을 창출하기 위한 회의 진행 능력',
  1, 24, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '회의진행스킬' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '회의 시간 내 목표한 결론을 도출해내기 위해 필요한 회의 방법 및 진행 역량을 갖추고 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '회의진행스킬' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '회의 시간에 참석자 누구나 자신의 의견을 자유롭게 발언할 수 있고, 이를 경청해주는 분위기를 조성한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '회의진행스킬' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '회의 결과와 실행에 대한 동의를 이끌어 내기 위해 노력하며, 회의결과를 종합하고 사후관리계획을 수립한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 팀빌딩 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '팀빌딩',
  '구성원(팀원) 상호 간 이해와 협동을 촉진하여 시너지를 극대화하고 공동의 목표를 달성하기 
위한 최적의 팀(부서)환경을 구축함',
  1, 25, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '팀빌딩' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '팀(부서)구성원들이 업무 수행 과정에서 서로의 전문성과 경험 등을 적극적으로 공유하여 최선의 결과를 도출하도록 이끈다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '팀빌딩' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '위기의 상황이나 문제 상황에 봉착했을 때, 팀(부서)원들이 더욱 협력하여 어려움을 이겨내는 강한 팀정신을 가지고 있다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '팀빌딩' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '팀(부서)구성원들은 팀(부서)공동의 목표를 인식하고 있으며, 이를 달성하기 위한 각자의 역할 및 업무를 충실히 수행하고 있다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 권한위임 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '권한위임',
  '구성원(팀원)에게 도전적 업무기회를 부여하여 업무 성취도를 높이며, 구체적이고 적절한 권한위임으로 구성원의 성장을 지원함',
  1, 26, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '권한위임' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '구성원(팀원)에게 추가적인(도전적인) 업무책임 및 권한을 부여함으로써, 구성원(팀원)에 대한 신뢰를 보여주고 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '권한위임' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '의사결정의 권한, 요구행동, 범위와 한계와 같은 구체적 지표를 명확히 하여 업무 책임을 적임자에게 할당한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '권한위임' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '업무를 맡김과 동시에 구성원(팀원)이 맡은 바 일을 성공적으로 수행하는데 필요한 것은 충분히 제공하고 있다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 육성/코칭 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '육성/코칭',
  '인재육성의 관점에서 지속적, 효과적인 
피드백을 실시하고, 성과개선 및 역량강화를 
촉진함',
  1, 27, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '육성/코칭' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '구성원(팀원)의 업무수행 과정 및 결과에 대해 적절한 피드백(칭찬과 격려, 개선점 등)을 제시하여 역량강화를 이끌어 낸다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '육성/코칭' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '코칭을 통해, 구성원(팀원)의 성과개선을 위한 장애요인의 제거방안 및 필요 지원사항 등을 제시한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '육성/코칭' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '구성원(팀원)육성을 위한 지속적인 점검 및 피드백 과정을 준수하며, 조직에 필요한 역량을 육성 계획에 반영해서 실행한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 동기부여 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '동기부여',
  '먼저 행동으로 모범을 보임으로써 
구성원들이 믿고 따르게 하며, 목표달성을 위한 몰입과 지지를 이끌어 낼 수 있음',
  1, 28, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '동기부여' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '자신을 먼저 개발 및 변화시키는 노력을 통해, 구성원(팀원)의 경력개발의욕과 열정을 불러 일으킨다.', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '동기부여' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '구성원(팀원)들에게 목표 달성에 따른 긍정적 결과를 강조하고 자신감, 성취욕, 경쟁의식 등을 북돋워주고 있다.', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '동기부여' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '구성원(팀원)들의 지지와 몰입을 이끌어 내고, 자발적 행동으로 옮기도록 동기부여 할 수 있다.', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 전략적사고능력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '전략적사고능력',
  '각종 전략의 수립 배경과 내용을 명확히 이해하고, 이와 연계된 상하위 조직의 전략 목표를 정확히 파악하여 전략적 일관성을 강화함',
  1, 29, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '전략적사고능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '장기적 목표나 비전을 달성하기 위해 선택 가능한 행동을 고려하여 비용, 효과, 위험, 타이밍 등의 요소를 전략계획에 반영한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '전략적사고능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '중장기 전략 관점에서 성공요인을 파악하고, 경쟁우위 전략(우선순위 및 선택과 집중)을 확정한다 ', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '전략적사고능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '전사 전략 및 사업방향을 명확히 이해하고 있으며, 하위 및 관련 담당조직 계획과 연계시킬 수 있다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 의사결정능력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '의사결정능력',
  '조직에서 발생하는 문제를 신속하고 정확하게 파악하고, 결단력 있게 의사결정을 할 수 있는 역량',
  1, 30, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '의사결정능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '과제 또는 문제의 관련성과 인과관계를 파악하기 위해 다양한 정보를 수집하고 분석함으로써, 의사결정의 근거로 활용한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '의사결정능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '중요 의사결정시점을 놓치거나 미루지 않고, 적시에 의사결정 한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '의사결정능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '복잡하고 중요한 사안에 대하여 전문적 지식과 경험을 바탕으로 신속, 정확한 판단을 내린다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 시장대응력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '시장대응력',
  '국내/외 시장에서 일어나는 변화를 민감하게 파악하고, 해당사업과의 연계를 통해 새로운 사업기회를 탐색함',
  1, 31, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '시장대응력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '국내/외 시장환경 및 동종업계(경쟁사)의 변화 이슈에 대해 지속적으로 파악하고 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '시장대응력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '새로운 사업을 발굴하기 위해, 회사 내/외부 정보 수집 및 네트워크를 적극적으로 활용한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '시장대응력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '새로운 사업의 성공요소 및 진행 여부를 결정하기 위한 명확한 판단 기준을 가지고 있다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 자원배분및관리능력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '자원배분및관리능력',
  '사업수행을 위해 필요한 자원(예산/인력/기술)을 확보하고 효율적으로 배분 및 관리할 수 있음',
  1, 32, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '자원배분및관리능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '사업수행을 위한 필요 자원(예산/인력/기술)계획을 수립하고, 회사 내/외부적으로 필요 자원을 충분히 확보한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '자원배분및관리능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '명확한 기준과 원칙을 가지고 자원을 배분하며, 최적의 자원 배분으로 누락/낭비를 최소화한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '자원배분및관리능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '투입된 자원의 활용 과정을 주기적으로 점검하고 비효율적인 부분은 개선한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 비전공유 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '비전공유',
  '조직의 미래비전을 수립하고 구성원들에게 정확히 전달하여 이해시키고 현업에서 실천할 수 있도록 내재화 함',
  1, 33, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '비전공유' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '회사와 구성원 모두가 성장할 수 있다는 확신을 기반으로, 사업/시장/경쟁 환경을 감안한 조직(부서)의 미래상(비전)을 제시한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '비전공유' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '비전 달성을 위해 자신과 구성원들에게 요구되는 역할과 책임을 정의하고, 명확히 공유한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '비전공유' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '행동기준과 실천방안 제시를 통해 구성원들이 비전 실현을 위해 해야 하는 활동을 항상 인식할 수 있도록 한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 혁신추구 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '혁신추구',
  '구성원들이 새로운 시도와 창의적 아이디어를 
자유롭게 실행할 수 있도록 혁신추구의 환경을 
조성함',
  1, 34, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '혁신추구' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '새로운 아이디어나 개선방안에 대해 적극적으로 지원하고, 실패에 관대한 환경을 조성한다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '혁신추구' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '창의적인 아이디어/방안이 회사의 전략, 목표달성에 어떻게 기여하는지 구체적으로 제시하고 장려한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '혁신추구' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '변화의 과정과 결과를 조직 전체로 전파시켜, 긍정적 조직문화로 이어지도록 노력한다', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 핵심인재육성 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '핵심인재육성',
  '중장기적 관점에서 인재확보 및 인재육성을 위한지원방안을 체계화함',
  1, 35, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '핵심인재육성' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '인재의 중요성을 인지하고, 조직의 핵심인재에 대한 명확한 기준을 설정하고 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '핵심인재육성' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '재량권 범위 내에서 직무과제나 책임사항을 위임하여 구성원들의 역량을 강화할 수 있는 기회를 제공한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '핵심인재육성' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '중장기적 인재육성의 관점에서, 구성원들의 경력개발을 체계적으로 지원한다(예:직무(업무)순환 및 자기개발 지원 등)', 3, 1, 3, datetime('now'), datetime('now'));

-- 리더십 - 네트워킹능력 역량
INSERT INTO competencies (job_id, name, definition, is_active, sort_order, created_at, updated_at)
VALUES (
  (SELECT id FROM jobs WHERE name = '리더십'),
  '네트워킹능력',
  '대/내외 다양한 네트워크 구축 활동을 통해 
조직의 목표 달성에 필요한 정보, 자원 등을 획득할 수 있음',
  1, 36, datetime('now'), datetime('now')
);

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number, is_active, sort_order, created_at, updated_at) VALUES
  ((SELECT id FROM competencies WHERE name = '네트워킹능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '사업과 관련하여 정보 교환 및 도움을 받을 수 있는 대/내외 네트워크를 형성하고 있다', 1, 1, 1, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '네트워킹능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '회사 내/외부 전문가들과 주기적인 소통(세미나, 방문, 전화, 회의 등)을 통해 관계를 유지한다', 2, 1, 2, datetime('now'), datetime('now')),
  ((SELECT id FROM competencies WHERE name = '네트워킹능력' AND job_id = (SELECT id FROM jobs WHERE name = '리더십')), '문제나 이슈가 발생할 때 내/외부 네트워크를 활용하여, 관련 정보를 신속히 확보하고 전문가의 적절한 도움을 받는다', 3, 1, 3, datetime('now'), datetime('now'));