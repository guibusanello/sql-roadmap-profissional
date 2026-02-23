/*
ARQUIVO: 02_where.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Filtrar dados antes de qualquer agregação
*/


-- 1) Filtro simples

SELECT
    customer_id,
    company_name,
    country
FROM public.customers
WHERE country = 'USA';

-- 2) Múltiplas condições (AND)

SELECT
    order_id,
    customer_id,
    order_date,
    ship_country
FROM public.orders
WHERE ship_country = 'Brazil'
AND order_date >= '1997-01-01';

-- 3) Uso de OR

SELECT
    product_id,
    product_name,
    unit_price
FROM public.products
WHERE unit_price > 50
OR unit_price < 5;

-- 4) BETWEEN

SELECT
    order_id,
    order_date
FROM public.orders
WHERE order_date BETWEEN '1997-01-01' AND '1997-12-31';

-- 5) IN

SELECT
    customer_id,
    country
FROM public.customers
WHERE country IN ('Brazil', 'Argentina', 'Mexico');


-- 6) LIKE

SELECT
    company_name
FROM public.customers
WHERE company_name LIKE 'A%';

-- 7) IS NULL

SELECT
    region,
    company_name
FROM public.customers
WHERE region IS NULL;

-- 8) IS NOT NULL
SELECT
    region,
    company_name
FROM public.customers
WHERE region IS NOT NULL;