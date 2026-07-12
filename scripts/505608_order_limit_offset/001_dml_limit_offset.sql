    select id, name, price
    from products
    order by name;

    select id, name, price
    from products
    where is_active = true
    order by price
    limit 5;

    select id, user_id, status, created_at
    from orders
    order by created_at desc
    limit 10;

    select id, name, email
    from users u
    order by created_at DESC, id DESC
    limit 20 offset 20;

    select *
    from order_items
    order by order_id, unit_price desc, id;

    select id, name, price
    from products
    order by price desc, id
    limit 3 offset 6;
