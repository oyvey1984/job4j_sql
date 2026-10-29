CREATE TABLE employees
(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
full_name TEXT NOT NULL,
salary NUMERIC(10,2) NOT NULL,
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS
$$
BEGIN
	NEW.updated_at = NOW();
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER update_updated_at_trigger
BEFORE UPDATE
ON employees
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

INSERT INTO employees (full_name, salary)
VALUES
	('Ivan', 100000.50);

UPDATE employees e
SET full_name = 'Ivan Petrov'
WHERE id = 1;

CREATE TABLE orders
(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
status TEXT NOT NULL,
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE order_status_history
(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
order_id BIGINT NOT NULL,
old_status TEXT NOT NULL,
new_status TEXT NOT NULL,
change_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION save_status_history()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO order_status_history (
		order_id,
		old_status,
		new_status
	)
	VALUES (
		OLD.id,
		OLD.status,
		NEW.status
	);

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER order_status_history_trigger
AFTER UPDATE OF status
ON orders
FOR EACH ROW
WHEN (OLD.price IS DISTINCT FROM NEW.price)
EXECUTE FUNCTION save_status_history();

INSERT INTO orders (status)
VALUES ('new')
RETURNING *;

UPDATE orders o
SET status = 'paid'
WHERE id = 1;

UPDATE orders o
SET status = 'old'
WHERE id = 1;

SELECT * FROM order_status_history osh

CREATE OR REPLACE FUNCTION check_employee_salary ()
RETURNS TRIGGER AS
$$
BEGIN
	IF NEW.salary < 0 THEN
	RAISE EXCEPTION 'Зарплата сотрудника не может быть отрицательной.';
	END IF;

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER check_employee_salary_trigger
BEFORE INSERT OR UPDATE
ON employees
FOR EACH ROW
EXECUTE FUNCTION check_employee_salary ();

INSERT INTO employees (full_name , salary)
VALUES ('Ivan Ivanov', -100000.33)
RETURNING *;


CREATE TABLE products (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
name TEXT NOT NULL,
price NUMERIC(12,2) NOT NULL,
is_active BOOLEAN NOT NULL DEFAULT true,
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
CONSTRAINT price_positive CHECK (price > 0)
);

CREATE OR REPLACE FUNCTION trim_product_name()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.name = TRIM(NEW.name);
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trim_product_name_trigger
BEFORE INSERT OR UPDATE
ON products
FOR EACH ROW
EXECUTE FUNCTION trim_product_name();

INSERT INTO products (name, price)
VALUES ('   Ноутбук   ', 1000.00);

SELECT * FROM products p ;

CREATE TABLE product_price_history
(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
product_id BIGINT NOT NULL,
old_price NUMERIC(12,2) NOT NULL,
new_price NUMERIC(12,2) NOT NULL,
change_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION save_price_history()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO product_price_history (
		product_id,
		old_price,
		new_price
	)
	VALUES (
		OLD.id,
		OLD.price,
		NEW.price
	);

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER product_price_history_trigger
AFTER UPDATE OF price
ON products
FOR EACH ROW
WHEN (OLD.price IS DISTINCT FROM NEW.price)
EXECUTE FUNCTION save_price_history();

INSERT INTO products (name, price, is_active)
VALUES ('notebook', 555.66, TRUE)
RETURNING *;

UPDATE products p
SET price = 777
WHERE name = 'notebook';

SELECT * FROM products p;