/*
 CTE
 - Common Table Expression
 - WITH를 통해 서브 쿼리를 블록화
 */
SELECT account_id, 거래건수
FROM (SELECT account_id, COUNT(*) AS 거래건수
      FROM transactions
      GROUP BY account_id) AS 계좌별집계
WHERE 거래건수 >= 3
ORDER BY 거래건수 DESC;

-- 위와 동일한 쿼리
-- 가독성이 좋아짐
WITH 계좌별집계 AS (SELECT account_id, COUNT(*) AS 거래건수
               FROM transactions
               GROUP BY account_id)
SELECT account_id, 거래건수
FROM 계좌별집계
WHERE 거래건수 >= 3
ORDER BY 거래건수 DESC;

WITH 계좌별거래합계 AS (SELECT account_id, SUM(amount) AS 총거래금액
                 FROM transactions
                 GROUP BY account_id),
     고객별합계 AS (SELECT a.customer_id, SUM(c.총거래금액) AS 고객총거래금액
               FROM accounts AS a
                        -- 위에 선언한 것("계좌별거래합계")도 참조 가능
                        JOIN 계좌별거래합계 AS c ON c.account_id = a.account_id
               GROUP BY a.customer_id),
     전체평균 AS (SELECT AVG(고객총거래금액) AS 평균거래금액
              FROM 고객별합계)
SELECT cu.name            AS 고객명,
       g.고객총거래금액,
       ROUND(p.평균거래금액, 0) AS 전체평균
FROM 고객별합계 g
         JOIN customers cu ON cu.customer_id = g.customer_id
         CROSS JOIN 전체평균 p
WHERE g.고객총거래금액 >= p.평균거래금액
ORDER BY g.고객총거래금액 DESC;