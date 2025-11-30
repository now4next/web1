-- Add PM competencies to production DB
-- Generated from: (PM역량)직무.역량.역량정의.행동지표.xlsx

-- Add PM관리 job
INSERT OR IGNORE INTO jobs (name, description) VALUES ('PM관리', 'PM관리 역량');

-- Add PM리더십 job
INSERT OR IGNORE INTO jobs (name, description) VALUES ('PM리더십', 'PM리더십 역량');

-- Add PM competencies and behavioral indicators
-- 개인.조직 이슈 해결을 위한 프로젝트 객관성
INSERT INTO competencies (job_id, name, definition)
SELECT id, '개인.조직 이슈 해결을 위한 프로젝트 객관성', '프로젝트 운영을 위한 조직 프레임워크를 존중하고, 개인의 이익과 조직의 이익 사이에서 균형을 맞추며, 편견 없이 팀원에게 적절한 업무를 객관적으로 배정하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '개개인이 조직에서 프로젝트관리자에게 부여된 특권을 인정하고 있다는 이해관계자들로부터의 문서화된 피드백, 프로젝트관리자들이 협동의 규칙을 따르며 프로젝트의 프로그램과 포트폴리오 내에서 보고하고 있다는 이해관계자들로부터의 문서화된 피드백 등을 통해 프로젝트를 운영하기 위한 조직의 프레임워크를 존중하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '개인.조직 이슈 해결을 위한 프로젝트 객관성';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '개개인이 개인과 조직의 이해관계 내에서 선명한 차이를 보았다는 이해관계자로부터의 문서화된 피드백, 개인이 PMI의 전문적 행동코드에 따른다는 이해관계자로부터의 문서화된 피드백 등을 통해 조직의 이해 내에서 개인의 이해의 균형을 맞추고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '개인.조직 이슈 해결을 위한 프로젝트 객관성';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀원들의 강점과 약점을 지적하는 기술평가문서, 팀원들의 기술평가와 더불어 책임 할당 매트릭스 (RAM, Responsibility Assignment Matrix), 개개인들이 현재상황보다 더 잘 하도록 진전되도록 개인적 일의 할당을 한 사례 등을 통해 편향되지 않는 방식으로 팀원들에게 적절한 과제를 할당하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '개인.조직 이슈 해결을 위한 프로젝트 객관성';

-- 적절한 방식으로 개인.팀 프로젝트 어려움 대처
INSERT INTO competencies (job_id, name, definition)
SELECT id, '적절한 방식으로 개인.팀 프로젝트 어려움 대처', '모든 상황에서 자기통제를 유지하고 도전에 침착하게 대응하며, 부족함을 인정하고 실패에 대해 명확히 책임을 지며, 과거 실패로부터 학습하여 향후 수행을 개선하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, 'PM이 강한 감정(분노나 극도의 좌절)을 느끼지만 그것들을 통제한 사례들, 대응을 통제하고 감정폭발을 예방하고 지속적 스트레스를 다루는 스트레스 관리 기술을 사용, 개개인이 자기통제를 보여준다는 이해관계자들로부터의 문서화된 피드백을 통해 모든 상황에서 자기통제를 유지하고 차분히 대응하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '적절한 방식으로 개인.팀 프로젝트 어려움 대처';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '개개인이 건설적 피드백을 능동적으로 경청하고 그에 따라 행동하고 있다는 이해관계자로부터의 문서화된 피드백, 개개인이 실패에 대한 책임을 인정한 사례들을 통해 부족함을 인정하고 실패에 대한 책임을 명료하게 인정하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '적절한 방식으로 개인.팀 프로젝트 어려움 대처';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '습득된 교훈을 문서화,  개개인이 실수로부터 교훈을 얻었다고 언급하는 이해관계자로부터의 문서화된 피드백,  개개인이 실패와 실수의 원인을 이해하기 위해 자신의 성과 분석 사례 등을 통해 미래의 성과를 개선하기 위해 실패로부터 배우고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '적절한 방식으로 개인.팀 프로젝트 어려움 대처';

-- 적절한 프로젝트관리 도구/기법 활용
INSERT INTO competencies (job_id, name, definition)
SELECT id, '적절한 프로젝트관리 도구/기법 활용', '사용 가능한 프로젝트관리 도구 및 기법을 이해하고, 적절한 것을 선정하며, 프로젝트관리 업무에 효과적으로 적용하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이용 가능한 도구와 기법의 목록 등을 통해 PM도구와 기법을 이해하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '적절한 프로젝트관리 도구/기법 활용';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '택된 도구와 기법의 목록, 프로세스의 결과에 대한 선택 문서화 등을 통해 적절한 도구와 기법을 선택하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '적절한 프로젝트관리 도구/기법 활용';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '도구와 기법의 사용을 통해 획득된 결과들을 통해 선택된 도구와 기법을 프로젝트관리에 적용하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '적절한 프로젝트관리 도구/기법 활용';

-- 조직화된 방식의 프로젝트 계획.관리
INSERT INTO competencies (job_id, name, definition)
SELECT id, '조직화된 방식의 프로젝트 계획.관리', '프로젝트 범위·역할·기대·업무를 명확히 식별하기 위해 타인과 협업하고, 일반적으로 인정된 프로젝트관리 관행을 식별·준수·조정하며, 적절한 세부 수준으로 프로젝트 정보를 조직하고, 프로세스·절차·정책의 준수를 지속적으로 보장하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '계획 프로세스 속에서 다른 사람들의 개입의 수준에 관한 문서화된 피드백 등을 통해 프로젝트 영역, 역할, 기대 그리고 과제 특화를 선명하게 식별하기 위해 다른 사람들과 작업하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '조직화된 방식의 프로젝트 계획.관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '일반적으로 수용된 실행에 관해 프로젝트 팀, 이해관계자들 그리고 어떤 주제의 전문가들로부터의 피드백 그리고 사례들, 프로젝트관리 기관 (PMI)에서의 멤버쉽, 특화된 흥미 그룹 (SIGs), 워크샵, 회홥, 혹은 조직들, 일반적으로 수용된 실행들을 달성하고 능가하기 위해 의도되었던 , 제안된 측정과 개선,  산업기준을 통합하는 프로젝트 계획 등을 통해 조직 혹은 산업기준 그리고 일반적으로 수용된 실행들을 프로젝트에 적용하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '조직화된 방식의 프로젝트 계획.관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '일반적으로 수용된 실행들에 대한 문서화된 변경, 일반적으로 인정된 실행들을 수용하기 위해 프로젝트관리 절차에서의 승인된 변경들을 통해 프로젝트의 성공적인 완수를 위해 일반적으로 수용된 실무들을 테일러링하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '조직화된 방식의 프로젝트 계획.관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트에서 사용되는 기준 방법론의 사례들, 회의록, 프로젝트 상황 보고서 혹은 갱신(Update), 프로젝트 결과물 저장소, 지식관리의 사례들을 통해 적절한 수준의 세부사항을 강조하면서 프로젝트 정보를 조직화하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '조직화된 방식의 프로젝트 계획.관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로세스, 절차, 정책의 조화를 감시(감시(모니터링)), 정책과 절차를 강제하는 사례들, 로젝트를 관리하기 위해 성과 척도(Metrics, 측정기준) 사용의 문서화 등을 통해 프로세스, 절차, 정책들과의 부합을 지속적으로 수행하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '조직화된 방식의 프로젝트 계획.관리';

-- 청렴한 프로젝트 운영
INSERT INTO competencies (job_id, name, definition)
SELECT id, '청렴한 프로젝트 운영', '모든 법적 요구사항을 준수하고, 인정된 윤리 표준 내에서 운영하며, 이해관계자 간 잠재적 이해충돌을 적극적으로 회피·해결하고, 민감한 정보의 기밀성을 존중·유지하며, 타인의 지적재산을 존중하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '모든 합법적 요구들이 충족되었다는 이해관계자로부터의 피드백, 이해관계자의 승인이 쓰여있는 프로젝트에 적용된 합법적 요구에 관한 문서화된 등록부(Log, 대장) 등을 통해 모든 합법적 요구들을 고수하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '청렴한 프로젝트 운영';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, 'PM이 모델로 삼은 윤리적 기준들이 적용되었음을 언급하는 이해관계자로부터의 문서화된 피드백,   PM이 이해관계자로부터 부적절한 보수를 받지도 않았으며 다른 아이템을 받지도 않았음을 알리는 이해관계자로부터의 문서화된 피드백 등을 통해 인정된 일련의 윤리적 기준 내에서 일을 하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '청렴한 프로젝트 운영';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해들에 관한 잠재적 갈등에 대한 진실된 보고의 사례들, 조직적인 이해 갈등 (Organizational Conflict of Interest : OCI) 진술 및 OCI에 대한 대응 계획 등을 통해 모든 이해관계자의 이해에서의 가능한 갈등들을 피하고 해결할 것을 추구하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '청렴한 프로젝트 운영';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '개개인이 기밀유지를 잘 유지하고 있다고 하는 이해관계자로부터의 문서화된 피드백, 기밀유지 혹은 보안수준 분류 통지를 포함하는 프로젝트 문서화의 사례들을 통해  민감한 정보에 관하 기밀유지를 존중하고 유지하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '청렴한 프로젝트 운영';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '보호되는 지적 자산을 재사용하기 위한 문서화된 합의, 잠재적으로 적용 가능한 특허, 트레이드마크, 저작권들을 위한 문서화된 조사, 보호되는 지적 자산이 사용될 때 마다 원천에 대한 지적을 하는 저작권 통지의 사례들을 통해 다른 사람들의 지적 자산을 존중하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '청렴한 프로젝트 운영';

