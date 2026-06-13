/*

CREATE TABLE 테이블 이름 (
    컬럼이름 데이터타입 제약조건,
    컬럼이름 데이터타입 제약조건,
    ...
);
 */

/*
기본 키(Primary Key)
    - 각 행을 고유하게 구분하는 값
    - 실무에선 자동으로 증가하는 값(Auto Increment)을 자주 사용함
        - 별도의 값을 넣지 않아도 PostgreSQL에서 자동으로 증가시켜서 채워줌
        - 문제는 서로 다른 DB를 병합할 때 둘다 자동 증가값을 PK로 썼으면 재앙임
    - 직접 지정도 가능(어플리케이션에서)
        - ULID:
            - 정렬되지 않는 기존 UUID의 단점을 보완하기 위해서 만들어짐
            - 128비트 식별자
            - 타임 스탬프가 포함됨 => 시간 순으로 정렬 가능 => 인덱스 효율 증가
        - UUID
            - 128-bit(16바이트)
            - v7 이전
                - 스토리지 비용 증가
                - DB 성능 저하
                    - 특히 MySQL은 PK를 기준으로 정렬함(Clustered Index)
                    - 임의의 값이라서 데이터를 중간에 끼워넣기 위해 인덱스 분할, 재정렬이 빈번
                    - 인덱스 파편화 현상 발생(인덱스가 물리적으로 흩어지거나 낭비되는 현상)
            - v7 이후
                - 2024년 공식 표준(RFC 9562)으로 승인
                - 앞부분 48비트에 Unix Timestamp 포함
                - DB 인덱스 파편화 문제를 해결하면서 UUID의 장점을 그대로 가짐
 */

/*
PostgreSQL에서 제공하는 자동 증가값 데이터 타입
- SERIAL
    - INTEGER 범위
    - 일반 적인 경우에 해당
- BIGSERIAL
    - BIGINT 범위
    - 거래 내역 같은 것
 */

CREATE TABLE test
(
    customer_id BIGSERIAL PRIMARY KEY
);

DROP TABLE test;

/*
데이터 제약 조건
- DB 레이어에서 데이터 검증 가능
- 여러 어플리케이션에서 사용하는 경우 애플리케이션 레이어에서 하나하나 지정할 필요가 없음
- PRIMARY KEY
    - 기본키 제약
- UNIQUE
    - 중복 금지 제약
- DEFAULT
    - 생략시 기본값 지정
- NOT NULL
    - 값 반드시 포함
- CHECK
    - 컬럼에 지정되는 값이 특정 조건을 만족하는지 확인함
    - 자주 사용되지 않음
    - CHECK(TRUE/FALSE로 판별될 수 있는 식)
 */

CREATE TABLE IF NOT EXISTS customers
(
    customer_id BIGSERIAL PRIMARY KEY,
    name        varchar(100)        NOT NULL,
    email       varchar(255) UNIQUE NOT NULL,
    phone       varchar(20),
    created_at  timestamptz DEFAULT NOW() -- NOW() 현재 시간 함수
);

CREATE TABLE IF NOT EXISTS accounts
(
    account_id   BIGSERIAL PRIMARY KEY,
    customer_id  BIGINT      NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance      NUMERIC(15, 2) DEFAULT 0, -- NUMERIC(15, 2) 소수점 이하 2자리까지 저장
    created_at   TIMESTAMPTZ    DEFAULT NOW(),
    CHECK (balance >= 0)                   -- 잔액이 0보다 적어지는걸 검사
);

-- NOT NULL 제약 위반
INSERT INTO customers(email)
VALUES ('test@gmail.com');
-- [23502] ERROR: null value in column "name" of relation "customers" violates not-null constraint

-- UNIQUE 제약 위반
INSERT INTO customers (name, email)
VALUES ('tom', 'ttt@example.com');
INSERT INTO customers (name, email)
VALUES ('tom duplicated', 'ttt@example.com');
-- [23505] ERROR: duplicate key value violates unique constraint "customers_email_key"
-- Detail: Key (email)=(jisu@example.com) already exists.

-- CHECK 제약 위반
INSERT INTO accounts (customer_id, account_type, balance)
VALUES (1, 'checking', -1000);
-- [23514] ERROR: new row for relation "accounts" violates check constraint "accounts_balance_check"
-- Detail: Failing row contains (1, 1, checking, -1000.00, 2026-06-13 02:44:17.628465+00).
