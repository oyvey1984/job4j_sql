SELECT
	o.id AS order_id,
	o.status,
	u.email 
FROM orders o
INNER JOIN users u ON o.user_id = u.id
ORDER BY order_id ;
	
SELECT
	o.id AS order_id,
	oi.id AS order_item_id,
	oi.quantity AS quantity,
	p.name AS product_name
FROM
	orders AS o
INNER JOIN order_items oi ON oi.order_id = o.id
INNER JOIN products p ON p.id = oi.product_id
WHERE oi.quantity > 1;

SELECT
	o.id AS order_id,
	oi.quantity AS quantity,
	oi.unit_price AS price,
	p.name AS product_name
FROM
	orders AS o
INNER JOIN order_items oi ON oi.order_id = o.id
INNER JOIN products p ON p.id = oi.product_id
WHERE o.user_id = 1;

SELECT
	o.id AS order_id,
	u.name AS user_name
FROM
	orders AS o
INNER JOIN users u ON o.user_id  = u.id
WHERE o.status = 'NEW';

SELECT
	oi.id AS order_item_id,
	p.name AS product_name,
	oi.quantity AS quantity,
	oi.quantity * oi.unit_price AS line_total
FROM
	orders AS o
INNER JOIN order_items oi ON oi.order_id = o.id
INNER JOIN products p ON p.id = oi.product_id;