-- 프로젝트 결과 개선 및 기회 추구
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 결과 개선 및 기회 추구', '기회와 이슈 목록을 관리하고, 프로젝트 가치와 성과를 개선할 신규 기회를 식별하며, 발생하는 적절한 기회를 포착하고, 이를 공고히 하여 조직에 의사소통하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '목록을 갱신(Update)시키기 위해 명백히 의사소통된 프로세스와 함께 모든 팀원들에게 나누어진 기회와 관심사 그리고 이슈들의 목록, 현재의 이슈 등록부(Log, 대장)를 유지하고 모든 이해관계자에게 그 안의 변경과 추가사항에 대한 의사소통 문서, 접근 내용이 문서화되고 해결책이 식별되며 이슈들이 알려지는 회합상의 정리 노트, 제안된 행동과 얻어진 결과 사이의 비교 등을 통해 기회와 관심사들을 알리기 위해 프레임워크를 제공하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 결과 개선 및 기회 추구';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '새로운 기회가 확인되는 회합이나 브레인스토밍 과정에서 나오는 기회를 보여주는 리스크 등록부(Log, 대장), 얻어진 결과에 연관된 프로젝트 내에서 취해진 행동 혹은 프로젝트에서의 제안들의 문서화 등을 통해 프로젝트 가치와 실행을 개선하기 위해 기회를 찾고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 결과 개선 및 기회 추구';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '기회들이 분석된 회합 정리노트, 통제 프로세스에서의 entries, 프로젝트의 진화 과정에서 기회들이 나타나는 순간과 관련한 기회사례들을 통해  기회가 나타날 때 적절한 기회를 잡고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 결과 개선 및 기회 추구';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 기회에 관한 이메일, 회합 정리노트 그리고 다른 의사소통 내용물, 식별된 기회들을 추구하기 위해 부가된 가치를 알려주면서 고객 혹은 내적 이해관계자에게 제안을 문서화, 다수의 기회들이 식별되고 추구되고 있음 등을 통해 기회를 공고히 하고 그것들을 조직에 전달하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 결과 개선 및 기회 추구';

-- 프로젝트 고성과 창출 팀 환경 구축
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 고성과 창출 팀 환경 구축', '긍정적인 팀 기대를 표현하고, 팀 학습과 전문성 개발을 촉진하며, 팀워크와 다양한 관점 존중을 지속적으로 독려하고, 개인적 책임을 통해 고성과 역할 모델로 행동하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀원들의 능력을 인정에 대한 문서화된 피드백, 결정한 것을 후원에 대한 문서화된 피드백, 긍정적 기대치를 설정에 대한 문서화된 피드백 등을 통해 긍정적인 팀의 기대치를 표현하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 고성과 창출 팀 환경 구축';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '개인 개발 계획, 개발을 위한 재원확보, 프로젝트 팀으로부터의 문서화된 피드백, 팀원에 의해 습득된 새로운 기술의 문서화 등을 통해  팀 학습을 증진시키고 전문적 및 개인적 개발을 옹호하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 고성과 창출 팀 환경 구축';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀웍과 다른 선택이나 성격들에 대한 존중을 장려하기 위해 취해진 창의적 행동들의 사례들, 독특한 기술과 능력들의 인정에 관한 문서화된 피드백 선명하고 지속적인 목표들 속에 팀 지도자들의 확인된 책임성 등을 통해 팀워크를 지속적으로 장려하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 고성과 창출 팀 환경 구축';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '개인적 성과와 특질에 대한 문서화된 표준, 기준에 맞춰 프로젝트 매니저가 수행한 결과들에 대한 문서화, 프로젝트관리가 역할모델로서 행동하고 있다는 문서화된 피드백, 그들이 위임한 것들에 대해 프로젝트 매니저들이 책임이 있음을 주장하는 사례들을 통해  높은 성과를 요구하고 사례화하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 고성과 창출 팀 환경 구축';

-- 프로젝트 니즈에 맞춘 속도 조절
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 니즈에 맞춘 속도 조절', '부정적 영향을 최소화하기 위해 프로젝트 환경 변화에 적응하고, 유익한 변화를 추구하는데 유연성을 보이며, 기회 포착과 문제 해결을 위해 선제적 조치를 취하고, 지속적 학습을 독려하여 변화에 편안한 환경을 조성하며, 변화 에이전트로 행동하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '개인들이 변경에도 불구하고 할 수 있다는 태도를 보이고 있다고 언급을 하는 이해관계자로부터의 문서화된 피드백,  문서화된 리스크 완화 활동들을 통해  잘못된 프로젝트 영향을 최소화시키기 위해 프로젝트 환경에서의 변경에 적응하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 니즈에 맞춘 속도 조절';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '새로운 기회를 식별하면서 리스크 등록 갱신(Update) , 문서화된 기회분석 변경 요구들을 통해 프로젝트에 이득이 되는 변경을 향하여 유연성을 보이고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 니즈에 맞춘 속도 조절';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트관리자가 행동지향성을 가지고 사전행동적 접근을 하고 있다고 언급하는 이해관계자로부터의 문서화된 피드백, 프로젝트관리자가 뚜렷한 문제를 해결한 사례들, 프로젝트 실행 과정에서 사용된 기술, 기능 혹은 방법들에 관한 적절한 문서를 가지고 프로젝트 라이브러리를 작성 등을 통해 기회를 포착하고 현재의 문제들을 풀기 위해 긍정적인 활동들을 하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 니즈에 맞춘 속도 조절';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀원들을 위한 문서화된 훈련 추천서, 프로젝트 스케줄이 팀원들이 새로운 해결책과 상황 혹은 기술들을 연구하도록 할 수 있는 시간을 포함시키고 있음, 프로젝트 실행 동안에 사용된 새로운 기술, 기능, 혹은 방법들의 적절한 문서를 가지고 프로젝트 라이브러리를 작성 등을 통해 지속적인 학습을 장려함으로써 변경에 익숙한 환경을 가능하게 하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 니즈에 맞춘 속도 조절';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트관리자에 의해 용이해지고 시행된 변경에 관한 이해관계자로부터의 문서화된 피드백, 프로젝트관리자가 긍정적인 자기존중과 자기 확신을 보여주었다고 언급한 이해관계자로부터의 문서화된 피드백, 변경 수행자(Agent)로서 행동하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 니즈에 맞춘 속도 조절';

-- 프로젝트 다양한 구성원 인력 관리
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 다양한 구성원 인력 관리', '프로젝트 환경 내에서 신뢰와 존중의 요소를 개발하고, 팀과 이해관계자의 문화적 이슈·법적 요구사항·윤리적 가치를 준수하며, 개인적·윤리적·문화적 차이를 존중하고 신뢰하는 환경을 조성하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, 'PM이 문화적 차이를 수용하기 위한 의지, 존중, 인식을 보여주었다는 팀으로부터의 문서화된 피드백,  팀이 성취를 기념한 사례 등을 통해 프로젝트 환경 속에서의 신뢰와 존중의 Element들을 개발하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 다양한 구성원 인력 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '윤리적 기준과 이해관계자들의 가치 체계를 묘사하는 것의 문서화, 지속적으로 좋은 도덕적 판단과 행동을 한 사례들, 프로젝트에 관련된 적용 가능한 합법성, 기준, 지역적 관습들에 대한 문서화된 분석 등을 통해 팀의 문화적 이슈, 합법적 요구, 그리고 윤리적 가치를 고수함을 확실히 하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 다양한 구성원 인력 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, 'PM이  개인적 윤리적 문화적 차이에 대한 존중을 보여주었다는  팀으로부터의 문서화된 피드백, PM이 각각의 팀원의 공헌을 인정한 사례 등을 통해 개인적, 윤리적 그리고 문화적 차이에 대해 존중을 하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 다양한 구성원 인력 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, 'PM이  개개인의 차이를 존중하고 있다는 신뢰를 보여주는 팀으로부터의 문서화된 피드백 PM이 다른 사람들이 최선을 다할 수 있도록 동기부여하고 격려하는 조건을 만들었다는 사례 등을 통해 개개인의 차이를 존중하고 신뢰를 보여주는 환경을 만들고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 다양한 구성원 인력 관리';

