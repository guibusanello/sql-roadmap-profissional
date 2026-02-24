/*
ARQUIVO: 11_window_functions.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Dominar Window Functions
*/

-- 1) ROW_NUMBER()

-- Ranking de clientes por receita

WITH receita_cliente AS (
    SELECT
        o.customer_id,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita
    FROM public.orders o
    JOIN public.order_details od
        ON o.order_id = od.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    receita,
    ROW_NUMBER() OVER (ORDER BY receita DESC) AS ranking
FROM receita_cliente;


-- 2) RANK() vs DENSE_RANK()

WITH receita_cliente AS (
    SELECT
        o.customer_id,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita
    FROM public.orders o
    JOIN public.order_details od
        ON o.order_id = od.order_id
    GROUP BY o.customer_id
)

SELECT
    customer_id,
    receita,
    RANK() OVER (ORDER BY receita DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY receita DESC) AS dense_rank
FROM receita_cliente;


-- 3) PARTITION BY

-- Ranking de clientes por país

WITH receita_cliente AS (
    SELECT
        o.customer_id,
        o.ship_country,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita
    FROM public.orders o
    JOIN public.order_details od
        ON o.order_id = od.order_id
    GROUP BY o.customer_id, o.ship_country
)

SELECT
    customer_id,
    ship_country,
    receita,
    ROW_NUMBER() OVER (
        PARTITION BY ship_country
        ORDER BY receita DESC
    ) AS ranking_pais
FROM receita_cliente;


-- 4) SUM() OVER (acumulado)

-- Receita acumulada ao longo do tempo

WITH receita_por_data AS (
    SELECT
        o.order_date,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita_dia
    FROM public.orders o
    JOIN public.order_details od
        ON o.order_id = od.order_id
    GROUP BY o.order_date
)

SELECT
    order_date,
    receita_dia,
    SUM(receita_dia) OVER (
        ORDER BY order_date
    ) AS receita_acumulada
FROM receita_por_data;

-- 5) AVG() OVER()

-- Média de receita por país e comparação média do cliente x média do país

WITH receita_cliente AS (
    SELECT
        o.customer_id,
        o.ship_country,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita
    FROM public.orders o
    JOIN public.order_details od
        ON o.order_id = od.order_id
    GROUP BY o.customer_id, o.ship_country
)

SELECT
    customer_id,
    ship_country,
    receita,
    AVG(receita) OVER (
        PARTITION BY ship_country
    ) AS media_pais,
    receita - AVG(receita) OVER (
        PARTITION BY ship_country
    ) AS diferenca_media
FROM receita_cliente
ORDER BY ship_country, receita DESC;

-- Média móvel


WITH receita_por_data AS (
    SELECT
        o.order_date,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita_dia
    FROM public.orders o
    JOIN public.order_details od
        ON o.order_id = od.order_id
    GROUP BY o.order_date
)

SELECT
    order_date,
    receita_dia,
    AVG(receita_dia) OVER (
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS media_movel_7_dias
FROM receita_por_data
ORDER BY order_date;


-- 6) LAG() e LEAD()

-- Comparação dia atual vs dia anterior

WITH receita_por_data AS (
    SELECT
        o.order_date,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita_dia
    FROM public.orders o
    JOIN public.order_details od
        ON o.order_id = od.order_id
    GROUP BY o.order_date
)

SELECT
    order_date,
    receita_dia,
    LAG(receita_dia) OVER (ORDER BY order_date) AS receita_dia_anterior,
    receita_dia
      - LAG(receita_dia) OVER (ORDER BY order_date) AS variacao
FROM receita_por_data;