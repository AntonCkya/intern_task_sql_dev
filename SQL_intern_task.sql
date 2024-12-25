-- DROP чтобы код можно было запускать несколько раз
DROP TABLE IF EXISTS products;
-- 1
CREATE TABLE IF NOT EXISTS products(
  city TEXT,
  product TEXT,
  cost INTEGER,
  date DATE
);
--2
INSERT INTO products (city, product, cost, date) VALUES
('Москва', 'Банан', 55, TO_DATE('01.01.2024', 'DD.MM.YYYY')),
('Москва', 'Банан', 60, TO_DATE('02.01.2024', 'DD.MM.YYYY')),
('Москва', 'Банан', 58, TO_DATE('03.01.2024', 'DD.MM.YYYY')),
('Москва', 'Яблоко', 35, TO_DATE('01.01.2024', 'DD.MM.YYYY')),
('Москва', 'Яблоко', 35, TO_DATE('02.01.2024', 'DD.MM.YYYY')),
('Москва', 'Вода', 90, TO_DATE('01.01.2024', 'DD.MM.YYYY')),
('Москва', 'Вода', 90, TO_DATE('02.01.2024', 'DD.MM.YYYY')),
('Москва', 'Вода', 100, TO_DATE('03.01.2024', 'DD.MM.YYYY')),
('Самара', 'Банан', 50, TO_DATE('02.01.2024', 'DD.MM.YYYY')),
('Самара', 'Банан', 44, TO_DATE('03.01.2024', 'DD.MM.YYYY')),
('Самара', 'Хлеб', 40, TO_DATE('01.01.2024', 'DD.MM.YYYY')),
('Самара', 'Хлеб', 40, TO_DATE('02.01.2024', 'DD.MM.YYYY')),
('Самара', 'Хлеб', 40, TO_DATE('03.01.2024', 'DD.MM.YYYY')),
('Киров', 'Вода', 70, TO_DATE('01.01.2024', 'DD.MM.YYYY')),
('Киров', 'Вода', 69, TO_DATE('02.01.2024', 'DD.MM.YYYY')),
('Киров', 'Вода', 70, TO_DATE('03.01.2024', 'DD.MM.YYYY')),
('Киров', 'Мороженное', 90, TO_DATE('01.01.2024', 'DD.MM.YYYY')),
('Киров', 'Мороженное', 95, TO_DATE('02.01.2024', 'DD.MM.YYYY')),
('Киров', 'Мороженное', 92, TO_DATE('03.01.2024', 'DD.MM.YYYY'));
-- проверка пунктов 1 и 2
SELECT * FROM products;
-- 3.a
SELECT city, COUNT(*) FROM products
WHERE date = '02.01.2024'
GROUP BY city;
-- 3.b
SELECT product, MIN(cost) FROM products
GROUP BY product;
-- 3.c
SELECT city, date, AVG(cost) FROM products
GROUP BY city, date;
-- 3.d
SELECT city, product FROM products
WHERE (city, cost) IN (
  SELECT city, MAX(cost) FROM products
  GROUP BY city
);
-- 3.e
SELECT DISTINCT product FROM products
WHERE city = 'Киров'
AND product NOT IN (
  SELECT DISTINCT product FROM products
  WHERE city = 'Москва'
);
-- 3.f
SELECT product, date, AVG(cost) FROM products
GROUP BY product, date;
-- 3.g
SELECT date, COUNT(*), COUNT(DISTINCT product) AS count_uniq FROM products
GROUP BY date;
-- 3.h
SELECT DISTINCT product, city FROM products
WHERE (product, cost) IN (
  SELECT product, MAX(cost) FROM products
  GROUP BY product
);
-- 3.i
-- внутренний SELECT лучше заменить на временную таблицу через WITH, но так больше похоже на 1 запрос
-- diff равен NULL у первого дня, вроде логично, раз дня до первого не было
SELECT curr.date, curr.count, (curr.count - prev.count) AS diff
FROM (
  SELECT date, COUNT(*) AS count FROM products GROUP BY date
) AS curr
LEFT JOIN (
  SELECT date, COUNT(*) AS count FROM products GROUP BY date
) AS prev
ON EXTRACT(DAY FROM (curr.date::TIMESTAMP - prev.date::TIMESTAMP)) = 1
ORDER BY curr.date;
-- 3.j
SELECT product, city, AVG(diff) AS avg_diff
FROM(
  SELECT curr.date, curr.city, curr.product, (curr.cost - prev.cost) AS diff
  FROM (
    SELECT * FROM products
  ) AS curr
  LEFT JOIN (
    SELECT * FROM products
  ) AS prev
  ON EXTRACT(DAY FROM (curr.date::TIMESTAMP - prev.date::TIMESTAMP)) = 1
  AND prev.city = curr.city
  AND prev.product = curr.product
)
GROUP BY product, city;
