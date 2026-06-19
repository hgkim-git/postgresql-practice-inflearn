-- 🌟집계함수는 NULL을 제외 하고 처리됨
SELECT COUNT(*)
FROM customers;

SELECT COUNT(phone)
FROM customers;

SELECT SUM(balance) AS 총잔액,
       AVG(balance) AS 평균잔액,
       MIN(balance) AS 최소잔액,
       MAX(balance) AS 최대잔액
FROM accounts;

-- 소수점 처리
SELECT ROUND(AVG(balance), 2) AS 평균잔액
FROM accounts;

-- 예금 계좌의 합계, 적금 계좌의 합계
-- 집계함수를 쓴 경우 SELECT 절에는 GROUP BY에 사용된 컬럼이나 집계함수만 올 수 있음
SELECT account_type, SUM(balance) AS 타입별총잔액
FROM accounts
GROUP BY account_type;

SELECT customer_id, account_type, SUM(balance) AS 합계
FROM accounts
GROUP BY customer_id, account_type
ORDER BY customer_id, account_type;

-- HAVING
SELECT account_type, SUM(balance) AS 타입별총잔액
FROM accounts
WHERE balance > 0
GROUP BY account_type;

SELECT account_type, SUM(balance) AS 타입별총잔액
FROM accounts
GROUP BY account_type
HAVING SUM(balance) > 1000000;