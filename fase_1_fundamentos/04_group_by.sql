/*
ARQUIVO: 04_group_by.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Entender agregação e granularidade
*/

-- 1) Contar registros

SELECT
    ship_country,
    COUNT(*) AS total_pedidos
FROM public.orders
GROUP BY ship_country
ORDER BY total_pedidos DESC;

-- 2) Receita por produto

SELECT
    product_id,
    SUM(unit_price * quantity * (1 - discount)) AS receita_total
FROM public.order_details
GROUP BY product_id
ORDER BY receita_total DESC;

-- 3) Receita por cliente

SELECT
    o.customer_id,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita_cliente
FROM public.orders o
JOIN public.order_details od
    ON o.order_id = od.order_id
GROUP BY o.customer_id
ORDER BY receita_cliente DESC;

-- 4) Média de preço por categoria

SELECT
    c.category_name,
    AVG(p.unit_price) AS preco_medio
FROM public.products p
JOIN public.categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY preco_medio DESC;