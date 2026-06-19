/*
 정규화가 항상 좋은 것은 아님
    - 정규화에는 항상 JOIN이 기본 전제. -> JOIN에도 비용이 들음
    - RDB는 그나마 적지만 NoSQL에서 제공하는 Lookup(JOIN과 비슷한 기능)은 비용이 큼
    - JOIN도 줄일 수록 좋음
 */
INSERT INTO accounts
    (customer_id, account_type, balance)
VALUES (3, '입출금', 0);

DELETE
FROM transactions
WHERE account_id = 8
RETURNING *;

/*
 INNER JOIN
    - 두 테이블에서 ON 조건을 만족하는 행
    - 값이 없거나 일치하지 않는 행은 제외된다
    - 가장 자주 볼 수 있는 JOIN
 */

SELECT c.name,
       a.account_id,
       a.account_type,
       a.balance
FROM customers AS c
         INNER JOIN accounts AS a
                    ON a.customer_id = c.customer_id
ORDER BY c.customer_id, a.account_id;

/*
 LEFT JOIN
 - 왼쪽 테이블의 모든 행은 기본적으로 포함
 - 오른쪽 테이블에서 일치하는 row 가 없다면 NULL로 채워진다
 */

SELECT a.account_id,
       a.account_type,
       COUNT(t.transaction_id) AS 거래건수
FROM accounts a
         LEFT JOIN transactions t ON t.account_id = a.account_id
GROUP BY a.account_id, a.account_type
ORDER BY a.account_id;

SELECT a.account_id, a.account_type
FROM accounts a
         LEFT JOIN transactions t ON t.account_id = a.account_id
WHERE t.transaction_id IS NULL;

/*
 RIGHT JOIN
 - LEFT JOIN의 반대
 - 오른쪽 테이블을 기본적으로 포함
 - 가독성 측면으로 LEFT JOIN을 더 많이 씀
 */

SELECT c.name,
       a.account_id,
       a.account_type
FROM accounts a
         RIGHT JOIN customers c ON a.customer_id = c.customer_id
ORDER BY c.customer_id;

/*
 FULL OUTER JOIN
 - 양쪽 테이블의 합집합
 - LEFT JOIN 결과 + RIGHT JOIN 결과 UNION(중복 제거) 한 것과 같음
 - MySQL에서는 지원되지 않나봄
 */

SELECT c.customer_id,
       c.name,
       a.account_id,
       a.account_type
FROM customers c
         FULL OUTER JOIN accounts a ON a.customer_id = c.customer_id
ORDER BY c.customer_id NULLS LAST, a.account_id;

SELECT c.customer_id, c.name, a.account_id
FROM customers c
         FULL OUTER JOIN accounts a ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL
   OR a.account_id IS NULL;

/*
 CROSS JOIN
 - 양쪽의 모든 조합을 만들어내는 JOIN
 - 카테시안 곱
 - 경우의 수 -> 왼쪽 테이블 row 수 * 오른쪽 테이블 row 수
 */

SELECT a.account_type,
       c.name
FROM (SELECT DISTINCT account_type FROM accounts) a
         CROSS JOIN (SELECT name FROM customers LIMIT 3) c
ORDER BY a.account_type, c.name;