UPDATE customers
SET phone = '010-1111-222'
WHERE customer_id = 1;

UPDATE customers
SET name  = '김지수(수정)',
    phone = '010-9999-0000'
WHERE customer_id = 1;

-- UPDATE에도 RETURNING 사용 가능
UPDATE accounts
SET balance = balance + 100000
WHERE account_id = 1
RETURNING account_id, balance;

-- 테이블에 모든 ROW 업데이트. WHERE 절이 없는 경우는 거~의 없다
-- UPDATE customers
-- SET phone = '000-0000-0000';

DELETE
FROM customers
WHERE customer_id = 7;

-- DELETE도 항상 WHERE 누락 조심
-- DELETE FROM customers;

-- DELETE 에도 RETURNING 사용 가능
-- INSERT INTO customers(name, email, phone)
-- VALUES ('테스트', '테스트', '')
-- RETURNING *;
DELETE
FROM customers
WHERE customer_id = 8
RETURNING *;
