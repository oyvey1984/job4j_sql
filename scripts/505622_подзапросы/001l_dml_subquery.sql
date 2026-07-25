SELECT
	p.id product_id,
	p."name" product_name,
	p.price price
FROM products p
WHERE p.price < (
	SELECT AVG(price)
	FROM products
);

SELECT
    u.id user_id,
    u."name" user_name,
    u.email email
FROM users u
WHERE EXISTS (
	SELECT 1
	FROM orders o
	WHERE u.id = o.user_id AND o.status = 'PAID'
);

SELECT
    u.id user_id,
    u."name" user_name,
    u.email email
FROM users u
WHERE NOT EXISTS (
	SELECT 1
	FROM orders o
	WHERE u.id = o.user_id
);

SELECT
	p.id product_id,
	p."name" product_name,
	p.price price
FROM products p
WHERE p.id IN (
	SELECT
		oi.product_id
	FROM order_items oi
);

SELECT
	t.order_id,
	t.order_total
FROM
	(
	SELECT
		oi.order_id,
		SUM(oi.quantity * oi.unit_price) order_total
	FROM order_items oi
	GROUP BY oi.order_id
	) t
WHERE t.order_total > 10000

SELECT
	u.id user_id,
	u."name" user_name,
	(
	SELECT
		COUNT(*)
	FROM orders o
	WHERE o.user_id = u.id
	) orders_count
FROM users u;

SELECT
    product_id,
    SUM(quantity) AS total_quantity
FROM order_items
GROUP BY product_id
HAVING SUM(quantity) > (
    SELECT AVG(total_quantity)
    FROM (
        SELECT
            product_id,
            SUM(quantity) AS total_quantity
        FROM order_items
        GROUP BY product_id
    ) AS product_totals
);

SELECT
    t.order_id,
    t.order_total
FROM (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS t
WHERE t.order_total > (
    SELECT AVG(order_total)
    FROM (
        SELECT
            order_id,
            SUM(quantity * unit_price) AS order_total
        FROM order_items
        GROUP BY order_id
    ) AS order_totals
);