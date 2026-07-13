SELECT id, name, price, is_active
FROM products
WHERE is_active = true;

SELECT id, name, price
FROM products
WHERE price BETWEEN 10000 AND 100000;

SELECT id, user_id, status, created_at
FROM orders
WHERE status IN ('NEW', 'PAID');

INSERT INTO orders (user_id, status)
VALUES
(1, 'CANCELLED'),
(1, 'CANCELLED');

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
(3, 2, 3, 1200),
(4, 1, 4, 2000);

SELECT id, user_id, status, created_at
FROM orders
WHERE user_id = 1 AND status <> 'CANCELLED';

SELECT id, name, email, created_at
FROM users
WHERE created_at > TIMESTAMPTZ '2026-01-01 00:00:00+00';

SELECT id, name, price
FROM products
WHERE price < 20000 OR price > 80000;

SELECT id, name, price
FROM products
WHERE is_active = true AND (price < 3000 OR price > 150000);