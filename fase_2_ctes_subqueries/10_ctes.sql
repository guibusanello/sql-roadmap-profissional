/*
ARQUIVO: 10_ctes.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Dominar CTE (Common Table Expressions)
*/

-- 1) CTE simples

WITH total_pedidos AS (
    SELECT
        customer_id,
        COUNT(*) AS qtd_pedidos
    FROM public.orders
    GROUP BY customer_id
)

SELECT *
FROM total_pedidos
ORDER BY qtd_pedidos DESC;


-- 2) CTE com agregação e JOIN

WITH receita_por_cliente AS (
    SELECT
        o.customer_id,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita
    FROM public.orders o
    JOIN public.order_details od
        ON o.order_id = od.order_id
    GROUP BY o.customer_id
)

SELECT
    c.company_name,
    r.receita
FROM receita_por_cliente r
JOIN public.customers c
    ON r.customer_id = c.customer_id
ORDER BY r.receita DESC;


-- 3) CTE encadeadas

WITH receita_por_produto AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(od.unit_price * od.quantity) AS receita
    FROM public.products p
    JOIN public.order_details od
        ON p.product_id = od.product_id
    GROUP BY p.product_id, p.product_name
),

media_receita AS (
    SELECT AVG(receita) AS media
    FROM receita_por_produto
)

SELECT *
FROM receita_por_produto
WHERE receita > (SELECT media FROM media_receita)
ORDER BY receita DESC;