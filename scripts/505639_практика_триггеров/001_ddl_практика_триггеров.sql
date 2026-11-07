ALTER TABLE movies
ADD COLUMN price NUMERIC(12,2) NOT NULL DEFAULT 0;


CREATE OR REPLACE FUNCTION check_payments_salary()
RETURNS TRIGGER AS
$$
BEGIN
	IF NEW.price < 0 THEN
	RAISE EXCEPTION 'Стоимость фильма не может быть отрицательной.';
	END IF;

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER check_payments_salary_trigger
BEFORE INSERT OR UPDATE
ON movies
FOR EACH ROW
EXECUTE FUNCTION check_payments_salary();

CREATE TABLE movie_price_history
(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	movie_id BIGINT NOT NULL REFERENCES movies(id),
	old_price NUMERIC(12,2) NOT NULL,
	new_price NUMERIC(12,2) NOT NULL,
	change_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION save_price_history()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO movie_price_history
	(
		movie_id,
		old_price,
		new_price
	)
	VALUES
	(
		OLD.id,
		OLD.price,
		NEW.price
	);

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER save_price_history_trigger
AFTER UPDATE OF price
ON movies
FOR EACH ROW
WHEN (OLD.price IS DISTINCT FROM NEW.price)
EXECUTE FUNCTION save_price_history();
