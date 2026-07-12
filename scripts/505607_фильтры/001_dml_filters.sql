SELECT id, name, price, is_active
FROM products
WHERE is_active = true;

SELECT id, name, price
FROM products
WHERE price between 10000 and 100000;

select id, user_id, status, created_at
from orders
where status in ('NEW', 'PAID');

insert into orders (user_id, status)
values
(1, 'CANCELLED'),
(1, 'CANCELLED');

insert into order_items (order_id, product_id, quantity, unit_price)
values
(3, 2, 3, 1200),
(4, 1, 4, 2000);

select id, user_id, status, created_at
from orders
where user_id = 1 and status <> 'CANCELLED';

select id, name, email, created_at
from users
where created_at > TIMESTAMPTZ '2026-01-01 00:00:00+00' ;

select id, name, price
from products
where price < 20000 OR price > 80000;

select id, name, price
from products
where is_active = true and (price < 3000 OR price > 150000);