-- 프로젝트 문제 해결
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 문제 해결', '기능적 문제를 해결하기 위해 적절한 자원을 활용하고, 제안된 해결책이 문제를 효과적으로 다루고 프로젝트 범위 내에 있음을 증명하며, 프로젝트 편익을 극대화하고 부정적 영향을 최소화하는 해결책을 선정하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 필요성 분석(예를 들어 디자인 입력 목록), 기능문제에 관해 이해관계자들로부터의 문서화된 피드백,  해결 문서화와 더불어 적절한 지식 관리 도구 이슈등록부(Log, 대장)를 사용하는 것에 대한 문서화 등을 통해 기능문제를 해결하기 위해 적절한 문제를 활용하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 문제 해결';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '적절한 지식관리 도구의 문서화된 사용, 대안이 문서화된 이슈 등록부, 문제가 해결되었다는 이해관계자로부터의 문서화된 피드백 등을 통해 제안된 해결책이 문제를 해결하고 프로젝트 영역 내에 있다는 것을 입증하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 문제 해결';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문제가 해결되었음을 언급하는 이해관계자로부터의 문서화된 피드백, 프로젝트에서의 해결책의 영향에 대한 문서화, 해결책에 대한 외적 혹은 환경적 영향의 문서화  등을 통해 프로젝트 이익을 극대화시키고 부정적 영향을 최소화시키는 해결책을 선택하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 문제 해결';

-- 프로젝트 영향력
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 영향력', '개별 이해관계자에게 맞춤화된 적절한 영향력 기법을 적용하고, 개인적 이익이 아닌 프로젝트를 위해 제3자나 전문가를 활용하여 타인을 설득하고 지원을 얻는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '다른 경우들에 대한 다른 스타일의 사례들, 영향을 주기 위해 사용되는 대안적 접근을 묘사하는 것을 문서화하고 있음, 강한 융통성과 협상 기량의 사례들, 교육을 시킬 능력의 사례들을 통해 각각의 이해관계자들에게 영향력 있는 적절한 기술을 적용하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 영향력';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '영향을 주기 위해 다른 사람들의 위치, 힘을 사용한 사례들, 영향을 주기 위해 제 3자의 지식을 활용한 사례들, 개인적 획득을 위해 조작되는 것이 아니라 프로젝트의 후원을 위해 모이고 네트워킹하는 사례들을 통해 다른 사람들을 설득하기 위해 제 삼자 혹은 전문가를 활용하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 영향력';

-- 프로젝트 의사소통 관계 유지
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 의사소통 관계 유지', '이해관계자를 선제적으로 포함시키고, 다양한 채널을 통해 정보를 효과적으로 배포하며, 공식적·비공식적 의사소통 채널을 유지하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자들의 욕구들이 전향적으로 충족되었음에 대한 문서화된 확인 등을 통해 이해관계자들을 전향적으로 포함시키고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 의사소통 관계 유지';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '의사소통이 대화, 조사, 통지, 프리젠테이션 혹은 관찰을 통해서 효과적이었다라는 것을 문서화, 타당하고 시의적절한 의사소통이 적절한  이해관계자와 공유되었음을 문서화 등을 통해  정보를 효과적으로 퍼지게 하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 의사소통 관계 유지';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '계획되거나 계획되지 않은 회합, 브레인스토밍 과정 등에서 나온 회의록, 서신교환토론에서 나온 통지사항 및 추가 이행사항 등을 통해 공식적, 비공식적 의사소통을 유지하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 의사소통 관계 유지';

-- 프로젝트 이해관계자 경청.이해.대응
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 이해관계자 경청.이해.대응', '적극적으로 경청하고, 명시적·암묵적 의사소통 내용을 포괄적으로 이해하며, 이해관계자의 기대·우려·이슈에 반응적으로 행동하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자들로부터 결과에 대해 조사, 의사소통으로부터 문서화된 관찰, 다른 관점에 대한 수긍과 이해에 대한 문서화된 피드백 등을 통해 능동적으로 청취하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 이해관계자 경청.이해.대응';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '의사소통으로부터 문서화된 관찰, 메세지가 받아들여졌고 이해되었다는 문서화된 확인 등을 통해 의사소통의 외적으로 명료한 그리고 내포적인 내용들 모두를 이해하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 이해관계자 경청.이해.대응';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '다른 사람들에게 중요한 이수들에 대한 문서화된 대응 (예를 들어 이슈 등록부) 등을 통해 기대와 관심 그리고 이슈에 관해 대응하고 행동하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 이해관계자 경청.이해.대응';

-- 프로젝트 이해관계자 참여.동기부여.지원 유지
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 이해관계자 참여.동기부여.지원 유지', '이해관계자와 의사소통하여 동기를 유지하고, 이해관계자 욕구를 충족하기 위해 프로젝트 상태와 방향을 전달하는 기회를 모색하며, 전문가를 토론에 참여시켜 이해관계자 지원과 영향을 얻고, 객관성을 활용하여 합의를 구축하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자 분석을 위한 의사소통계획 갱신(Update), 그들이 동기부여 되었음을 언급하는 이해관계자로부터의 문서화된 피드백 등을 통해  이해관계자의 동기부여를 유지하기 위해 이해관계자와의 의사소통을 하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 이해관계자 참여.동기부여.지원 유지';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '개개인이 상태에 대해 의사소통할 기회를 가지고 있다는 사례들, 어떻게 그들의 필요가 충족되었는지에 관한 이해관계자로부터의 문서화된 피드백 등을 통해 이해관계자의 필요와 기대치를 충족시키기 위해 프로젝트 상태와 방향을 의사소통할 기회를 지속적으로 추구하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 이해관계자 참여.동기부여.지원 유지';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '다른 이슈들에 대해 어떻게 합의와 후원이 얻어졌는지에 관한 사례들, 주제에 관한 전문가들이 이해관계자와의 상담에 초빙되었던 미팅에 대한 세부사항들을 통해 이해관계자의 후원을 얻고 영향을 주기 위해 토론과 미팅에서 전문가를 포함시키고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 이해관계자 참여.동기부여.지원 유지';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀결정을 하기 위해 최고의 실행을 사용한 것에 대한 문서화, 왜곡된 팀원들에 대해 객관적 위치를 지향하도록 영향을 미친 사례들을 통해 합의 구축을 위해 객관성을 활용하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 이해관계자 참여.동기부여.지원 유지';

-- 프로젝트 정보 품질 보장
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 정보 품질 보장', '적절한 정보 출처를 사용하고, 정확하고 사실적인 정보를 제공하며, 정보의 타당성을 추구하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '자료와 분석의 문서화, 문서화된 자료에 대한 피드백 등을 통해 적절한 정보의 자료를 사용하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 정보 품질 보장';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '사실적 정보가 제공되고 있음을 보여주는 문서들, 정보의 정확성에 대한 문서화된 피드백 등을 통해 정확하고 실질적인 정보를 제공하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 정보 품질 보장';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '주제 문제 전문가에게서 입력된 내용의 문서화 (예를 들어, 흥미그룹, 전문적 집단 등), 미팅 세부사항 등을 통해 정보의 유효성을 추구하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 정보 품질 보장';

-- 프로젝트 책임.권한위임
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 책임.권한위임', '프로젝트에 대한 헌신과 책무를 보여주고, 개인 활동과 우선순위를 프로젝트 목표에 정렬하며, 팀원의 활동과 의사결정을 지원하고 상위 기관에 옹호함으로써 팀원에게 권한을 부여하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '모든 이해관계자들과 프로젝트 팀원들의 적극적인 개입 사례들, 프로젝트 문제발생에 대해 프로젝트관리가 어디에 책임이 있는지에 대한 보고 및 회합 정리서, 잘못된 프로젝트 결과에 대한 책임의식의 사례들을 통해  프로젝트에 대한 헌신성과 책임성, 책임의식을 보여주고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 책임.권한위임';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 우선순위 계획, 우선순위화된 행동 아이템들의 목록, 활동적 이벤트 관리의 사례들을 통해 프로젝트 목표를 달성할 가능성을 증가시키기 위하여 개인적 활동과 우선순위를 연계하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 책임.권한위임';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 팀원들을 대표해서 프로젝트관리자가 단호하게 행동하도록 프로젝트 팀원들로부터의 문서화된 피드백, 팀의 활동과 결정을 위한 프로젝트관리자의 후원을 나타내는 회합 내용들,  프로젝트 팀 활동들의 보조를 맞추며 일의 수행을 위한 책임성을 유지하고 있음, 그들이 자기 것인 듯 팀의 프로젝트 활동들을 후원하기 위해 더 높은 권위를 가지도록 하고 있음 등을 통해 팀의 행동과 결정을 지원하고 증진시키고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 책임.권한위임';

