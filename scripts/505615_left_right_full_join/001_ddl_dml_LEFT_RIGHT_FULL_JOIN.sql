CREATE TABLE payments
(
    id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id   BIGINT         NOT NULL REFERENCES orders (id),
    amount     NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    status     TEXT           NOT NULL,
    created_at TIMESTAMPTZ    NOT NULL DEFAULT now()
);

INSERT INTO payments (order_id, amount, status)
VALUES (1, 129990.00, 'PAID'),
       (3, 4990.00, 'FAILED');

INSERT INTO payments (order_id, amount, status)
VALUES (65, 36599.00, 'PAID'),
       (66, 358795.00, 'FAILED');

CREATE TABLE roles
(
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL
);

CREATE TABLE user_roles
(
    user_id BIGINT NOT NULL REFERENCES users (id),
    role_id BIGINT NOT NULL REFERENCES roles (id),
    PRIMARY KEY (user_id, role_id)
);

INSERT INTO roles (code, name)
VALUES ('ADMIN', 'Administrator'),
       ('CUSTOMER', 'Customer'),
       ('MANAGER', 'Manager'),
       ('SUPPORT', 'Support');

INSERT INTO user_roles (user_id, role_id)
VALUES (1, 1),
       (1, 2),
       (2, 2);

CREATE TABLE environments
(
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code TEXT NOT NULL UNIQUE
);

INSERT INTO environments (code)
VALUES ('dev'), ('stage'), ('prod');

CREATE TABLE categories
(
    id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name      TEXT NOT NULL,
    parent_id BIGINT REFERENCES categories (id)
);

INSERT INTO categories (name, parent_id)
VALUES
    ('Электроника', NULL),
    ('Смартфоны', 1),
    ('Ноутбуки', 1),
    ('Аксессуары', 1),
    ('Чехлы', 4);


SELECT
	u.id user_id,
	u.name user_name,
	count(o.id) order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id
ORDER BY order_count DESC;

SELECT
	o.id,
	o.status,
	o.created_at
FROM orders o
LEFT JOIN payments p ON o.id = p.order_id
WHERE p.order_id IS NULL;

SELECT
    p.id product_id,
    p.name product_name,
    COUNT(oi.id) order_count
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY order_count DESC;

SELECT
	r.id role_id,
	r.name role_name,
	count(ur.user_id)
FROM roles r
LEFT JOIN user_roles ur ON r.id = ur.role_id
GROUP BY r.id
ORDER BY role_id;

SELECT
	u.id,
	u."name",
	ur.role_id
FROM users u
LEFT JOIN user_roles ur ON u.id = ur.user_id
WHERE ur.role_id IS NULL;

SELECT
	r.id role_id,
	ur.user_id user_id
FROM roles r
FULL JOIN user_roles ur ON r.id = ur.role_id;

SELECT
	r.code,
	e.code
FROM roles r
CROSS JOIN environments e;

SELECT
	c.id,
	c."name" category_name,
	c2."name" parent_category_name
FROM categories c
LEFT JOIN categories c2 ON c.parent_id = c2.id
