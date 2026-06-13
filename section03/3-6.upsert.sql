-- 없으면 INSERT, 있으면 UPDATE
-- INSERT ON CONFLICT
--> MySQL : ON Duplicated

INSERT INTO customers (name, email)
VALUES ('김지수', 'jisu@example.com');
-- ERROR: duplicate key value violates unique constraint "customers_email_key"
-- Detail: Key (email)=(jisu@example.com) already exists.

-- INSERT ON CONFLICT DO NOTHING

INSERT INTO customers (name, email)
VALUES ('김지수', 'jisu@example.com')
ON CONFLICT (email) DO NOTHING;

-- INSERT ON CONFLICT DO UPDATE SET

INSERT INTO customers (name, email)
VALUES ('김지수', 'jisu@example.com')
ON CONFLICT (email) DO UPDATE SET phone = excluded.phone; -- 지금 막 INSERT 하려 했던 새 데이터

INSERT INTO customers (name, email, phone)
VALUES ('김지수', 'jisu@example.com', '010-0000-1111')
ON CONFLICT (email) DO UPDATE SET name  = EXCLUDED.name, -- EXCLUDED == '김지수'
                                  phone = EXCLUDED.phone;
-- EXCLUDED == '010-0000-1111'

-- 계좌 잔액 갱신 시나리오
INSERT INTO accounts (account_id, customer_id, account_type, balance)
VALUES (1, 1, 'checking', 18000000)
ON CONFLICT (account_id) DO UPDATE SET balance = excluded.balance
RETURNING account_id, customer_id, account_type, balance;

INSERT INTO accounts (account_id, customer_id, account_type, balance)
VALUES (99, 3, 'checking', 500000)
ON CONFLICT (account_id) DO UPDATE SET balance = excluded.balance
RETURNING account_id, customer_id, account_type, balance