-- 프로젝트 청취자 맞춤형 의사소통
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 청취자 맞춤형 의사소통', '관련성 있는 정보를 제공하고, 청취자에게 맞춤화된 적절한 의사소통 방법을 사용하며, 다양한 의사소통 요구와 맥락에 대한 민감성을 보여주는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '정부의 적절성을 확인하는 수령자로부터 문서화된 피드백, 보여지는 강한 프리젠테이션 기술 등을 통해 적절한 정보를 제공하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 청취자 맞춤형 의사소통';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자를 분석하며 확인되는 선호되는 의사소통 방법, 방법 선택의 적절성을 드러내는 회합에서 만들어진 정리, 방법선택의 적절성에 관한 이해관계자로부터의 피드백 등을 통해 청취자를 위한 적절한 의사소통 방법을 사용하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 청취자 맞춤형 의사소통';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '다른 사람의 특별한 의사소통 필요 및 맥락에 대한 민감성에 대한 문서화된 피드백, 공식적, 비공식적, 구두 혹은 비구두적 언어의 구성Element들의 적절한 사용에 대한 문서화된 피드백, 팀 회합과 프리젠테이션에서 나온 세부사항에 대한 문서화된 피드백, 지역, 시간, 참여자 그리고 프라이버시 배치 등에 관한 다양한 선택의 사례들에 대한 문서화된 피드백 등을 통해 환경이나 주변에 따라 의사소통을 연계하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 청취자 맞춤형 의사소통';

-- 프로젝트 팀 구축.유지
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 팀 구축.유지', '팀원이 자신의 중요성·기대·책임을 이해하도록 보장하고, 인적·재무적·물적·지적·무형 자원을 효과적으로 배치·활용하며, 갈등 해결과 인정을 통해 긍정적 팀 태도와 효과적 관계를 조성하고, 팀의 일과 삶의 균형을 증진하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '역할의 선명성과 책임성에 대한 프로젝트 팀으로부터의 문서화된 피드백, 팀의 서신교환, 프로젝트 방향, 과제  할당된 일의 문서화,  출간된 자원 배열 척도(RAM), 팀활동을 위한 각각 구성원들의 활동적인 참여의 사례들을 통해 프로젝트에서 팀원들의 중요성을 그들이 이해하며 기대와 책임성이 팀원들에게 중요하다는 것을 확실히 하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 팀 구축.유지';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '인적, 재무적, 물적, 지적 및 무형의 자원을 적절하게 전개하고 사용하기 위하여 프로젝트 행정을 효과적으로 수행하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 팀 구축.유지';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '효과적인 갈등햬결의 사례들,  팀 구성원들의 다음과 같은 것을 보여주는 문서화된 피드백들(프로젝트 맥락에서 이성에 호소함으로써 다른 사람들에 존경을 표하는 것, 다른 사람들로부터 기꺼이 배우려는 것), 팀 내에서 관계와 결속을 쉽게 하기 위한 팀 이벤트의 사례들, 팀의 일과 성취에 대한 찬사 등을 통해 팀원들 사이에서의 긍정적 태도와 효과적인 관계를 유지하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 팀 구축.유지';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 팀원으로 부터의 문서화된 피드백, 균형에 관한 이슈를 문서화한 회합 정리노트, 균형을 얻기 위한 행동에 관한 문서화된 계획, 일의 효율성과 생산성을 개선하기 위해 취해진 행동의 사례들을 통해 건강한 일의 균형을 촉진시키고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 팀 구축.유지';

-- 프로젝트 팀.이해관계자 갈등 해결
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 팀.이해관계자 갈등 해결', '팀원과 이해관계자가 팀 규칙을 인식하도록 보장하고, 갈등 발생 시 인식하며, 다양한 기법을 활용하여 효과적으로 갈등을 해결하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 팀 규칙 등을 통해 팀과 이해관계자들이 팀의 규칙을 충분히 아는 것을 보장하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 팀.이해관계자 갈등 해결';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 내에서 발생하는 갈등의 사례들, 팀 조사 결과들을 통해 갈등을 인식하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 팀.이해관계자 갈등 해결';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '갈등해결 기술 사용의 사례들, 만족스런 갈등 해결에 관한 팀과 이해관계자들로부터의 피드백 등을 통해 갈등을 해결하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 팀.이해관계자 갈등 해결';

-- 프로젝트 팀원 동기부여.멘토링
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 팀원 동기부여.멘토링', '프로젝트 비전·미션·전략적 가치를 명확히 하고 의사소통하며, 조직 지침에 따라 수행을 보상하고, 팀원 개발을 지원하기 위한 멘토링 관계를 수립하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '비전, 임무 그리고 전략적 가치에 대한 프리젠테이션의 사례들, 프로젝트의 전략적 가치를 아는 것에 관한 팀으로부터의 문서화된 피드백, 팀 구성원들과 전략에 대해 공유하고 전략에 대한 지속적 후원을 하는 사례들을 통해 프로젝트 비전, 임무, 진술 그리고 전략적 가치들에 대해 정리하고 의사소통하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 팀원 동기부여.멘토링';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '보상과 인정에 대한 문서화된 기록, 팀 구성원에 대한 성공을 위한 계획 사례들, 적절한 기초에 관한 개인적 성취를 칭송해주는 사례들 ; 점수나 상이 개인들에게 주어질 수 있음을 확인 제공 등을 통헤 조직 가이드라인에 관한 성과에 대해 보상하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 팀원 동기부여.멘토링';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '관계에 대한 멘토링 사례들, 다른 사람들을 위한 멘토로서 추구된 사례들, 활동을 멘토링하는 것에 대한 문서화된 피드백, 개인적 개발계획에 관한 진전의 사례들을 통해 팀원들의 개발을 위해 멘토링 관계를 구축하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 팀원 동기부여.멘토링';

-- 프로젝트 헌신 표명
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 헌신 표명', '프로젝트 및 조직의 미션과 목표를 이해하고 적극적으로 지원하며, 모든 이해관계자와 협업하여 프로젝트 목표를 달성하고, 프로젝트 전진을 위해 필요한 희생을 감수하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '조직의 임무와 전략을 담은 프로젝트 목표와 목적을 문서로 정리한 것, 프로젝트 목표가 개인적 선호도에 따라 다를 때 후원이 이루어진 사례들 , 조직의 목표를 후원하는 정의된 프로젝트 활동의 사례들을 통해 프로젝트와 조직의 임무와 목표를 이해하고 활동적으로 후원하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 헌신 표명';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 목표를 이뤄내기 위해 특별한 협력적인 노력을 기울인 사례들, 팀 구축 기술이 협력을 강화하기 위해 사용된 사례들을 통해 프로젝트 목표를 확보하기 위해 모든 이해관계자들과 협력하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 헌신 표명';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '개인적 이익에 대해서는 덜 집중시키면서 효과적인 프로젝트 실행을 위해 우선순위가 더 부여된 선택 사례들, PM이 프로젝트 도전을 다루면서 긍정적인 행동을 한 사례들을 통해 프로젝트를 진전시키기 위해 필요한 희생을 하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 헌신 표명';

-- 프로젝트 효과적인 관계 구축.유지
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 효과적인 관계 구축.유지', '프로젝트와 문화에 적합한 업무 관련 관계의 경계를 정의하고, 성실성과 책임을 통해 이해관계자와 신뢰·확신을 구축하며, 모든 이해관계자에 대한 개방성·존중·배려의 환경을 조성하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자들과의 공식적인 일 관계를 프로젝트관리가  유지하는 것에 관한 프로젝트 팀 그리고 이해관계자로부터의 문서화된 피드백 공식적 비공식적 토론을 위한 문서화된 가이드라인 등을 통해 프로젝트에 그리고 지역 문화에 적절한 일과 관련된 사항들에 대한 관계를 한정하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 효과적인 관계 구축.유지';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '모든 상황에서 총체성을 가지고 행동하기, 책임성을 유지하기, 모든 상황에서 지속적 메시지를 제공하기, 정당하지 않은 비판에 직면했을 때 팀원을 지원해주기, 평정을 유지하기, 파트너나 판매자를 공정하게 다루는 것을 보여주기 등의 사례와 같이 이해관계자들과 믿음과 신뢰를 구축하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 효과적인 관계 구축.유지';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이슈분석과 결정에서의 개방성에 관해 이해관계자로부터의 피드백, 개방성 정책(프로젝트 관련 항상 접근가능), 다른사람들의 가치와 느낌에 대한 진정한 흥미를 가지고 민감할 수 있는 것에 대한 사례들, 사실에 기초하며 공정한 결정의 문서화된 증거 등을 통해 개방성, 존중, 그리고 이해관계자들에 대한 고려를 촉진시키는 환경을 창출하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 효과적인 관계 구축.유지';

