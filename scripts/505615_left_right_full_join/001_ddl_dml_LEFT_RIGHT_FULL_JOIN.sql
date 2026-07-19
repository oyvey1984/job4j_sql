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
