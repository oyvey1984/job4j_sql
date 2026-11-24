CREATE TABLE orders (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
customer_name TEXT NOT NULL,
status TEXT NOT NULL
);

CREATE TABLE order_items (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
order_id BIGINT NOT NULL REFERENCES orders(id),
product_name TEXT NOT NULL,
quantity INTEGER NOT NULL CHECK (quantity > 0),
price NUMERIC(12,2) NOT NULL CHECK (price > 0)
);

BEGIN;

INSERT INTO orders (customer_name, status)
VALUES
	('Иван Петров','NEW')
RETURNING id;;

SAVEPOINT order_created;

INSERT INTO order_items (order_id, product_name, quantity, price)
VALUES
	(6, 'Ноутбук', 1, 90000.00),
	(6, 'Мышь', 2, 2500.00);

SAVEPOINT items_added;

INSERT INTO order_items (order_id, product_name, quantity, price)
VALUES
	(6, 'Монитор', -2, 30000.00);

ROLLBACK TO items_added;

INSERT INTO order_items (order_id, product_name, quantity, price)
VALUES
	(6, 'Монитор', 1, 30000.00);

UPDATE orders o
SET status = 'PROCESSING'
WHERE o.customer_name = 'Иван Петров';

ROLLBACK TO order_created;

SELECT *
FROM orders;

SELECT *
FROM order_items
ORDER BY id;

INSERT INTO order_items (order_id, product_name, quantity, price)
VALUES
	(6, 'Монитор', 2, 28000.00),
	(6, 'Ноутбук', 1, 85000.00),
	(6, 'Клавиатура', 1, 7000.00);

COMMIT;

SELECT *
FROM orders;

SELECT *
FROM order_items
ORDER BY id;