-- 프로젝트 효과적인 이슈 처리.문제해결
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 효과적인 이슈 처리.문제해결', '포괄적이고 정확한 분석을 위해 복잡성을 단순화하고, 필요 시 복잡한 개념이나 도구를 적용하며, 교훈을 현재 프로젝트 이슈에 적용하고, 여러 관련 이슈를 결합하여 전체 그림을 이해하며, 프로젝트 데이터의 틈새·추세·상호관계를 관찰하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 이슈와 상호의존도에 대한 시각적 재현(목록,표, 관계지도 등), 해결책을 찾기 위해 복잡성을 해체시키는 기술의 사용을 지시하는 분석 문서들을 통해 완전하고 정확한 분석을 위해 복잡성을 단순화시키고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 효과적인 이슈 처리.문제해결';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '복잡한 이슈들의 분석을 위해 제안된 방법들을 제공하는 이슈 등록부(Log, 대장), 이슈 해결을 지원해주는 문서화된 분석, 문서화된 근본원인 분석, 포트폴리오 분석, 전문가 판단 등을 통해 필요할 때 복잡한 개념이나 도구들을 적용하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 효과적인 이슈 처리.문제해결';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '현재의 프로젝트 이슈들에 습득된 교훈들의 적용을 문서화 등을 통해  현재의 프로젝트 이슈를 해결하기 위해 습득된 교훈을 적용하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 효과적인 이슈 처리.문제해결';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 이슈들 사이의 연계와 관계의 개관을 보여주는 프로젝트 스코어카드 혹은 요약 보고서 등을 통해 완성된 그림을 이해하기 위해 여러 개의 관련 이슈들을 결합하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 효과적인 이슈 처리.문제해결';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '정보의 유효성 혹은 확정을 요청, 문서화된 추세 분석 등을 통해 프로젝트 데이터 속에 있는 균열, 추이 및 상호관계를 관찰하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트 효과적인 이슈 처리.문제해결';

-- 프로젝트에 대한 통합적 관점
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트에 대한 통합적 관점', '이해관계자의 요구·이익 및 프로젝트 성공에 대한 영향을 이해하고, 프로젝트 행동이 다른 프로젝트 영역·타 프로젝트·조직 환경에 미치는 영향을 이해하며, 공식·비공식 조직 구조와 정책을 파악하고, 감성 지능을 활용하여 과거 행동 이해·현재 태도 평가·향후 행동 예측을 수행하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자 분석, 이해관계자들의 필요에 맞는 계획을 의사소통, 프로젝트 헌장과 프로젝트 계획에서 문서화된 이해관계자들의 필요와 목표 등을 통해 프로젝트 이해관계자들의 필요, 이해 그리고 프로젝트 성공을 위한 영향들에 대해 이해하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트에 대한 통합적 관점';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 스케줄에 포함된 연관된 외적 사건들, 만일 적절하다면 조직환경에 프로젝트의 영향의 필요한 문서화 등을 통해 프로젝트 행동들이 프로젝트의 다른 영역들과 다른 프로젝트 그리고 조직환경에 어떻게 영향을 미치는지를 이해하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트에 대한 통합적 관점';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '식적 그리고 비공식적 조직 지식의 사용에 관한 이해관계자로부터의 문서화된 피드백 등을 통해 조직의 공식적 비공식적 구조 양자를 다 이해하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트에 대한 통합적 관점';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '조직의 정책 속에 기능하는 능력들에 대해 이해관계자로부터의 문서화된 피드백 등을 통해 조직의 정책들을 이해하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트에 대한 통합적 관점';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀의 구두상의 비구두상의 신호들을 파악하는 것에 대해 문서화된 피드백, 연기된 행동들이 적절하다는 팀으로부터의 문서화된 피드백, 다른 설득과 동기 기술들이 서로 다른 개인들에게 적절하게 적용되었다는 문서화된 피드백 등을 통해 다른 사람들의 과거 행동과 현재의 태도를 이해하고 설명하며 미래의 행동들을 예상하기 위해 감정적 능력을 사용하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '프로젝트에 대한 통합적 관점';

-- 필요 시 적극적인 프로젝트 개입 행동
INSERT INTO competencies (job_id, name, definition)
SELECT id, '필요 시 적극적인 프로젝트 개입 행동', '프로젝트 완료를 촉진하기 위해 필요 시 계산된 위험을 감수하고, 우유부단한 행동을 방지하며 적절한 결정을 내리고, 행동에 있어 인내와 끈기를 보이며, 적시에 사실 기반 의사결정을 하고 모호성을 관리하는 능력' FROM jobs WHERE name = 'PM리더십';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, 'PM이 요구될 때 행동을 하고 있다는 이해관계자로부터의 피드백, 문서화된 해결책을 포함하는 이슈 로그, 시의적절한 결정과정을 보여주는 촉진 보고서 작성 등을 통해프로젝트 완수를 촉진하기 위해 계산된 리스크를 가정하면서 요구되는 순간에 행동을 하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '필요 시 적극적인 프로젝트 개입 행동';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '취해진 행동에 관한 팀으로부터의 피드백, PM이 분쟁을 일으키지 않으면서 제안된 것을 거절하고 협동을 잘 유지한 사례들, PM이 상황을 평가하고 단호한 행동을 함으로써 위기를 해결했다는 사례들을 통해 단호하지 못한 결정을 예방하고, 결정을 하며 적절한 행동을 하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '필요 시 적극적인 프로젝트 개입 행동';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, 'PM이 인내와 지속성을 보이고 있다고 언급한 이해관계자로부터의 문서화된 피드백, 회합 세부사항들, 행동 아이템 노트, 수행된 의사결정 등을 보여주는 상황 보고서 , 도전에 직면했을 때 동기부여를 유지한 사례들을 통해 행동에서 인내와 지속성을 보이고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '필요 시 적극적인 프로젝트 개입 행동';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이슈들에 대한 사실적 분석과 신속한 결정 행위룰 보여주는 결정 메모 혹은 결정 분석 문서들, 문제해결을 향한 시간을 보여주는 기록으로부터의 이슈 등록부(Log, 대장), 적절한 결정과정을 보여주는 촉진 보고서를 발행 등을 통해 모호성을 관리하는 동안에 사실에 기초한 시의적절한 결정을 만들어내고 있습니까', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM리더십' AND c.name = '필요 시 적극적인 프로젝트 개입 행동';

-- 프로젝트 결과물 인수
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 결과물 인수', '프로젝트 결과물에 대한 최종 인수를 획득하고, 모든 계약 요구사항 충족을 보장하며, 모든 산출물을 운영부서로 이관하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 프로젝트 결과에 대한 승인 서류 등을 통해 최종 인수(승인)를 받고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 결과물 인수';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '끝난 것 끝나지 않은 산출물 모두를 문서화, 계약상의 내용들이 충족되었다는 문서화된 인정 등 요구되는 모든 계약상의 요구들을 충족하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 결과물 인수';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '운영에 의한 문서화된 인정 등 모든 산출물을 운영에 이관하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 결과물 인수';

-- 프로젝트 계약 행정 수행
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 계약 행정 수행', '공급업체 계약의 효과적 관리를 보장하고, 공급업체 수행 지표를 수집하며, 공급업체를 프로젝트 팀 문화에 통합하고, 계약 행정 감사를 촉진하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '판매자로부터의 피드백 등을 통해 판매자 계약이 효과적으로 관리될 것을 보증하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계약 행정 수행';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '판매자 성과 척도 보고서 등을 통해 판매자 성과 척도(Metrics, 측정기준)를 수집하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계약 행정 수행';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '판매자와 팀과의 상호작용과 통합에 관한 문서화, 판매자 만족도 조사 등을 통해  판매자가 프로젝트 팀 문화의 구성원임을 확실히 하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계약 행정 수행';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '감사 보고서, 문서화된 개선에 대한 제안 등을 통해 회계감사를 용이하게 하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계약 행정 수행';

-- 프로젝트 계획 승인
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 계획 승인', '조직 프로세스 자산과 기업 환경 요인을 검토·활용하고, 계획 활동들을 통합하여 완전한 프로젝트관리 계획서를 작성하며, 주요 이해관계자의 승인을 추구하고 프로젝트 기준선을 수립하며, 승인된 계획을 이해관계자에게 알리고 착수 회의를 실시하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '조직 프로세스 자산에 대한 문서화된 검토 및 사용 등을 통해 조직적 프로세스 자산을 검토하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '기업 환경 요인(Enterprise Environment Factor, 자원 POOL 및 인프라시스템) 들에 대한 문서화된 검토 및 사용 등을 통해 기업환경요인들을 검토하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '어떻게 프로젝트관리 계획 요소들이 통합되는지를 보여주는 문서 등을 통해  계획 활동을 완전한 프로젝트관리 계획으로 통합하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '핵심이해관계자에 의해 승인된 프로젝트관리 계획 등을 통해 핵심이해관계자에 의한 승인을 추진하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 기준선(Baseline)을 구축하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '핵심이해관계자로부터의 문서화된 피드백 등을 통해 핵심 이해관계자에게 승인된 계획을 통보하고 있습니다.', 6
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '착수회의 아젠다 및 회의록 등을 통해 착수회의(Kick-off Meeting)을 실시하고 있습니다.', 7
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계획 승인';

