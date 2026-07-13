ALTER TABLE users
ADD COLUMN phone TEXT NULL;

ALTER TABLE users
ADD COLUMN middle_name TEXT NULL;

ALTER TABLE products
ADD COLUMN description TEXT NULL;

ALTER TABLE products
ADD COLUMN discount_price NUMERIC(12,2) NULL;

INSERT INTO users (name, email, phone, middle_name) VALUES
('Артем Соколов', 'artem.sokolov@mail.ru', '+7-999-123-45-67', 'Алексеевич'),
('Евгения Морозова', 'evgenia.morozova@yandex.ru', NULL, 'Дмитриевна'),
('Максим Белов', 'maksim.belov@gmail.com', '+7-999-234-56-78', NULL),
('Диана Крылова', 'diana.krylova@bk.ru', NULL, NULL),
('Роман Кузнецов', 'roman.kuznetsov@rambler.ru', '+7-999-345-67-89', 'Сергеевич');

INSERT INTO products (name, price, is_active, description, discount_price)
VALUES
('Кресло геймерское', 25000.00, true, 'Эргономичное кресло для геймеров с поддержкой спины', 22000.00),
('USB-хаб 7 портов', 1500.00, true, 'Многофункциональный USB-хаб с поддержкой 3.0', NULL),
('Сетевая карта 2.5Gb', 3500.00, false, NULL, 3000.00),
('Коврик для мыши большой', 800.00, true, NULL, NULL),
('Подставка для ноутбука', 1200.00, true, 'Алюминиевая подставка с регулировкой высоты', 990.00);
('Кресло SIHOO c300', 50000, TRUE, 'Кресло регулируемое с синхромеханизмом', 45000, );

SELECT id, name, middle_name
FROM	 users
WHERE middle_name IS NULL ;

SELECT id, name, description
FROM	 products
WHERE description IS NULL ;

SELECT id, name, price, discount_price
FROM	 products
WHERE discount_price IS NULL ;

SELECT id, name, phone
FROM	 users
WHERE phone IS NULL OR phone = '';

SELECT id, name, COALESCE(description, 'описание отсутствует') AS display_description
FROM	 products;

SELECT id, name, price, COALESCE (discount_price, price) AS final_price
FROM	 products;