SELECT
	o.status,
	COUNT(o.id)
FROM orders o
GROUP BY o.status;

SELECT
	u.id user_id,
	u."name" user_name,
	SUM(quantity * unit_price) total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY u.id;

SELECT
	p.id product_id,
	p."name" product_name,
	COUNT(oi.id) order_items_count,
	SUM(oi.quantity) total_quantity
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id ;

SELECT
    o.id AS order_id,
    COUNT(*) AS items_count,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id;

SELECT
	u.id user_id,
	u."name" user_name,
	o.status status,
	COUNT(*) orders_count
FROM users u
JOIN orders o ON u.id = o.user_id
GROUP BY u.id, o.status
ORDER BY u.id;

SELECT
	oi.product_id product_id,
	p."name" product_name,
	MIN(oi.unit_price) min_unit_price,
	MAX(oi.unit_price) max_unit_price,
	AVG(oi.unit_price) avg_unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY oi.product_id, p."name" ;

SELECT
	u.id user_id,
	u."name" user_name,
	COUNT(o.id) orders_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id;
