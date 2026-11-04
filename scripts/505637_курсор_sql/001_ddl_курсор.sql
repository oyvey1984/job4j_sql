BEGIN;

DECLARE products_cursor CURSOR FOR
SELECT id, name, price
FROM product;

FETCH 3 FROM products_cursor;
FETCH 2 FROM products_cursor;

CLOSE products_cursor;

COMMIT;


BEGIN;

DECLARE orders_cursor CURSOR FOR
SELECT id, user_id, created_at
FROM orders;

FETCH 5 FROM orders_cursor;
FETCH 5 FROM orders_cursor;

CLOSE orders_cursor;

COMMIT;

BEGIN;

DECLARE orders_cursor SCROLL CURSOR FOR
SELECT id, user_id, created_at
FROM orders;

FETCH 2 FROM orders_cursor;
MOVE BACKWARD 2 FROM orders_cursor;
FETCH 2 FROM orders_cursor;

CLOSE orders_cursor;

COMMIT;


