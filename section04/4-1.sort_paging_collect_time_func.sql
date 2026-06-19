DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers
(
    customer_id BIGSERIAL PRIMARY KEY,
    name        VARCHAR(100)        NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    phone       VARCHAR(20),
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE accounts
(
    account_id   BIGSERIAL PRIMARY KEY,
    customer_id  BIGINT         NOT NULL,
    account_type VARCHAR(20)    NOT NULL CHECK (account_type IN ('예금', '적금', '입출금')),
    balance      NUMERIC(15, 2) NOT NULL DEFAULT 0 CHECK (balance >= 0),
    created_at   TIMESTAMPTZ             DEFAULT NOW()
);

INSERT INTO customers (name, email, phone)
VALUES ('김지수', 'jisu@example.com', '010-1234-5678'),
       ('박민준', 'minjun@example.com', '010-9876-5432'),
       ('이하은', 'haeun@example.com', '010-5555-1234'),
       ('최서준', 'seojun@example.com', '010-2222-3333'),
       ('정유나', 'yuna@example.com', NULL);

INSERT INTO accounts (customer_id, account_type, balance)
VALUES (1, '예금', 1500000.00),
       (1, '적금', 3000000.00),
       (2, '예금', 250000.00),
       (3, '입출금', 80000.00),
       (4, '예금', 5200000.00),
       (4, '적금', 1800000.00),
       (5, '적금', 1200000.00),
       (5, '입출금', 0.00);
UPDATE accounts
SET balance = 1750000.00
WHERE customer_id = 1
  AND account_type = '예금'
RETURNING account_id, account_type, balance;

SELECT balance
FROM accounts
ORDER BY balance;
-- DESC : 내림차순 ASC : 오름차순

SELECT accounts.account_type, accounts.balance
FROM accounts
ORDER BY account_type ASC, balance DESC;

SELECT name, phone
FROM customers
ORDER BY phone ASC NULLS LAST; -- nulls last, nulls first

-- LIMIT, OFFSET
-- 일반적
SELECT balance
FROM accounts
ORDER BY balance DESC
LIMIT 3;

SELECT balance
FROM accounts
ORDER BY balance DESC
LIMIT 3 OFFSET 3;

SELECT balance
FROM accounts
ORDER BY balance DESC
LIMIT 3 OFFSET 6;
-- 데이터가 수 백만건이 되면
-- Cursor Paging

SELECT NOW();
-- 현재 날짜, 시각, 타임존 정보
-- -> +09 : 한국 표준시 (UTC + 9)

SELECT CURRENT_DATE;
-- 날짜

SELECT CURRENT_TIMESTAMP;
-- == NOW()

-- DATE_TRUNC: 지정한 날짜 단위 이후의 단위들을 제거하는 함수
-- 해당월 첫번 째 날 (1일) 00:00:00로 표시
SELECT name, created_at, DATE_TRUNC('month', created_at) AS 가입월
FROM customers;

-- DATE_TRUNC('day', created_at) : 00:00:00
-- 해당일 00:00:00로 표시
SELECT name, created_at, DATE_TRUNC('day', created_at) AS 가입일
FROM customers;
-- DATE_TRUNC('hour', created_at) : 정각
-- 해당 시간 00분 00초로 표시
SELECT name, created_at, DATE_TRUNC('hour', created_at) AS 가입월
FROM customers;
-- year, week, quarter, minute

-- EXTRACT("시간 단위" FROM "컬럼명")
-- 특정 시간 단위를 지정해서 값 추출
SELECT name,
       EXTRACT(YEAR FROM created_at)  AS 가입연도,
       EXTRACT(MONTH FROM created_at) AS 가입월,
       EXTRACT(DOW FROM created_at)   AS 요일번호 -- Day of Weeks -> 0이 일요일, 1일 월요일
FROM customers;

-- 타임존 을 설정한 현재시간 조회
SELECT NOW()                                 AS 서버시각,
       NOW() AT TIME ZONE 'UTC'              AS UTC시각,
       NOW() AT TIME ZONE 'America/New_York' AS 뉴욕시각;
