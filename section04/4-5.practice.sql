SELECT c.customer_id,
       c.name                      AS 고개명,
       COUNT(a.account_id)         AS 계좌수,
       COALESCE(SUM(a.balance), 0) AS 총잔액
FROM customers AS c
         LEFT JOIN accounts AS a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY 총잔액 DESC;

-- 거래 내역을 기준으로 계좌, 고객명 JOIN
-- WHERE 조건절을 많이 걸 테이블을 FROM으로 잡음
--  - WHERE 조건절이 JOIN 전에 실행되므로 WHERE 에서 필터링을 많이해서 row 수를 줄이면 JOIN 비용도 줄어듦
SELECT t.transaction_id,
       c.name         AS 고객명,
       a.account_type AS 계좌유형,
       t.type         AS 거래유형,
       t.amount       AS 금액,
       t.description  AS 내용,
       t.created_at   AS 거래일시
FROM transactions AS t
         INNER JOIN accounts AS a on a.account_id = t.account_id
         INNER JOIN customers AS c on c.customer_id = a.customer_id;

SELECT a.account_id,
       c.name         AS 고객명,
       a.account_type AS 계좌유형,
       a.balance      AS 잔액,
       a.created_at   AS 개설일
FROM accounts a
         INNER JOIN customers c ON c.customer_id = a.customer_id
         LEFT JOIN transactions t ON t.account_id = a.account_id
WHERE t.transaction_id IS NULL;