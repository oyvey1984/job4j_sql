SELECT id, name, price
FROM products
ORDER BY name;

SELECT id, name, price
FROM products
WHERE is_active = true
ORDER BY price
LIMIT 5;

SELECT id, user_id, status, created_at
FROM orders
ORDER BY created_at DESC
LIMIT 10;

SELECT id, name, email
FROM users u
ORDER BY created_at DESC, id DESC
LIMIT 20 OFFSET 20;

SELECT *
FROM order_items
ORDER BY order_id, unit_price DESC, id;

SELECT id, name, price
FROM products
ORDER BY price DESC, id
LIMIT 3 OFFSET 6;