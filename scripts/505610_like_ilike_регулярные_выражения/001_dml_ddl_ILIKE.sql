CREATE TABLE vacancies
(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
title TEXT NOT NULL,
company TEXT NOT NULL,
description TEXT,
created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO vacancies (title, company, description) VALUES
('Senior Java Developer', 'ООО "ТехноМаркет"', 'Разработка и поддержка бэкенда интернет-магазина на Java/Spring Boot. Требования: опыт от 5 лет, знание PostgreSQL, микросервисы.'),
('Менеджер по продажам', 'ООО "ТехноМаркет"', 'Консультирование клиентов, обработка заказов, работа с CRM. Опыт от 1 года.'),
('Специалист по маркетингу', 'ООО "ТехноМаркет"', 'Разработка маркетинговых стратегий, управление рекламными кампаниями, анализ рынка.'),
('Водитель-экспедитор', 'ООО "ТехноМаркет"', 'Доставка заказов клиентам по городу. Требования: права категории B, опыт от 2 лет.'),
('Frontend Developer', 'ООО "ТехноМаркет"', 'Разработка клиентской части интернет-магазина на React. Знание TypeScript, Redux, опыт от 3 лет.'),
('Кладовщик', 'ООО "ТехноМаркет"', 'Приемка, хранение и отгрузка товаров на складе. Ведение учета в 1С.'),
('Системный администратор', 'ООО "ТехноМаркет"', 'Администрирование серверов и сетевого оборудования, обеспечение безопасности, настройка веб-серверов.');

SELECT u.id, u.name, u.email
FROM users u
WHERE u.email ILIKE '%mail%';

SELECT id, name, price
FROM products
WHERE name ILIKE '%air%';

SELECT id, name, price
FROM products
WHERE name ~* '^i';

SELECT id, name, price
FROM products
WHERE name ~* 'pro$';

SELECT id, name, email
FROM users
WHERE name ~* '^A' OR name ~* '^I';

SELECT id, title, company, description
FROM vacancies
WHERE description ~* '(java|go|postgres)' OR title  ~* '(java|go|postgres)';

SELECT id, name, price
FROM products
WHERE name ~* '^iPhone [0-9]+';