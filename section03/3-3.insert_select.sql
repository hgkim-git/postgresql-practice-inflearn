/*
데이터 삽입(INSERT)

 */
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers
(
    customer_id BIGSERIAL PRIMARY KEY,
    name        varchar(100)        NOT NULL,
    email       varchar(255) UNIQUE NOT NULL,
    phone       varchar(20),
    created_at  timestamptz DEFAULT NOW() -- NOW() 현재 시간 함수
);
DROP TABLE IF EXISTS accounts;
CREATE TABLE IF NOT EXISTS accounts
(
    account_id   BIGSERIAL PRIMARY KEY,
    customer_id  BIGINT      NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance      NUMERIC(15, 2) DEFAULT 0, -- NUMERIC(15, 2) 소수점 이하 2자리까지 저장
    created_at   TIMESTAMPTZ    DEFAULT NOW(),
    CHECK (balance >= 0)                   -- 잔액이 0보다 적어지는걸 검사
);
INSERT INTO customers
    (name, email, phone)
VALUES ('김지수', 'jisu@example.com', '010-1234-5678');

-- 데이터를 다중 INSERT
-- INSERT 문 하나씩 하는건 데이터 통신 비용, 옵티마이져 쿼리 파싱 비용등 비효율적임
-- Bulk write, bulk insert 라고 함
INSERT INTO customers
    (name, email, phone)
VALUES ('박민준', 'minjun@example.com', '010-9876-5432'),
       ('이하은', 'haeun@example.com', '010-5555-1234'),
       ('최서준', 'seojun@example.com', '010-2222-3333'),
       ('정유나', 'yuna@example.com', NULL); -- phone 에는 NOT NULL 조건 없음

INSERT INTO accounts (customer_id, account_type, balance)
VALUES (1, 'checking', 500000),
       (2, 'checking', 1200000),
       (3, 'savings', 3000000),
       (4, 'checking', 800000),
       (5, 'savings', 2500000);

-- RETURNING
-- INSERT 한 구문의 ROW 를 SELECT 해서 보여줌
INSERT INTO customers (name, email)
VALUES ('한도윤', 'doyun@example.com')
RETURNING customer_id, name, created_at;

-- *(와일드 카드) 로 전체 컬럼 축약
INSERT INTO customers (name, email, phone)
VALUES ('오세진', 'sejin@example.com', '010-7777-8888')
RETURNING *;

-- ---------------------------------------------------

SELECT *
FROM customers;

SELECT name, email
FROM customers;

-- 별칭 붙이기
SELECT name AS 고객명, email AS 이메일
FROM customers;

-- 조회된 데이터에 문자열 합치기(합친 컬럼명에는 AS를 써주어야 함, 안그럼 이상한 컬럼명으로 출력됨)
SELECT name || '님' AS 호칭, email
FROM customers;

-- 여러 컬럼을 합쳐서 출력도 가능(이것도 AS 로 컬럼명 지정 필요)
SELECT name || '님 (' || email || ')' AS 합치기
FROM customers;

-- DISTINCT 로 중복 제거
SELECT DISTINCT account_type
FROM accounts;

-- WHERE 조건
SELECT *
FROM customers
WHERE customer_id = 1;