-- 프로젝트 계획 이해관계자 니즈 반영
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 계획 이해관계자 니즈 반영', '적절한 프로젝트 관리 방법론을 선택하고, 예비 범위를 명확히 이해하며, 조직 및 고객 니즈에 부합하는 고수준 프로젝트 범위를 구성하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이전의 프로젝트에서 사용된 방법의 예들과 왜 그것이 선택되었는지에 대한 설명 등을 통해 적절한 프로젝트관리 방법 또는 프로세스를 선택하고 사용하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계획 이해관계자 니즈 반영';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '예비 범위기술서 및 관련 문서 등을 통해 프로젝트 예비적인(Preliminary) 범위를 이해 하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계획 이해관계자 니즈 반영';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 이해관계자의 프로젝트에 대한 요구(needs) 등을 통해 조직과 고객의 요구 및 기대사항이 연계됨을 확실히 하는 상위 수준의 프로젝트 범위를 구축하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 계획 이해관계자 니즈 반영';

-- 프로젝트 공식 종료
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 공식 종료', '프로젝트 종료 활동을 실행하고, 모든 재무 활동을 종료하며, 프로젝트 종료를 이해관계자에게 공식적으로 통보하고, 모든 계약을 종료하며, 교훈을 문서화·공표하고 조직 프로세스 자산을 갱신하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 제품 혹은 서비스를 인정하는 사인을 하고 종료활동에 대해 문서화 등을 통해 프로젝트를 위한 종료활동을 실행하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 공식 종료';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 종료에 관한 재정부서로부터의 문서화된 피드백 등을 통해 프로젝트와 관련된 모든 재정활동을 마감하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 공식 종료';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 파일에 저장된 프로젝트 종료에 관한 의사소통 문서화 등을 통해 프로젝트 마감에 대해 이해관계자들에게 공식적으로 통보하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 공식 종료';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '요구사항을 충족 및 계약 종료 등을 통해 모든 프로젝트 계약을 종료하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 공식 종료';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '습득된 교훈들의 문서화 등을 통해 프로젝트 교훈을 문서화하고 출판하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 공식 종료';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '획득된 프로젝트 문서들, 조직 프로세스 자산에 문서화된 변경 사항 등을 통해 조직 프로세스 자산을 갱신(Update)하고 있습니다.', 6
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 공식 종료';

-- 프로젝트 리스크 감시 통제
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 리스크 감시 통제', '리스크 대응계획을 갱신하고, 이전에 알려지지 않은 리스크 발생 시 인식하며, 우회책을 수립하고, 신규 리스크를 식별하며, 리스크 대응 전략을 검토하고 리스크관리 감사를 촉진하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '갱신(Update)된 리스크 등록부(Log, 대장), 리스크 대응 계획의 결과에 대한 문서화 등을 통해  리스크 대응 계획을 갱신(Update)하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 감시 통제';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이전에 잘 알려지지 않은, 발생한 리스크들에 대한 문서화, 갱신(Update)된 리스크 등록부(Log, 대장) 등을 통해 잘 알려지지 않은 리스크가 발생할 때를 인식하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 감시 통제';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이전에 알려지지 않은 리스크들에 대한 우회계획 (Workaround, 임기응변계획)의 문서화,  갱신(Update)된 리스크 대응 계획 등을 통해 이전에 알려지지 않은 이전의 리스크들에 대한 우회계획(Workaround, 임기응변계획)을 구축하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 감시 통제';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '갱신(Update)된 리스크 등록부(Log, 대장) 등을 통해 새로운 리스크를 인식하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 감시 통제';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '리스크 완화 검토의 결과에 대한 문서화 등을 통해 리스크 대응 전략을 검토하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 감시 통제';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '감사 보고서, 개선에 대한 문서화된 제안 등을 통해 회계감사를 용이하게 하고 있습니다.', 6
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 감시 통제';

-- 프로젝트 리스크 대응계획 승인
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 리스크 대응계획 승인', '프로젝트 리스크관리 계획을 개발하고, 주요 리스크를 식별·정량화하며, 대응 전략 수립과 우발사태 예비비 측정을 주도하고, 리스크 대응계획을 문서화하여 주요 이해관계자의 합의를 확보하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '승인된 프로젝트에 대한 리스크 관리계획 (리스크 절차서) 등을 통해 프로젝트 리스크 관리계획 (리스크 절차서)을 개발하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 대응계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '리스크 분석의 문서화된 분석, 리스크 등록부 등을 통해 주요 리스크를 식별하고 정량화하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 대응계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '지명된 리스크 소유자와 예비비(Contingency Reserve)를 포함한 리스크 대응 계획 등을 통해 각각의 식별된 리스크를 위한 대응 전략을 발견하기 위한 노력을 지도하고 위임하고 있습니다..', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 대응계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '지정된 리스크 책임자와 예비비 (Contingency Reserve)를 포함한 리스크 대응 계획 등을 통해 리스크 예비비(Contingency Reserve)를 측정하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 대응계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '지정된 리스크 책임자와 예비비(Contingency Reserve: 우발 원가)를 포함한 리스크 대응 계획 등을 통해 리스크 대응 계획을 문서화하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 대응계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '리스크 소유자의 목록,리스크 등록부(Log, 대장) 등을 통해 리스크 책임성을 할당하고 있습니다.', 6
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 대응계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '핵심 이해관계자로부터의 문서화된 피드백 등을 통해 프로젝트 리스크 대응 계획을 위해 핵심 이해관계자들 간의 합의를 얻고 있습니다.', 7
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 대응계획 승인';

-- 프로젝트 리스크 식별
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 리스크 식별', '프로젝트의 가정사항과 제약사항을 문서화하고, 고수준 리스크를 식별·정성화·정량화하여 리스크 등록부에 기록하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 가정과 제약 등을 통해 프로젝트의 상위 수준의 가정과 제약을 정리하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 식별';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '식별되고 특질화되고 정량화된 상위 수준의 리스크들을 포함한 리스크 등록부 (Risk log, 리스크 대장 및 기술서) 등을 프로젝트의 상위 수준의 리스크들을 식별하고 정성적 및 정량적으로 분석하고 있습니다.통해', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 리스크 식별';

-- 프로젝트 목표 & 고객니즈
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 목표 & 고객니즈', '프로젝트의 전략적 연계성을 이해하고, 스폰서와 합의를 도출하며, 이해관계자의 요구사항과 제품·서비스 특성을 문서화하여 정리하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트의 전략 연계 기술서 등을 통해 프로젝트의 전략 연계(Alignment)를 이해하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 목표 & 고객니즈';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 스폰서(Sponsor, 프로젝트 자금을 후원하는 사람이나 조직) 와 프로젝트의 전략 연계에 관한 합의를 이루어 내고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 목표 & 고객니즈';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트에 대한 문서화된 이해관계자 요구(Needs) 명세서 등을 통해 핵심 이해관계자의 요구(Need)와 기대사항 (Expectation)을 정리하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 목표 & 고객니즈';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트를 인도하는데 사용되는 프로젝트 계획과 연관된, 제품과 서비스를 위한 문서화된 상위 수준의 이해관계자 요구사항 명세서 등을 통해 제품 또는 서비스의 특성을 결정하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 목표 & 고객니즈';

-- 프로젝트 물적자원 관리
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 물적자원 관리', '공급업체 정보를 요청하고, 적절한 공급업체를 선정하며, 일정 책임에 따라 획득 작업을 실행하고 내부 제공 자원을 확보하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '선택된 판매자들의 목록, 판매자 대응들 등 판매자 정보를 요구하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 물적자원 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '계약서와 SOW(Statement of Work), 구매 주문서(Purchase orders) 등을 통해 적절한 판매자를 선택하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 물적자원 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '물적자원의 이용가능성에 대한 문서화 등을 통해 일정 책임에 맞춰 획득과제를 실행하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 물적자원 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '물적자원의 이용가능성에 대한 문서화 등을 통해 내적으로 공급된 자원들을 확보하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 물적자원 관리';

-- 프로젝트 범위 승인
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 범위 승인', '프로젝트 계획에 정의된 대로 작업이 완료되었음을 증명하고, 식별된 수행 차이를 시정·예방조치로 해결하며, 리스크관리 계획을 실행하고 단계 검토를 관리하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '핵심이해관계자로부터의 문서화된 피드백, 프로젝트에 따르는 행동과 상황 문서화, 상황/마일스톤 보고서, 과제가 성공적으로 완수되었음을 확인하는 공식적인 승인 문서, 완료율 및 자원 공수(작업시간)에 대한 계획 대비 실적을 보여주는 프로젝트 원가 보고서 등을 통해 프로젝트 계획에서 정의된 대로 과제가 완성됨을 입증하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 범위 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '시정 및 예방 조치들에 대한 문서화 등을 통해 식별된 성과 차이들에 대해 조치하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 범위 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '시정 및 예방 조치에 대한 문서화 등을 통해 리스크 관리 계획을 실행하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 범위 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '조직 전체적인 미팅, 행동, 세부사항, 스폰서로부터의 피드백, 공식적 승인 등을 통해 단계 검토를 관리하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 범위 승인';

