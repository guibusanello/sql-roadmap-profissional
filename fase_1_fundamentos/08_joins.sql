/*
ARQUIVO: 08_joins.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Dominar JOINs e relações entre tabelas
*/

-- 1) INNER JOIN

-- Listar pedidos com nome do cliente
SELECT
    o.order_id,
    o.order_date,
    c.company_name
FROM public.orders o
INNER JOIN public.customers c
    ON o.customer_id = c.customer_id;

-- 2) INNER JOIN múltiplo

-- Receita detalhada por produto e cliente
SELECT
    c.company_name,
    p.product_name,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita
FROM public.orders o
JOIN public.customers c
    ON o.customer_id = c.customer_id
JOIN public.order_details od
    ON o.order_id = od.order_id
JOIN public.products p
    ON od.product_id = p.product_id
GROUP BY
    c.company_name,
    p.product_name
ORDER BY receita DESC;

-- 3) LEFT JOIN

-- Clientes que podem não ter feito pedido
SELECT
    c.company_name,
    o.order_id
FROM public.customers c
LEFT JOIN public.orders o
    ON c.customer_id = o.customer_id
ORDER BY c.company_name;

-- 4) Encontrar clientes sem pedidos

SELECT
    c.company_name
FROM public.customers c
LEFT JOIN public.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 5) SELF JOIN

-- Funcionário e seu gerente
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS funcionario,
    m.first_name || ' ' || m.last_name AS gerente
FROM public.employees e
LEFT JOIN public.employees m
    ON e.reports_to = m.employee_id;