WITH order_items_total AS (
	SELECT
		oi.id order_items_id,
		oi.order_id order_id,
		oi.quantity * oi.unit_price total
	FROM order_items oi
),
order_total AS (
SELECT
	oit.order_id order_id,
	SUM(total) total_amount
FROM order_items_total oit
GROUP BY oit.order_id
)
SELECT
	ot.order_id order_id,
	ot.total_amount  total_amount
FROM order_total ot;

WITH user_totals AS (
    SELECT
        o.user_id,
        SUM(oi.quantity * oi.unit_price) AS total_amount
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.id
    WHERE o.status = 'PAID'
    GROUP BY o.user_id
),
average_total AS (
    SELECT AVG(total_amount) AS avg_total
    FROM user_totals
)
SELECT
    u.id,
    u.name,
    ut.total_amount
FROM users u
JOIN user_totals ut ON ut.user_id = u.id
CROSS JOIN average_total at
WHERE ut.total_amount > at.avg_total;

WITH ordered_products AS (
	SELECT
		oi.product_id
	FROM order_items oi
	JOIN orders o ON oi.order_id = o.id
	WHERE o.status = 'PAID'
)
SELECT
	p.id product_id,
	p."name" product_name
FROM products p
WHERE p.id NOT IN (SELECT
						op.product_id
					FROM ordered_products op);

WITH ordered_products AS (
	SELECT
		oi.product_id,
		SUM(oi.quantity) total_quantity
	FROM order_items oi
	JOIN orders o ON oi.order_id = o.id
	WHERE o.status = 'PAID'
	GROUP BY oi.product_id
)
SELECT
	p.id product_id,
	p."name" product_name,
	op.total_quantity total_quantity
FROM products p
JOIN ordered_products op ON p.id = op.product_id
ORDER BY op.total_quantity DESC
LIMIT 5;

