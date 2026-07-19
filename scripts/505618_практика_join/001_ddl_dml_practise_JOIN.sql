DROP TABLE IF EXISTS cars;
DROP TABLE IF EXISTS car_bodies;
DROP TABLE IF EXISTS car_engines;
DROP TABLE IF EXISTS car_transmissions;

CREATE TABLE car_bodies (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE car_engines (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE car_transmissions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE cars (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    body_id BIGINT REFERENCES car_bodies(id),
    engine_id BIGINT REFERENCES car_engines(id),
    transmission_id BIGINT REFERENCES car_transmissions(id)
);

INSERT INTO car_bodies (name)
VALUES
    ('sedan'),
    ('hatchback'),
    ('wagon'),
    ('coupe'),
    ('crossover'),
    ('suv'),
    ('pickup'),
    ('minivan'),
    ('roadster'),
    ('liftback');

INSERT INTO car_engines (name)
VALUES
    ('1.6 gasoline'),
    ('2.0 gasoline'),
    ('2.5 gasoline'),
    ('3.0 gasoline'),
    ('1.9 diesel'),
    ('2.0 diesel'),
    ('3.0 diesel'),
    ('hybrid'),
    ('electric'),
    ('v8 gasoline');

INSERT INTO car_transmissions (name)
VALUES
    ('manual 5-speed'),
    ('manual 6-speed'),
    ('automatic 6-speed'),
    ('automatic 8-speed'),
    ('robotic'),
    ('cvt'),
    ('dual clutch'),
    ('single-speed electric');

INSERT INTO cars (name, body_id, engine_id, transmission_id)
VALUES
    ('Toyota Corolla', 1, 1, 3),
    ('Toyota Camry', 1, 2, 4),
    ('Volkswagen Golf', 2, 1, 2),
    ('Skoda Octavia', 10, 2, 4),
    ('BMW 3 Series', 1, 3, 4),
    ('BMW X5', 6, 7, 4),
    ('Audi A4', 1, 2, 7),
    ('Audi Q5', 5, 6, 7),
    ('Mercedes C-Class', 1, 2, 4),
    ('Mercedes GLE', 6, 7, 4),
    ('Tesla Model 3', 1, 9, 8),
    ('Tesla Model Y', 5, 9, 8),
    ('Ford Focus', 2, 1, 2),
    ('Ford Ranger', 7, 6, 3),
    ('Mazda MX-5', 9, 2, 2),
    ('Kia Sportage', 5, 2, 4),
    ('Hyundai Tucson', 5, 6, 4),
    ('Nissan Leaf', 2, 9, 8),
    ('Lada Vesta', 1, 1, 1),
    ('Concept Car A', NULL, 9, 8),
    ('Concept Car B', 4, NULL, 7),
    ('Prototype X', NULL, NULL, NULL),
    ('Old Van', 8, 5, NULL);

SELECT
	cb.id car_bodies_id,
	cb."name" car_bodies_name
FROM car_bodies cb
LEFT JOIN cars c ON cb.id = c.body_id
WHERE c.body_id IS NULL;

SELECT
	ce.id car_engines_id,
	ce."name" car_engines_name
FROM car_engines ce
LEFT JOIN cars c ON ce.id = c.engine_id
WHERE c.engine_id IS NULL;

SELECT
	ct.id car_transmissions_id,
	ct."name" car_transmissions_name
FROM car_transmissions ct
LEFT JOIN cars c ON ct.id = c.transmission_id
WHERE c.transmission_id IS NULL;

SELECT
	c.id,
	c."name" car_name,
	cb."name" body_name
FROM cars c
LEFT JOIN car_bodies cb ON c.body_id = cb.id;

SELECT
	c.id,
	c."name" car_name,
	cb."name" body_name,
	ce."name" engine_name,
	ct."name" transmission_name
FROM cars c
INNER JOIN car_bodies cb ON c.body_id = cb.id
INNER JOIN car_engines ce ON c.engine_id = ce.id
INNER JOIN car_transmissions ct ON c.transmission_id = ct.id ;

SELECT
	c.id,
	c."name" car_name,
	cb."name" body_name,
	ce."name" engine_name
FROM cars c
INNER JOIN car_engines ce ON c.engine_id = ce.id
LEFT JOIN car_bodies cb ON c.body_id = cb.id
WHERE c.body_id IS NULL;

SELECT
	cb.id body_id,
	cb."name" body_name,
	c.id car_id,
	c."name" car_name
FROM car_bodies cb
LEFT JOIN cars c ON cb.id = c.body_id ;

SELECT
	ce.id,
	ce."name" engine_name
FROM car_engines ce
LEFT JOIN cars c ON ce.id = c.engine_id
WHERE c.engine_id IS NULL;

SELECT
	c.id,
	c."name" car_name,
	cb."name" body_name,
	ce."name" engine_name,
	ct."name" transmission_name
FROM cars c
LEFT JOIN car_bodies cb ON c.body_id = cb.id
LEFT JOIN car_engines ce ON c.engine_id = ce.id
LEFT JOIN car_transmissions ct ON c.transmission_id = ct.id
WHERE ct."name" ILIKE 'automatic%';

SELECT
	c.id,
	c."name" car_name,
	cb."name" body_name,
	ce."name" engine_name,
	ct."name" transmission_name
FROM cars c
LEFT JOIN car_bodies cb ON c.body_id = cb.id
LEFT JOIN car_engines ce ON c.engine_id = ce.id
LEFT JOIN car_transmissions ct ON c.transmission_id = ct.id
WHERE
	cb."name" IS NULL
	OR ce."name" IS NULL
	OR ct."name" IS NULL;

SELECT
	c.id,
	c."name" car_name,
	ce."name" engine_name,
	ct."name" transmission_name
FROM cars c
INNER JOIN car_engines ce ON c.engine_id = ce.id
LEFT JOIN car_transmissions ct ON c.transmission_id = ct.id;

SELECT
	'body' AS detail_type,
	cb.id detail_id,
	cb."name" detail_name
FROM car_bodies cb
LEFT JOIN cars c ON cb.id = c.body_id
WHERE c.body_id  IS NULL
UNION ALL
SELECT
	'engine' AS detail_type,
	ce.id detail_id,
	ce."name" detail_name
FROM car_engines ce
LEFT JOIN cars c ON ce.id = c.engine_id
WHERE c.engine_id IS NULL
UNION ALL
SELECT
	'transmission' AS detail_type,
	ct.id detail_id,
	ct."name" detail_name
FROM car_transmissions ct
LEFT JOIN cars c ON ct.id = c.transmission_id
WHERE c.transmission_id IS NULL;

SELECT
	c.id,
	c."name" car_name,
	cb."name" body_name,
	ce."name" engine_name,
	ct."name" transmission_name
FROM cars c
LEFT JOIN car_bodies cb ON c.body_id = cb.id
LEFT JOIN car_engines ce ON c.engine_id = ce.id
LEFT JOIN car_transmissions ct ON c.transmission_id = ct.id
WHERE cb."name" ~* '(sedan|hatchback|suv)';