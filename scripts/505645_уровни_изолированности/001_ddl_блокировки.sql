CREATE TABLE accounts (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner TEXT NOT NULL,
    balance NUMERIC(12, 2) NOT NULL
);

INSERT INTO accounts (owner, balance)
VALUES
    ('Алексей', 10000.00),
    ('Мария', 15000.00),
    ('Иван', 20000.00);

-- Транзакция 1
BEGIN;

SELECT *
FROM accounts a
WHERE id = 1
FOR UPDATE;

-- Транзакция 2
BEGIN;

UPDATE accounts a
SET balance = balance + 100
WHERE id = 1;

SELECT
    pid,
    state,
    wait_event_type,
    wait_event,
    pg_blocking_pids(pid) AS blocking_pids,
    xact_start,
    query
FROM pg_stat_activity
WHERE datname = current_database();

SELECT
    pid,
    locktype,
    relation,
    mode,
    granted
FROM pg_locks
WHERE pid IS NOT NULL;

-- Транзакция 1
BEGIN;

UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

-- Транзакция 2
BEGIN;

UPDATE accounts
SET balance = balance - 500
WHERE id = 2;

UPDATE accounts
SET balance = balance + 500
WHERE id = 1;

-- Транзакция 1
BEGIN;

UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

COMMIT;

-- Транзакция 2
BEGIN;

UPDATE accounts
SET balance = balance + 500
WHERE id = 1;

UPDATE accounts
SET balance = balance - 500
WHERE id = 2;

COMMIT;