-- 프로젝트 범위 합의
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 범위 합의', '작업분류체계(WBS) 등의 도구를 활용하여 프로젝트 산출물을 정의하고, 정의된 범위에 대한 이해관계자 합의를 확보하며, 범위관리 프로세스를 실행하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '작업분류체계(WBS, Work Breakdown Structure), 프로젝트 대안 목록(List of project alternatives) 등을 사용하여 프로젝트 산출물을 정의하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 범위 합의';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 이해관계자로부터 문서화된 합의 등을 통해 WBS에 의해 정의된 범위에 대한 합의를 획득하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 범위 합의';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자로부터의 피드백, 범위 관리 계획 (범위 절차서) 등을 통해 범위 관리를 구현하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 범위 합의';

-- 프로젝트 변경 관리
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 변경 관리', '프로젝트 기준선의 변경을 식별하고, 변경의 영향을 평가하며, 변경관리 프로세스에 따라 변경을 통제·기록하고, 프로젝트 이해관계자에게 변경을 의사소통하며, 형상관리를 수행하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '지정된 승인자에 의해 인정된  활동을 위해 제출된 변경 보고서 등을 통해 기준선(Baseline) 프로젝트 계획에 대한 변경을 식별하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 변경 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '변경에 대한 분석의 문서화된 결과 등을 통해 프로젝트 계획에 대한 변경의 충격을 식별하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 변경 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '승인되고 시행된 변경들에 대한 기록 등을 통해 변경을 관리하고 기록하기 위해 변경관리 프로세스를 따르고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 변경 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자들과의 의사소통의 문서화 등을 통해 프로젝트 이해관계자들과 변경에 대해 의사소통하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 변경 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '관리와 통제 실행에 관해 이해관계자에게서 나온 문서화된 피드백 등을 통해 형상관리(Configuration management) 프로세스가 수행되고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 변경 관리';

-- 프로젝트 원가 예산 승인
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 원가 예산 승인', '개별 활동 및 전체 프로젝트의 원가를 산정하고, 프로젝트 예산을 개발하며, 원가관리 계획을 작성하여 스폰서 승인을 얻고 이해관계자에게 의사소통하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '세부 지원항목(Supporting detail)을 지닌 승인된 예산(Budget) 등을 통해 각각의 활동에 대한 원가(Cost)를 측정하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 원가 예산 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '세부 지원항목을 담은 승인된 예산 등  모든 다른 프로젝트 원가를 측정하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 원가 예산 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '세부 지원항목을 담은 승인된 예산 등 프로젝트 예산(Budget)을 개발하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 원가 예산 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '원가 관리 계획 (원가 절차서) 등을 통해 원가 관리 계획(원가 절차서)을 개발하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 원가 예산 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 예산에 대한 문서화된 스폰서의 승인 등을 통해 계획된 프로젝트 예산에 대한 승인을 얻고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 원가 예산 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자의 문서화된 피드백 등을 통해 이해관계자와 계획 예산에 대해 의사소통하고 있습니다.', 6
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 원가 예산 승인';

-- 프로젝트 의사소통 활동 합의
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 의사소통 활동 합의', '프로젝트 의사소통 계획을 수립하고, 식별된 이해관계자와의 의사소통을 위한 적절한 도구와 방법을 선정하며, 의사소통 활동 일정을 수립하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '의사소통 관리 계획 등을 통해 프로젝트 의사소통 계획을 수립하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 의사소통 활동 합의';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '후원 계획, 상황 보고서, 이슈 등록부(Issue log, 이슈대장 및 기술서), 조직 프로세스 자산 (Organizational Process Asset, 지식 기반 및 절차서)에서 습득된 교훈 등의 모음 등을 통해 식별된 이해관계자들과 의사소통을 하기 위해 적절한 도구와 방법을 선택하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 의사소통 활동 합의';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자로부터의 문서화된 피드백 등을 통해 의사소통 계획을 다루기 위한 활동의 일정을 수립하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 의사소통 활동 합의';

-- 프로젝트 이해관계자 기대 관리
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 이해관계자 기대 관리', '프로젝트 전반에 걸쳐 이해관계자의 기대사항을 지속적으로 검토하여 프로젝트 범위 내에서 충족되도록 하고, 프로젝트 후원을 확보하기 위해 이해관계자와 상호작용하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자 분석 갱신(Update)에 대한 문서화, 이해관계자의 기대를 관리하기 위해 취해진 조치들에 대한 문서화 등을 통해 프로젝트 범위 내에서 기대가 충족되어짐을 보증하기 위해 프로젝트 과정 내내 이해관계자의 기대를 검토하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 이해관계자 기대 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자와의 모든 회합에 대한 세부사항들, 이해관계자들의 기대치를 관리하기 위해 취해진 조치들의 문서화 등을 통해  프로젝트에 대한 후원을 보증하기 위해 이해관계자들과 상호 소통작용을 하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 이해관계자 기대 관리';

-- 프로젝트 이해관계자 식별 및 욕구 이해
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 이해관계자 식별 및 욕구 이해', '프로젝트 이해관계자를 식별하고, 이해관계자 분석을 통해 요구사항과 목표를 파악하며, 고수준 의사소통 요구사항을 식별하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자들의 문서화된 목록 등을 통해 프로젝트 이해관계자를 식별하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 이해관계자 식별 및 욕구 이해';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 이해관계자들의 요구와 목표 대한 표현, 그리고 문서화된 이해관계자들의 위치와 영향 등을 통해 수용될 수 있는 이해관계자 분석을 행하고 프로젝트의 요구를 식별하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 이해관계자 식별 및 욕구 이해';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자들의 요구가 이해되었음을 확인하는 문서화된 피드백, 의사소통 관리 계획, 문서화된 상위 수준의 의사소통 전략 등을 통해 상위 수준의 의사소통 요구를 식별하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 이해관계자 식별 및 욕구 이해';

-- 프로젝트 이해관계자 인식 측정 분석
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 이해관계자 인식 측정 분석', '프로젝트 이해관계자를 대상으로 인식 관련 설문조사를 실시하고 피드백 결과를 분석하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자로부터의 문서화된 피드백 등 프로젝트 이해관계자들을 조사하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 이해관계자 인식 측정 분석';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 분석 등을 통해 피드백 결과를 분석하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 이해관계자 인식 측정 분석';

-- 프로젝트 인적자원 관리
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 인적자원 관리', '인력충원관리 계획에 따라 인적자원을 확보하고, 프로젝트 팀을 구축하며, 훈련 및 개발 계획을 통해 프로젝트 팀원을 개발하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '직원 목록, 노동 계약, 확보된 노동을 위한 작업기술서(SOW ; Statement of Work, 계약수행 항목으로 범위, 일정, 원가, 품질, 수행조직인력 등의 내역 기술) 등을 통해 직원관리계획에 따라 인적자원을 확보하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 인적자원 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 조직 차트, 문서화된 작업 방식 등을 통해 프로젝트 팀을 구축하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 인적자원 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '능력 갭에 대한 분석, 팀 구성원들을 위한 개발 계획 등을 통해 프로젝트 팀 구성원들을 개발하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 인적자원 관리';

-- 프로젝트 일정 승인
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 일정 승인', '승인된 범위를 인도하기 위한 활동 및 의존관계를 정의하고, 활동 기간을 산정하며, 자원이 배정된 일정을 수립하여 스폰서 승인을 얻고 이해관계자에게 의사소통하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 일정 네트워크 다이어그램, WBS 사전 (WBS 별로 시간, 원가, 품질, 자원, 리스크 등의 프로젝트 지식분야 정보를 수록한 문서) 등을 통해 승인된 범위를 전달하기 위해 활동과 의존관계들을 정의하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 일정 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '일정 과업(Task) 기간을 결정하기 위해 사용된 프로세스의 문서화 등을 통해 각각의 활동에 대한 완성 시간을 측정하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 일정 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '일정모델 데이터(일정 수립에 사용되는 제반 정보)를 포함하는 프로젝트 일정 등을 통해 내적 외적 의존관계들을 식별하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 일정 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '일정 모델 데이터를 포함하는 프로젝트 일정 등을 통해 자원 책임에 대해 프로젝트 활동들의 일정을 잡고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 일정 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 일정에 대한 문서화된 스폰서의 승인 등을 통해 프로젝트 일정에 대한 승인을 획득하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 일정 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '이해관계자로부터의 문서화된 피드백, 프로젝트 이해관계자로부터 문서화된 승인 등을 통해 이해관계자와 프로젝트 일정에 대해 의사소통하고 있습니다.', 6
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 일정 승인';

-- 프로젝트 자원 해산
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 자원 해산', '프로젝트 자원 해산을 위한 조직 프로세스를 실행하고, 프로젝트 팀원에게 수행 피드백을 제공하며, 팀원 수행에 대한 피드백을 조직에 제공하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트가 종료될 때 프로젝트로부터의 팀 구성원 해산 스케줄을 위한 타임테이블 사례 등 프로젝트 자원들을 해산하기 위해 조직적 프로세스를 실행하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 자원 해산';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 직원 성과 피드백 등 프로젝트 팀 구성원에게 성과 피드백을 제공하고 있습니까', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 자원 해산';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '성과 평가가 기능 관리자에게 검토 저장 등 팀 구성원들의 성과에 관해 조직에 피드백을 제공하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 자원 해산';

