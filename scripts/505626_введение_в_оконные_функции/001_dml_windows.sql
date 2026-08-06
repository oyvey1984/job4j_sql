WITH order_totals AS (
SELECT
	o.id order_id,
	o.user_id user_id,
	SUM(oi.quantity * oi.unit_price) total_amount
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id
ORDER BY o.id, o.user_id
)
SELECT
	ot.order_id  order_id,
	ot.user_id  user_id,
	ot.total_amount total_amount,
	SUM(ot.total_amount) OVER (PARTITION BY user_id) AS user_total
FROM order_totals ot ;

WITH order_totals AS (
SELECT
	o.id order_id,
	o.user_id user_id,
	SUM(oi.quantity * oi.unit_price) total_amount
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id
ORDER BY o.id, o.user_id
)
SELECT
	ot.order_id  order_id,
	ot.user_id  user_id,
	ot.total_amount total_amount,
	AVG(ot.total_amount) OVER (PARTITION BY user_id) AS average_order_amount
FROM order_totals ot ;

WITH order_totals AS (
SELECT
	o.id order_id,
	o.user_id user_id,
	o.created_at created_at
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id
ORDER BY o.id, o.user_id
)
SELECT
	ot.order_id  order_id,
	ot.user_id  user_id,
	ot.created_at created_at,
	ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY ot.created_at) AS row_number
FROM order_totals ot ;

WITH order_totals AS (
SELECT
	o.id order_id,
	SUM(oi.quantity * oi.unit_price) total_amount
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id
ORDER BY o.id, o.user_id
)
SELECT
	ot.order_id order_id,
	ot.total_amount total_amount,
	RANK() OVER (ORDER BY ot.total_amount DESC) AS order_rank
FROM order_totals ot ;

WITH order_totals AS (
SELECT
	o.id order_id,
	SUM(oi.quantity * oi.unit_price) total_amount
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id
ORDER BY o.id, o.user_id
)
SELECT
	ot.order_id order_id,
	ot.total_amount total_amount,
	DENSE_RANK() OVER (ORDER BY ot.total_amount DESC) AS order_rank
FROM order_totals ot ;

WITH order_totals AS (
SELECT
	o.id order_id,
	SUM(oi.quantity * oi.unit_price) total_amount
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id
ORDER BY o.id, o.user_id
)
SELECT
	ot.order_id order_id,
	ot.total_amount total_amount,
	NTILE(4) OVER (ORDER BY ot.total_amount DESC) AS group_number
FROM order_totals ot ;

WITH order_totals AS (
SELECT
	o.id order_id,
	o.user_id user_id,
	SUM(oi.quantity * oi.unit_price) total_amount
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id
ORDER BY o.id, o.user_id
)
SELECT
	ot.order_id order_id,
	ot.user_id  user_id,
	ot.total_amount total_amount,
	SUM(ot.total_amount) OVER w AS user_total,
	AVG(ot.total_amount) OVER w AS average_order_amount,
	COUNT(*) OVER w AS orders_count
FROM order_totals ot
WINDOW w AS (PARTITION BY user_id);
