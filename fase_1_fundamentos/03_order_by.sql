/*
ARQUIVO: 03_order_by.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Ordenar resultados corretamente
*/

-- 1) Ordenação simples (ASC padrão, ordem crescente)

SELECT
    product_id,
    product_name,
    unit_price
FROM public.products
ORDER BY unit_price;

-- 2) Ordem decrescente

SELECT
    product_id,
    product_name,
    unit_price
FROM public.products
ORDER BY unit_price DESC;

-- 3) Múltiplas colunas

SELECT
    country,
    city,
    company_name
FROM public.customers
ORDER BY country ASC, city ASC;

-- 4) Ordenar por alias (boa prática)

SELECT
    product_name,
    unit_price * 1.1 AS preco_com_reajuste
FROM public.products
ORDER BY preco_com_reajuste DESC;

-- 5) Ordenar por posição (evitar em produção)
-- No caso, unit_price é a coluna 2, então usar o 2 no ORDER BY

SELECT
    product_name,
    unit_price
FROM public.products
ORDER BY 2 DESC;