-- 프로젝트 조달 계획 승인
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 조달 계획 승인', '자재 소요를 분석하고, 구매 및 외부 용역 획득을 계획하며, 계약 행정을 계획하고 스폰서의 조달관리 계획 승인을 획득하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 조달 관리 계획 등을 통해 물자 요구를 분석하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 조달 계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '구매요구와 주문서 등을 통해 구매와 획득에 대해 계획하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 조달 계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '외부 용역 조달을 지원하기 위한 문서화,  자원 계약 등을 통해 외부 용역 조달을 계획하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 조달 계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '조달 관리 계획 등을 통해 계약 행정을 계획하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 조달 계획 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '조달관리계획의 스폰서 승인 등을 통해 계획 승인을 획득하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 조달 계획 승인';

-- 프로젝트 추적 및 상황 정보 공유
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 추적 및 상황 정보 공유', '프로젝트 수행 정보를 확보하는 프로세스를 실행하고, 이해관계자에게 상태를 의사소통하며, 프로젝트 계획 변경에 대한 시정조치 실행을 보장하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 성과(Performance) 보고서 등을 통해 프로젝트 정보를 확보하기 위한 프로세스를 실행하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 추적 및 상황 정보 공유';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '상황 보고서 혹은 정규 회합에 대한 세부사항들, 이해관계자로부터 온 문서화된 피드백, 성과 측정 등을 통해  이해관계자들에게 상황(status) 정보가 의사소통되고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 추적 및 상황 정보 공유';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '변경상황을 극복해내기 위해 취해지는 시정 및 예방 조치의 문서화 등을 통해 계획에 대한 어떤 변경에도 실행 계획이 시행되도록 자리잡을 것을 보증하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 추적 및 상황 정보 공유';

-- 프로젝트 통합변경통제 프로세스 정의
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 통합변경통제 프로세스 정의', '변경통제 프로세스를 수립하고, 이해관계자를 포함하여 변경통제 계획을 공식화하며, 변경통제 프로세스 및 절차의 사용을 보장하고 주요 이해관계자에게 의사소통하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 통합 변경 통제 프로세스 등을 통해 변경 통제 프로세스를 구축하기 위한 노력을 지도하고 위임하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 통합변경통제 프로세스 정의';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '변경통제계획을 공식화 시키는데 이해관계자 참여의 문서화 등을 통해 변경통제계획을 발효시키는데 이해관계자를 포함하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 통합변경통제 프로세스 정의';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '변경통제위원회(CCB: Change Control Board) 회의록, 변경통제 문서화 등을 통해 변경통제프로세스와 절차의 사용을 보장하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 통합변경통제 프로세스 정의';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '핵심이해관계자로부터 문서화된 피드백 등을 통해 변경통제 프로세스에 대한 핵심 이해관계자와 의사소통하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 통합변경통제 프로세스 정의';

-- 프로젝트 팀 관리
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 팀 관리', '정기적인 팀 회의를 실시하고, 팀 구축 활동을 실행하며, 팀 만족도를 모니터링하고 팀 및 개별 팀원에게 수행 피드백을 제공하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀 회합에 대한 세부사항 등을 통해 정규적 팀 회합을 개최하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 팀 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀 구성활동에 대한 결과들에 대한 문서화 등을 통해 팀 구성활동을 시행하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 팀 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀 만족에 대한 조사 결과 등을 통해 팀 만족도를 감시(모니터링)하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 팀 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀 구성원에게 주어진 문서화된 피드백, 팀 피드백에 대한 문서화 등을 통해 팀과 개인 구성원들의 성과에 대한 피드백을 제공하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 팀 관리';

-- 프로젝트 팀 역할.책임 합의
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 팀 역할.책임 합의', '프로젝트 팀의 역할과 책임을 정의하고 합의하며, 자원에 대한 공식적 합의를 확보하고, 자원 소요 및 팀 구성을 계획하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '역할과 책임을 담은 직원 관리계획 (직원관리 절차서) 등을 통해 프로젝트 팀의 역할 및 책임이 합의되고 식별되고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 팀 역할.책임 합의';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 팀의 구성원들과 이해관계자들의 역할과 책임, 문서화된 팀 규약 등을 통해 역할과 책임을 정의하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 팀 역할.책임 합의';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '자원에 대한 문서화된 공식적 합의 등을 통해 적절한 자원을 얻기 위해 조직과의 합의에 도달하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 팀 역할.책임 합의';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '팀 개발과 자원 요구사항을 위한 문서화된 활동, 문서화된 팀 규약 등을 통해 자원 요구사항과 팀 구성을 계획하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 팀 역할.책임 합의';

-- 프로젝트 품질 감시 통제
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 품질 감시 통제', '완료된 산출물의 수행을 기록하고, 프로젝트 및 제품 지표를 수집하며, 프로젝트 기준선으로부터의 이탈을 감시하고, 시정·예방조치를 권고하며, 품질 감사를 촉진하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '완성되어서 사인이 다 된 산출물에 대한 기록 등을 통해 완성된 산출물의 성과를 기록하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질 감시 통제';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트와 제품 척도(측정기준) 보고서 등을 통해 프로젝트와 제품 척도(측정기준)를 수집하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질 감시 통제';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '품질 결함 보고서 등을 통해  프로젝트 기준선(Baseline)으로부터 이탈된 것들을 감시(모니터링)하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질 감시 통제';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '시정과 예방조치의 문서화 등을 통해 시정과 예방조치를 하도록 권장하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질 감시 통제';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '감사 보고, 개선에 대한 문서화된 제안 등을 통해 회계감사를 용이하게 하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질 감시 통제';

-- 프로젝트 품질 계획 관리
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 품질 계획 관리', '품질보증 활동을 수행하고, 품질 감사를 통해 수립된 품질 표준 및 프로세스가 준수되고 있는지 보장하며 개선을 권고하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '핵심 이해관계자들에 의한 프로젝트 산출물의 문서화된 수용, 문서화된 변경 요구 등 품질 보증 활동들을 실행하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질 계획 관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '품질 감사, 문서화된 프로세스 개선 추천, 계획의 다양성을 기반으로 한 기획 문서에 대한 문서화된 갱신(Update) 등 품질 기준과 프로세스의 부합을 보증하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질 계획 관리';

-- 프로젝트 품질관리 프로세스 구축
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 품질관리 프로세스 구축', '조직 정책과 부합하는 품질 표준을 수립하고, 산출물 인도 프로세스를 정의하며, 산출물·프로세스·프로젝트관리에 대한 품질 지표를 설정하고 기준선을 포함한 품질관리 계획을 개발하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '사용되는 품질 기준의 문서화 등을 통해 조직적 품질 정책과 연계되는 프로젝트 내에서 사용되는 품질 표준을 구축하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질관리 프로세스 구축';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 품질 프로세스 문서 등을 통해 프로젝트 산출물을 전달하기 위해 사용되는 프로세스를 정의하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질관리 프로세스 구축';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '프로젝트 품질 척도(Metrics, 측정기준)의 문서화 등을 통해  산출물, 프로세스 및 프로젝트관리 성과를 위한 프로젝트 품질척도(Metrics, 측정기준)를 수립하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질관리 프로세스 구축';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '품질 기준선(Baseline)을 포함한 승인된 프로젝트 품질 관리 계획 등을 통해 프로젝트 품질 관리 계획을 개발하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 품질관리 프로세스 구축';

-- 프로젝트 헌장 승인
INSERT INTO competencies (job_id, name, definition)
SELECT id, '프로젝트 헌장 승인', '프로젝트의 고수준 전략과 핵심 마일스톤을 개발하고, 주요 산출물 개요와 요약 예산을 준비하며, 프로젝트 헌장 작성을 지원하고 스폰서 승인을 획득하는 능력' FROM jobs WHERE name = 'PM관리';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 상위 수준의 프로젝트 전략 등을 통해 상위 수준의 프로젝트 전략을 개발하고 있습니다.', 1
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 헌장 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 이정표와 산출물 등을 통해 산출물 프로젝트 핵심 이정표(Milestone)와 산출물을 정리하고 있습니다.', 2
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 헌장 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 상위수준 개략산정서 등을 통해 요약 예산을 개발하고 있습니다.', 3
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 헌장 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '문서화된 자원요구사항, 문서화된 요약 예산, 프로젝트 헌장 초안 등을 통해 프로젝트 헌장(Charter) 작성을 지원하고 있습니다.', 4
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 헌장 승인';

INSERT INTO behavioral_indicators (competency_id, indicator_text, indicator_number)
SELECT c.id, '통제 문서 (예를 들면,  비즈니스 케이스 및 단계검토 회의록 등을 포함한 거버넌스 문서로서의 승인된 프로젝트 헌장) 등을 통해 스폰서 승인과 책임을 얻기 위한 통제 프로세스를 사용하고 있습니다.', 5
FROM competencies c JOIN jobs j ON c.job_id = j.id
WHERE j.name = 'PM관리' AND c.name = '프로젝트 헌장 승인';
