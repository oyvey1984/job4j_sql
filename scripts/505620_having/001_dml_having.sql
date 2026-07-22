SELECT
	o.status status,
	COUNT(*) orders_count
FROM orders o
GROUP BY o.status
HAVING COUNT(*) >= 3 ;

SELECT
	o.user_id user_id,
	u."name" user_name,
	SUM(oi.quantity * oi.unit_price) total_spent
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.user_id, u."name"
HAVING SUM(oi.quantity * oi.unit_price) > 10000;

SELECT
	oi.product_id product_id,
	p."name" product_name,
	COUNT(oi.quantity) total_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE oi.unit_price >= 1000
GROUP BY oi.product_id, p."name"
HAVING COUNT(oi.quantity) >= 5;

SELECT
	o.user_id user_id,
	u."name" user_name,
	o.status status,
	COUNT(*) orders_count
FROM orders o
JOIN users u ON o.user_id = u.id
GROUP BY o.user_id, u."name", o.status
HAVING COUNT(*) > 1;

SELECT
	o.user_id user_id,
	u."name" user_name,
	COUNT(*) paid_orders_count
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.status = 'PAID'
GROUP BY o.user_id, u."name"
HAVING COUNT(*) > 1;

SELECT
	oi.product_id product_id,
	p."name" product_name,
	MIN(oi.unit_price) min_unit_price,
	MAX(oi.unit_price) max_unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY oi.product_id , p."name"
HAVING MAX(oi.unit_price) > 5000;

SELECT
	o.status status,
	AVG(oi.unit_price * oi.quantity) avg_line_total
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.created_at >= DATE '2025-01-01'
GROUP BY o.status
HAVING AVG(oi.unit_price * oi.quantity) > 2000;