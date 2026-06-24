-- 서브쿼리
-- 한 쿼리의 결과를 다른 쿼리의 조건이나 데이터 소스로 사용하기 위한 쿼리

-- WHERE 절에 사용된 서브 쿼리
-- 반드시 단일 값이 나와야 함
SELECT *
FROM accounts
WHERE balance > (SELECT AVG(balance) FROM accounts)
ORDER BY balance DESC;

-- 인라인 뷰 : FROM에 사용되는 서브쿼리
-- 인라인 뷰 별칭(AS) 추가 필수!
SELECT account_id AS 거래건수
FROM (SELECT account_id, COUNT(*) AS 거래건수
      FROM transactions
      GROUP BY account_id) AS 계좌별집계
WHERE 거래건수 >= 3
ORDER BY 거래건수 DESC;

-- 스칼라 서브쿼리 : SELECT에 사용하는 서브쿼리
-- 성능 주의. row 마다 실행되므로 데이터가 많아지면 성능 이슈
SELECT account_id,
       account_type,
       balance,
       (SELECT ROUND(AVG(balance), 0) FROM accounts) AS 전채평균잔액,
       balance - (SELECT AVG(balance) FROM accounts) AS 평균대비차이
FROM accounts;

-- EXISTS
-- 서브 쿼리에 조회된 row가 하나라도 있으면 true 를 반환함
SELECT account_id, account_type, balance
FROM accounts a
WHERE EXISTS (SELECT 1
              FROM transactions t
              WHERE t.account_id = a.account_id)
ORDER BY account_id;

-- 이런 서브 쿼리는 장점도 많지만 특정 조건에서 성능 이슈 가능성과 중첩되면 가독성이 떨어져 읽기 불편하다는 점을 기억
-- 가독성 문제를 해결하기 위한 CTE(WITH 절)을 사용하는 방법은 다음 시간에