/*
정수
- SMALLINT
    - 2byte
    - -32768~32767
- INTEGER
    - 4byte
    - -2147483648~2147483647(-21억 ~ 21억)
    - 초당 수천건의 거래가 발생하는 시스템에는 생각보다 빨리 도달함 -> 자동 증가값에는 BIGINT 사용
- BIGINT
    - 8byte
    - -9223372036854775808~9223372036854775807(+-920경)
 */

SELECT 32767::SMALLINT;
SELECT 32768::SMALLINT;
-- [22003] ERROR: smallint out of range

/*
실수
- NUMERIC
    - 전체 자리숫와 소수점 이하 자릿수 지정
    - 오차 적음
    - 금융권에서 주로 사용
- FLOAT
    - 컴퓨터 내부에서 숫자를 이진수로 표현하는 부동소수점 방식
    - 미세한 차이 존재, 표현하지 못하거나 오차 생길 수 있음
    - 금융에서는 사용할 수 없음
 */

SELECT 0.1::FLOAT + 0.2::FLOAT;
SELECT 0.1::NUMERIC + 0.2::NUMERIC;

/*
문자열
- CHAR(n)
    - 고정 길이(n) 문자열
    - 길이가 정해진 데이터에 사용
    - 데이터가 정해진 길이 보다 짧으면 공백으로 채워짐
- VARCHAR(n)
    - n까지 가능한 가변 길이 문자열
    - 이메일, 주소 같이 다양한 길이의 데이터
- TEXT
    - 길이 제한이 없음
    - JSON과 같이 길이 예측이 어려운 데이터에 사용
    - ⭐PostgreSQL에는 VARCHAR와 TEXT의 내부 저장 방식이 동일함 => 성능 차이 없음
        - 최대 길이 제한이 필요하거나 예측이 가능하면 -> VARCHAR 사용(성능상 효율적)
        - 아니면 TEXT 사용
 */

SELECT 'hello'::CHAR(3); -- 'hel' 넘치는건 자름
SELECT 'Hello'::VARCHAR(10);

/*
날짜와 시간
- DATE
    - 날짜만. 시간정보 포함 X
- TIMESTAMP
    - 날짜와 시간 함께
    - 타임존 X
- TIMESTAMPTZ
    - 날짜, 시간, 타임존 정보까지
    - 글로벌 서비스
추후 날짜 함수 관련 내용할 때 자세히 다룰 예정
 */

SELECT '2021-01-01'::DATE;

/*
- BOOLEAN
    - 참 또는 거짓
    - TRUE, FALSE
 */
SELECT TRUE, FALSE, TRUE AND FALSE, TRUE OR FALSE;

--