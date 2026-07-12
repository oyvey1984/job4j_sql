select * from users u ;

select u.name, u.email  from users u ;

select u.id user_id, u.name user_name, u.email user_email from users u;

select
oi.id order_id,
oi.product_id,
oi.quantity,
oi.unit_price,
oi.quantity * oi.unit_price line_total from order_items oi;

select
id,
name,
price,
price * 0.9 discounted_price
from products p;