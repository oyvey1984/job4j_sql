CREATE TABLE users
(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	full_name TEXT NOT NULL,
	email TEXT NOT NULL UNIQUE,
	phone TEXT NOT NULL,
	birth_date DATE NOT NULL,
	created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE subscriptions
(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	user_id BIGINT NOT NULL REFERENCES users(id),
	plan_name TEXT NOT NULL,
	expires_at DATE NOT NULL,
	is_active BOOLEAN NOT NULL
);

CREATE TABLE movies
(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	title TEXT NOT NULL,
	genre TEXT NOT NULL,
	release_year INT NOT NULL,
	duration_minutes INT NOT NULL
);

CREATE TABLE views
(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	user_id BIGINT NOT NULL REFERENCES users(id),
	movie_id BIGINT NOT NULL REFERENCES movies(id),
	watched_at TIMESTAMPTZ NOT NULL DEFAULT now(),
	watch_time_minutes INT NOT NULL
);

CREATE TABLE payments
(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	user_id BIGINT NOT NULL REFERENCES users(id),
	amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
	paid_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE reviews
(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	user_id BIGINT NOT NULL REFERENCES users(id),
	movie_id BIGINT NOT NULL REFERENCES movies(id),
	rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 10),
	created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO users (full_name, email, phone, birth_date)
VALUES
    ('Иван Петров',      'ivan.petrov@example.com',   '+79001112233', '1990-05-14'),
    ('Мария Смирнова',   'maria.smirnova@example.com','+79002223344', '1985-11-02'),
    ('Алексей Кузнецов', 'alexey.kuznetsov@example.com','+79003334455','1998-03-27'),
    ('Елена Соколова',   'elena.sokolova@example.com','+79004445566', '1995-07-19'),
    ('Дмитрий Волков',   'dmitry.volkov@example.com', '+79005556677', '2000-01-08');

INSERT INTO movies (title, genre, release_year, duration_minutes)
VALUES
    ('Начало',                  'фантастика', 2010, 148),
    ('Побег из Шоушенка',       'драма',      1994, 142),
    ('Матрица',                 'фантастика', 1999, 136),
    ('Криминальное чтиво',      'криминал',   1994, 154),
    ('Интерстеллар',            'фантастика', 2014, 169),
    ('Зелёная книга',           'драма',      2018, 130);

INSERT INTO subscriptions (user_id, plan_name, expires_at, is_active)
VALUES
    ((SELECT id FROM users WHERE email = 'ivan.petrov@example.com'),
     'Basic',    '2025-12-31', TRUE),
    ((SELECT id FROM users WHERE email = 'ivan.petrov@example.com'),
     'Premium',  '2026-06-30', TRUE),
    ((SELECT id FROM users WHERE email = 'maria.smirnova@example.com'),
     'Premium',  '2025-09-30', FALSE),
    ((SELECT id FROM users WHERE email = 'alexey.kuznetsov@example.com'),
     'Basic',    '2026-01-31', TRUE),
    ((SELECT id FROM users WHERE email = 'elena.sokolova@example.com'),
     'Premium',  '2026-03-31', TRUE);

INSERT INTO views (user_id, movie_id, watched_at, watch_time_minutes)
VALUES
    ((SELECT id FROM users  WHERE email = 'ivan.petrov@example.com'),
     (SELECT id FROM movies WHERE title = 'Начало'),
     '2025-10-01 20:15:00+03', 148),

    ((SELECT id FROM users  WHERE email = 'ivan.petrov@example.com'),
     (SELECT id FROM movies WHERE title = 'Матрица'),
     '2025-10-03 21:00:00+03', 90),   -- не досмотрел

    ((SELECT id FROM users  WHERE email = 'maria.smirnova@example.com'),
     (SELECT id FROM movies WHERE title = 'Побег из Шоушенка'),
     '2025-10-05 19:40:00+03', 142),

    ((SELECT id FROM users  WHERE email = 'alexey.kuznetsov@example.com'),
     (SELECT id FROM movies WHERE title = 'Интерстеллар'),
     '2025-10-07 22:10:00+03', 169),

    ((SELECT id FROM users  WHERE email = 'elena.sokolova@example.com'),
     (SELECT id FROM movies WHERE title = 'Криминальное чтиво'),
     '2025-10-08 18:25:00+03', 154),

    ((SELECT id FROM users  WHERE email = 'dmitry.volkov@example.com'),
     (SELECT id FROM movies WHERE title = 'Зелёная книга'),
     '2025-10-09 20:00:00+03', 130);

INSERT INTO payments (user_id, amount, paid_at)
VALUES
    ((SELECT id FROM users WHERE email = 'ivan.petrov@example.com'),
     299.00, '2025-09-01 10:00:00+03'),

    ((SELECT id FROM users WHERE email = 'ivan.petrov@example.com'),
     999.00, '2025-09-15 12:30:00+03'),

    ((SELECT id FROM users WHERE email = 'maria.smirnova@example.com'),
     999.00, '2025-08-20 09:15:00+03'),

    ((SELECT id FROM users WHERE email = 'alexey.kuznetsov@example.com'),
     299.00, '2025-09-25 16:45:00+03'),

    ((SELECT id FROM users WHERE email = 'elena.sokolova@example.com'),
     999.00, '2025-10-02 11:05:00+03');

INSERT INTO reviews (user_id, movie_id, rating, created_at)
VALUES
    ((SELECT id FROM users  WHERE email = 'ivan.petrov@example.com'),
     (SELECT id FROM movies WHERE title = 'Начало'),
     9, '2025-10-02 09:00:00+03'),

    ((SELECT id FROM users  WHERE email = 'maria.smirnova@example.com'),
     (SELECT id FROM movies WHERE title = 'Побег из Шоушенка'),
     10, '2025-10-06 14:20:00+03'),

    ((SELECT id FROM users  WHERE email = 'alexey.kuznetsov@example.com'),
     (SELECT id FROM movies WHERE title = 'Интерстеллар'),
     8, '2025-10-08 08:45:00+03'),

    ((SELECT id FROM users  WHERE email = 'elena.sokolova@example.com'),
     (SELECT id FROM movies WHERE title = 'Криминальное чтиво'),
     7, '2025-10-09 12:10:00+03'),

    ((SELECT id FROM users  WHERE email = 'dmitry.volkov@example.com'),
     (SELECT id FROM movies WHERE title = 'Зелёная книга'),
     9, '2025-10-10 19:30:00+03');

CREATE OR REPLACE VIEW v_movie_views AS
SELECT
	v.id,
	u.full_name,
	m.title,
	v.watched_at,
	v.watch_time_minutes
FROM VIEWS v
JOIN users u ON v.user_id = u.id
JOIN movies m ON v.movie_id = v.movie_id;

SELECT * FROM v_movie_views vmv ;

CREATE OR REPLACE VIEW v_support_users AS
SELECT
    id,
    full_name,
    email,
    created_at
FROM users u;

CREATE OR REPLACE VIEW v_delivery_users AS
SELECT
	id,
	full_name,
	'*******' || RIGHT(phone, 4) AS phone
FROM users u;

CREATE OR REPLACE VIEW v_active_subscriptions AS
SELECT
	s.id,
	s.user_id,
	s.plan_name,
	s.expires_at
FROM subscriptions s
WHERE s.is_active = TRUE
WITH CHECK OPTION;

CREATE MATERIALIZED VIEW mv_movie_statistics AS
SELECT
	m.id AS movie_id,
	m.title,
	COUNT(v.id) AS views_count,
	COALESCE(SUM(v.watch_time_minutes), 0) AS total_watch_minutes
FROM movies m
JOIN views v ON v.movie_id = m.id
GROUP BY m.id, m.title;

