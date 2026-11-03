CREATE OR REPLACE FUNCTION calculate_discount(
	price NUMERIC,
	discount_percent NUMERIC
	)
RETURNS NUMERIC
AS
$$
BEGIN
	RETURN price * (100 - discount_percent) / 100;
END;
$$
LANGUAGE plpgsql;

SELECT calculate_discount(2500, 15);

CREATE OR REPLACE FUNCTION full_name(
	first_name TEXT,
	surname TEXT
)
RETURNS TEXT
AS
$$
BEGIN
	RETURN CONCAT(first_name, ' ', surname);
END;
$$
LANGUAGE plpgsql;

SELECT full_name('Иван', 'Иванов');

CREATE OR REPLACE PROCEDURE increase_category_prices(
	category_name TEXT,
	percent NUMERIC
)
LANGUAGE SQL
AS
$$
	UPDATE products
	SET price = ROUND(price * (100 + percent) / 100, 2)
	WHERE category = category_name
$$;

CALL increase_category_prices('Аудио', 10);

CREATE TABLE orders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE orders_archive (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

INSERT INTO orders (user_id, created_at)
VALUES
	(1, '2026-11-03 20:51:00'),
	(2, '2026-10-03 20:51:00'),
	(3, '2024-09-03 20:51:00'),
	(4, '2025-08-03 20:51:00')
RETURNING *;

CREATE OR REPLACE PROCEDURE archive_old_orders()
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO orders_archive (
        id,
        user_id,
        created_at
    )
    SELECT
        id,
        user_id,
        created_at
    FROM orders
    WHERE created_at < NOW() - INTERVAL '1 year';

    DELETE FROM orders
    WHERE created_at < NOW() - INTERVAL '1 year';
END;
$$;

CALL archive_old_orders();

SELECT * FROM orders_archive;

SELECT * FROM orders;