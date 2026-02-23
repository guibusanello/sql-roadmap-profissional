/*
ARQUIVO: 06_funcoes_agregacao.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Dominar funções de agregação
*/

-- 1) COUNT()

-- Total de pedidos
SELECT COUNT(*) AS total_pedidos
FROM public.orders;

-- Contar apenas valores não nulos
SELECT COUNT(region) AS total_com_regiao
FROM public.customers;

-- 2) SUM()

-- Receita total da empresa
SELECT
    SUM(unit_price * quantity * (1 - discount)) AS receita_total
FROM public.order_details;

-- 3) AVG()

-- Preço médio dos produtos
SELECT
    AVG(unit_price) AS preco_medio
FROM public.products;

-- 4) MIN() e MAX()

-- Produto mais caro
SELECT
    MAX(unit_price) AS maior_preco
FROM public.products;

-- Produto mais barato
SELECT
    MIN(unit_price) AS menor_preco
FROM public.products;

-- 5) Combinação de agregações

-- Estatísticas gerais de preço
SELECT
    COUNT(*) AS total_produtos,
    AVG(unit_price) AS preco_medio,
    MIN(unit_price) AS menor_preco,
    MAX(unit_price) AS maior_preco
FROM public.products;

-- 6) Agregação com GROUP BY

-- Receita por ano
SELECT
    EXTRACT(YEAR FROM o.order_date) AS ano,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita_anual
FROM public.orders o
JOIN public.order_details od
    ON o.order_id = od.order_id
GROUP BY ano
ORDER BY ano;