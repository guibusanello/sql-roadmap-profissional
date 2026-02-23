/*
ARQUIVO: 09_subqueries.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Dominar subqueries
*/

-- 1) Subquery no WHERE

-- Clientes que fizeram pedidos
SELECT company_name
FROM public.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM public.orders
);

-- 2) Subquery com agregação

-- Produtos com preço acima da média
SELECT product_name, unit_price
FROM public.products
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM public.products
);

-- 3) Subquery correlacionada

-- Clientes com mais pedidos que a média geral
SELECT c.company_name
FROM public.customers c
WHERE (
    SELECT COUNT(*)
    FROM public.orders o
    WHERE o.customer_id = c.customer_id
) > (
    SELECT AVG(total_orders)
    FROM (
        SELECT COUNT(*) AS total_orders
        FROM public.orders
        GROUP BY customer_id
    ) t
);

-- 4) Subquery no SELECT

-- Total de pedidos por cliente
SELECT
    c.company_name,
    (
        SELECT COUNT(*)
        FROM public.orders o
        WHERE o.customer_id = c.customer_id
    ) AS total_pedidos
FROM public.customers c;