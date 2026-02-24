-- Curva ABC de clientes
-- Receita por cliente

WITH receita_cliente AS (
SELECT
    c.customer_id,
    c.company_name,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY receita DESC
)

SELECT *
FROM receita_cliente

-- Receita acumulada e percentual acumulado

WITH receita_cliente AS (
SELECT
    c.customer_id,
    c.company_name,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY receita DESC
),

abc AS (
    SELECT
        customer_id,
        company_name,
        receita,
        SUM(receita) OVER () AS receita_total,
        SUM(receita) OVER (ORDER BY receita DESC) AS receita_acumulada
    FROM receita_cliente
)

SELECT
    customer_id,
    company_name,
    receita,
    receita_acumulada / receita_total AS percentual
FROM abc
ORDER BY receita DESC

-- Classificação ABC

WITH receita_cliente AS (
SELECT
    c.customer_id,
    c.company_name,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY receita DESC
),

abc AS (
    SELECT
        customer_id,
        company_name,
        receita,
        SUM(receita) OVER () AS receita_total,
        SUM(receita) OVER (ORDER BY receita DESC) AS receita_acumulada
    FROM receita_cliente
),

percentual_acumulado AS (SELECT
    customer_id,
    company_name,
    receita,
    receita_acumulada / receita_total AS percentual
FROM abc
ORDER BY receita DESC
)

SELECT
    customer_id,
    company_name,
    receita,
    (percentual * 100) AS percentual_acumulado_pctg,
CASE
    WHEN percentual <= 0.8 THEN 'A'
    WHEN percentual <= 0.95 THEN 'B'
    ELSE 'C'
    END AS classificacao_abc
FROM percentual_acumulado
ORDER BY receita DESC

-- Total de clientes em cada classe

WITH receita_cliente AS (
    SELECT
        c.customer_id,
        c.company_name,
        SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY c.customer_id, c.company_name
),

abc AS (
    SELECT
        customer_id,
        company_name,
        receita,
        SUM(receita) OVER (ORDER BY receita DESC) / SUM(receita) OVER () AS percentual_acumulado
    FROM receita_cliente
),

classificacao AS (
    SELECT
        customer_id,
        company_name,
        receita,
        CASE
            WHEN percentual_acumulado <= 0.80 THEN 'A'
            WHEN percentual_acumulado <= 0.95 THEN 'B'
            ELSE 'C'
        END AS abc_categoria
    FROM abc
)

SELECT
    abc_categoria,
    COUNT(customer_id) AS qtd_clientes,
    ROUND(COUNT(customer_id) * 100.0 / SUM(COUNT(customer_id)) OVER (), 2) AS pct_clientes_sobre_total
FROM classificacao
GROUP BY abc_categoria
ORDER BY abc_categoria;