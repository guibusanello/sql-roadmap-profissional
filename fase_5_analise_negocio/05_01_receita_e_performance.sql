-- Receita total da empresa
SELECT
    SUM((unit_price * quantity) * (1 - discount)) AS receita
FROM order_details

-- Receita por ano
SELECT
    DATE_TRUNC('year', o.order_date) as ano,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY ano
ORDER BY ano

-- TOP 10 clientes por receita
SELECT
    c.company_name AS cliente,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY c.company_name
ORDER BY receita DESC
LIMIT 10

-- TOP 10 Produtos mais rentáveis
SELECT
    p.product_id,
    p.product_name,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY receita DESC
LIMIT 10

-- Receita por país
SELECT
    o.ship_country,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.ship_country
ORDER BY receita DESC