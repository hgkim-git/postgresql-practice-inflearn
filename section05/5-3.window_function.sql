INSERT INTO transactions (account_id, type, amount, description, created_at)
VALUES (1, '입금', 500000, '월급', '2024-12-05 09:00:00+09'),
       (1, '출금', 200000, '보험료', '2024-12-12 10:00:00+09'),
       (1, '출금', 90000, '식료품', '2024-12-20 15:00:00+09'),
       (1, '입금', 500000, '월급', '2025-01-05 09:00:00+09'),
       (1, '출금', 150000, '관리비', '2025-01-10 11:00:00+09'),
       (2, '입금', 300000, '적금 납입', '2024-12-01 10:00:00+09'),
       (2, '입금', 300000, '적금 납입', '2025-01-01 10:00:00+09'),
       (3, '출금', 350000, '카드대금', '2024-12-05 10:00:00+09'),
       (3, '입금', 750000, '월급', '2024-12-05 09:00:00+09'),
       (3, '출금', 400000, '카드대금', '2025-01-05 10:00:00+09'),
       (3, '입금', 750000, '월급', '2025-01-05 09:00:00+09'),
       (4, '입금', 50000, '용돈', '2024-12-01 09:00:00+09'),
       (4, '출금', 40000, '편의점', '2024-12-18 20:00:00+09'),
       (4, '입금', 50000, '용돈', '2025-01-01 09:00:00+09'),
       (5, '입금', 2000000, '보너스', '2024-12-20 17:00:00+09'),
       (5, '출금', 600000, '여행경비', '2024-12-26 08:00:00+09'),
       (5, '입금', 500000, '월급', '2025-01-05 09:00:00+09'),
       (6, '입금', 300000, '적금 납입', '2024-12-01 10:00:00+09'),
       (6, '출금', 80000, '외식', '2024-12-22 19:00:00+09'),
       (6, '입금', 300000, '적금 납입', '2025-01-01 10:00:00+09'),
       (7, '입금', 300000, '적금 납입', '2024-12-01 10:00:00+09'),
       (7, '입금', 300000, '적금 납입', '2025-01-01 10:00:00+09'),
       (8, '입금', 10000, '이자', '2024-12-31 00:00:00+09'),
       (8, '입금', 10000, '이자', '2025-01-31 00:00:00+09');


SELECT account_id, SUM(amount) AS 총거래금액
FROM transactions
GROUP BY account_id;

-- GROUP BY
SELECT transaction_id,
       account_id,
       amount
-- SUM(amount) OVER (PARTITION BY account_id) AS 계좌별총거래금액
FROM transactions
ORDER BY account_id, transaction_id;

SELECT transaction_id,
       account_id,
       amount,
       SUM(amount) OVER (PARTITION BY account_id) AS 계좌별총거래금액
FROM transactions
ORDER BY account_id, transaction_id;

SELECT account_id,
       amount,
       SUM(amount) OVER () AS 계좌별총거래금액
FROM transactions
LIMIT 5;

SELECT transaction_id,
       account_id,
       amount,
       created_at,
       row_number() over (ORDER BY amount DESC) AS 전체순번
FROM transactions
ORDER BY amount DESC
LIMIT 5;


SELECT transaction_id,
       account_id,
       amount,
       created_at,
       row_number() over (PARTITION BY account_id ORDER BY amount DESC) AS 전체순번
FROM transactions
ORDER BY amount DESC
LIMIT 5;

-- RANK()
-- 공동 순위도 카운팅됨 (1등 두명 -> 1등, 1등, 그다음 3등임)
-- DENSE_RANK()
--
SELECT transaction_id,
       account_id,
       amount,
       RANK() OVER (ORDER BY amount DESC)       AS rank순위,
       DENSE_RANK() OVER (ORDER BY amount DESC) AS dense_rank순위
FROM transactions
ORDER BY amount DESC
LIMIT 8;