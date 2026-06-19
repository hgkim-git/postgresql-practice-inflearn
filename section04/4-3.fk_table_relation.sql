CREATE TABLE transactions
(
    transaction_id BIGSERIAL PRIMARY KEY,
    account_id     BIGINT         NOT NULL,
    type           VARCHAR(10)    NOT NULL CHECK (type IN ('입금', '출금')),
    amount         NUMERIC(15, 2) NOT NULL CHECK (amount > 0),
    description    TEXT,
    created_at     TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO transactions (account_id, type, amount, description, created_at)
VALUES (1, '입금', 500000, '월급', '2024-10-05 09:00:00+09'),
       (1, '출금', 150000, '관리비', '2024-10-10 11:30:00+09'),
       (1, '출금', 80000, '식료품', '2024-10-15 14:20:00+09'),
       (1, '입금', 200000, '부수입', '2024-10-20 16:00:00+09'),
       (2, '입금', 300000, '적금 납입', '2024-10-01 10:00:00+09'),
       (2, '입금', 300000, '적금 납입', '2024-11-01 10:00:00+09'),
       (3, '입금', 1000000, '전세보증금 반환', '2024-10-12 15:00:00+09'),
       (3, '출금', 500000, '이체', '2024-10-18 13:00:00+09'),
       (3, '출금', 200000, '카드대금', '2024-11-05 10:30:00+09'),
       (4, '입금', 50000, '용돈', '2024-10-01 09:00:00+09'),
       (4, '출금', 30000, '편의점', '2024-10-08 20:10:00+09'),
       (4, '입금', 50000, '용돈', '2024-11-01 09:00:00+09'),
       (5, '입금', 2000000, '보너스', '2024-10-25 17:00:00+09'),
       (5, '출금', 800000, '여행경비', '2024-10-28 08:00:00+09'),
       (5, '출금', 450000, '가전제품', '2024-11-10 14:00:00+09'),
       (6, '입금', 300000, '적금 납입', '2024-11-01 10:00:00+09'),
       (6, '출금', 100000, '외식', '2024-11-15 19:30:00+09'),
       (7, '입금', 300000, '적금 납입', '2024-10-01 10:00:00+09'),
       (7, '입금', 300000, '적금 납입', '2024-11-01 10:00:00+09'),
       (8, '입금', 10000, '이자', '2024-10-31 00:00:00+09'),
       (8, '입금', 10000, '이자', '2024-11-30 00:00:00+09'),
       (1, '출금', 120000, '통신비', '2024-11-10 09:00:00+09'),
       (3, '입금', 750000, '월급', '2024-11-05 09:00:00+09');


-- 외래 키 : 한 테이블의 컬럼이 다른 테이블의 기본 키를 참조

ALTER TABLE accounts
    ADD CONSTRAINT fk_accounts_customer
        FOREIGN KEY (customer_id)
            REFERENCES customers (customer_id);

ALTER TABLE transactions
    ADD CONSTRAINT fk_transactions_account
        FOREIGN KEY (account_id)
            REFERENCES accounts (account_id);

INSERT INTO accounts (customer_id, account_type, balance)
VALUES (9999, '예금', 10000);

-- ERROR: insert or update on table "accounts" violates
--     foreign key constraint "fk_accounts_customer"
--     Detail: Key (customer_id)=(9999) is not present in table "customers"

-- RESTRICT : 참조하는 데이터가 있다면, 삭제가 불가능

ALTER TABLE accounts
    ADD CONSTRAINT fk_accounts_customer
        FOREIGN KEY (customer_id)
            REFERENCES customers (customer_id)
            ON DELETE RESTRICT;

-- CASCADE : 참조하는 행을 함께 삭제
--> ON DELETE CASCADE

-- SET NULL : 참조하는 컬럼을 NULL로 바꿔
--> ON DELETE SET NULL

-- 테이블 관계
-- 1:1, 1:N, N:M

-- customers <- (customer_id, 1:1) -> customer_profiles
CREATE TABLE customer_profiles
(
    profile_id  BIGSERIAL PRIMARY KEY,
    customer_id BIGINT UNIQUE NOT NULL,
    birth_date  DATE,
    address     TEXT,
    CONSTRAINT fk_profile_customer
        FOREIGN KEY (customer_id)
            REFERENCES customers (customer_id)
            ON DELETE CASCADE
);

-- customers -> accounts -> transcations

-- 은행 지점과 계좌  (N:M)
-- > 하나의 계좌는 여러 지점에서 서비스를 받을 수 있죠.
-- > 하나의 지점도 여러 계좌에 대한 서비스를 제공
--> mapper 테이블을 혼용해서 구성

-- accounts          account_branches     branches
-- account_id  ───<     account_id      >─── branch_id
--                      branch_id