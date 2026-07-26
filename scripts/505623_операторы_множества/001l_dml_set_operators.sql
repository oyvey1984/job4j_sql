SELECT
	u.id user_id
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'PAID'
UNION
SELECT
	u.id user_id
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'NEW';

SELECT
	'user' entity_type,
	u.id entity_id,
	u.created_at created_at
FROM users u
UNION ALL
SELECT
	'product' entity_type,
	p.id entity_id,
	p.created_at created_at
FROM products p
UNION ALL
SELECT
	'order' entity_type,
	o.id entity_id,
	o.created_at created_at
FROM orders o
ORDER BY created_at DESC;

SELECT
	p.id product_id,
	p."name" product_name
FROM products p
WHERE p.is_active = true
INTERSECT
SELECT
	oi.product_id,
	p."name"
FROM order_items oi
JOIN products p ON oi.product_id = p.id ;

SELECT
	p.id product_id,
	p."name" product_name
FROM products p
WHERE p.is_active = true
EXCEPT
SELECT
	oi.product_id,
	p."name"
FROM order_items oi
JOIN products p ON oi.product_id = p.id ;

SELECT
	u.id user_id,
	u."name" user_name
FROM users u
JOIN orders o ON u.id = o.user_id
UNION
SELECT
	u.id user_id,
	u."name" user_name
FROM users u
WHERE u.created_at > '2025-01-01'

SELECT
	p.id product_id,
	p."name" product_name,
	p.price price
FROM products p
WHERE p.price > (
					SELECT AVG(p2.price)
					FROM products p2
					)
INTERSECT
SELECT
	oi.product_id product_id,
	p."name" product_name,
	p.price price
FROM order_items oi
JOIN products p ON oi.product_id = p.id;

SELECT
	u.id user_id,
	u."name" user_name
FROM users u
JOIN orders o ON u.id = o.user_id
EXCEPT
SELECT
	u.id user_id,
	u.name user_name
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'CANCELLED';

SELECT
	'user' entity_type,
	u.id entity_id,
	u."name" display_name
FROM users u
UNION ALL
SELECT
	'product' entity_type,
	p.id entity_id,
	p."name" display_name
FROM products p