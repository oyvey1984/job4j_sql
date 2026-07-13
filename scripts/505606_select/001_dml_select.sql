SELECT * FROM users u;

SELECT u.name, u.email FROM users u;

SELECT u.id user_id, u.name user_name, u.email user_email FROM users u;

SELECT
    oi.id order_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price line_total
FROM order_items oi;

SELECT
    id,
    name,
    price,
    price * 0.9 discounted_price
FROM products p;