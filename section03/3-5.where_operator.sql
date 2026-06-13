SELECT *
FROM accounts
WHERE balance > 100000;

-- 같지 않음
-- <>(이게 표준이긴 함) or !=

SELECT *
FROM accounts
WHERE account_type <> 'checking';

SELECT *
FROM accounts
WHERE account_type != 'checking';

-- AND, OR, NOT

SELECT *
FROM accounts
WHERE balance > 100000
  AND account_type = 'checking';

SELECT *
FROM accounts
WHERE balance < 600000
   OR balance > 3000000;

-- NOT 뒤에 조건 반대
SELECT *
FROM accounts
WHERE NOT account_type = 'checking';

-- IN, NOT IN

SELECT *
FROM accounts
WHERE customer_id IN (1, 3, 5);

SELECT *
FROM accounts
WHERE customer_id NOT IN (1, 3, 5);

-- BETWEEN 시작값 AND 끝값
-- 부등호와 같음
-- 좀더 보기 쉬움

SELECT *
FROM accounts
WHERE balance BETWEEN 500000 AND 1500000;
-- balance >= 500000 AND balance <= 1500000

-- LIKE : %, _
-- 문자열 패턴 매칭

SELECT *
FROM customers
WHERE email LIKE '%@example.com';

-- 대소문자 구분 없음
SELECT *
FROM customers
WHERE email ILIKE '%@example.com';
-- example.com, EXAMPLE.com

-- = NULL -> IS NULL or IS NOT NULL
SELECT *
FROM customers
WHERE phone IS NULL;

SELECT *
FROM customers
WHERE phone IS NOT NULL;

-- COALESCE(대상 컬럼, NULL 이면 쓸 값)
SELECT name, COALESCE(phone, '미등록') AS 전화번호
FROM customers;
-- NULLIF