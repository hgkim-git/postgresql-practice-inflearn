-- LAG, LEAD
--> LAG(column name, offset, default value): 현재 행의 이전 행 값을
--> LEAD(column name, offset, default value): 다음 행 값을 가져온다.

SELECT transaction_id,
       amount,
       created_at,
       LAG(amount) OVER (
           PARTITION BY account_id
           ORDER BY created_at
           ) AS 직전거래금액,
       amount - LAG(amount) OVER (
           PARTITION BY account_id
           ORDER BY created_at
           ) AS 직전대비증감
FROM transactions
WHERE account_id = 1
ORDER BY created_at;

-- 기본값지정
-- LAG(amount, 1, 0) OVER (PARTITION BY account_id ORDER BY created_at)
-- LEAD(amount, 1, 0) OVER (PARTITION BY account_id ORDER BY created_at)

-- FIRST_VALUE : 윈도우 내 첫 번쨰 값
-- LAST_VALUE : 윈도우 내 마지막 값

SELECT account_id,
       transaction_id,
       amount,
       created_at,
       FIRST_VALUE(amount) OVER (
           PARTITION BY account_id
           ORDER BY created_at
           ) AS 첫거래금액
FROM transactions
WHERE account_id IN (1, 2)
ORDER BY account_id, created_at;

-- FIRST_VALUE
/*
 기본 프레임 :
    - ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    - 파티션의 시작부터(UNBOUNDED PRECEDING) 현재 행(CURRENT ROW)까지를 프레임으로
 - ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    - 파티션의 시작부터(UNBOUNDED PRECEDING) 끝 행까지(UNBOUNDED FOLLOWING)를 프레임으로
 */