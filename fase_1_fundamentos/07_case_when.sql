/*
ARQUIVO: 07_case_when.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Criar regras condicionais com CASE WHEN
*/

-- 1) Classificação simples de preço

SELECT
    product_name,
    unit_price,
    CASE
        WHEN unit_price < 10 THEN 'Barato'
        WHEN unit_price BETWEEN 10 AND 50 THEN 'Intermediário'
        ELSE 'Caro'
    END AS faixa_preco
FROM public.products;

-- 2) Classificação de pedidos por valor

SELECT
    o.order_id,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS valor_pedido,
    CASE
        WHEN SUM(od.unit_price * od.quantity * (1 - od.discount)) < 500 THEN 'Pequeno'
        WHEN SUM(od.unit_price * od.quantity * (1 - od.discount)) BETWEEN 500 AND 2000 THEN 'Médio'
        ELSE 'Grande'
    END AS categoria_pedido
FROM public.orders o
JOIN public.order_details od
    ON o.order_id = od.order_id
GROUP BY o.order_id;

-- 3) Tratando valores NULL

SELECT
    company_name,
    CASE
        WHEN region IS NULL THEN 'Sem Região'
        ELSE region
    END AS regiao_tratada
FROM public.customers;

-- 4) CASE dentro de agregação

-- Receita apenas de pedidos enviados para USA
SELECT
    SUM(
        CASE
            WHEN o.ship_country = 'USA'
            THEN od.unit_price * od.quantity * (1 - od.discount)
            ELSE 0
        END
    ) AS receita_usa
FROM public.orders o
JOIN public.order_details od
    ON o.order_id = od.order_id;