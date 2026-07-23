-- Создание таблиц
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL -- 'completed', 'cancelled'
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL
);

-- Заполнение тестовыми данными
INSERT INTO products (product_name, category, price) VALUES
('Ноутбук Apple MacBook Air', 'Электроника', 90000.00),
('Мышь Logitech MX Master', 'Аксессуары', 8000.00),
('Клавиатура Keychron K2', 'Аксессуары', 7500.00),
('Наушники Sony WH-1000XM5', 'Аудио', 25000.00);

INSERT INTO orders (customer_name, order_date, status) VALUES
('Иван Иванов', '2023-10-01', 'completed'),
('Петр Петров', '2023-10-02', 'completed'),
('Анна Смирнова', '2023-10-03', 'completed'),
('Елена Попова', '2023-10-04', 'cancelled'), -- Отмененный заказ!
('Иван Иванов', '2023-10-05', 'completed');

-- Состав заказов
-- Заказ 1: 1 Ноутбук + 1 Мышь
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1), (1, 2, 1);
-- Заказ 2: 2 Клавиатуры
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(2, 3, 2);
-- Заказ 3: 1 Наушники + 1 Мышь
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(3, 4, 1), (3, 2, 1);
-- Заказ 4 (Отменен): 1 Ноутбук
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(4, 1, 1);
-- Заказ 5: 1 Мышь + 1 Клавиатура
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(5, 2, 1), (5, 3, 1);

SELECT
	o.customer_name customer_name,
	SUM(oi.quantity * p.price ) total_revenue
FROM orders o
JOIN order_items oi on o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY o.customer_name
ORDER BY total_revenue DESC
LIMIT 2;

SELECT
	p.category category,
	SUM(oi.quantity) total_items_sold,
	SUM(oi.quantity * p.price) category_revenue
FROM orders o
JOIN order_items oi on o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY p.category
HAVING SUM(oi.quantity * p.price) > 30000;

WITH OrderTotals AS (
    SELECT
        oi.order_id,
        SUM(oi.quantity) quantity_in_order
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY oi.order_id
)
SELECT
    AVG(quantity_in_order) AS avg_items_per_order
FROM OrderTotals;
