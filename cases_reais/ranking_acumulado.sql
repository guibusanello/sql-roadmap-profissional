/*
Agora é a hora de brilhar com o RH. Eles querem ver o crescimento de cada vendedor. 
Imagine um gráfico de linha onde a linha só sobe conforme o vendedor faz novas vendas.
*/

WITH receita_por_pedido AS (
SELECT
    o.order_id,
    o.order_date,
    o.employee_id,
    e.first_name || ' ' || e.last_name AS funcionario,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita_pedido
FROM orders o
JOIN employees e
ON o.employee_id = e.employee_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.order_id, o.order_date, o.employee_id, funcionario
)

SELECT
    funcionario,
    order_date,
    SUM(receita_pedido) OVER (PARTITION BY funcionario ORDER BY order_date) AS acumulado
FROM receita_por_pedido

/*
O RH pediu para ver quem atingiu a meta de $10.000,00 acumulados primeiro!
*/

WITH receita_por_pedido AS (
SELECT
    o.order_id,
    o.order_date,
    o.employee_id,
    e.first_name || ' ' || e.last_name AS funcionario,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita_pedido
FROM orders o
JOIN employees e
ON o.employee_id = e.employee_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.order_id, o.order_date, o.employee_id, funcionario
),

receita_acumulada AS (
SELECT
    funcionario,
    order_date,
    SUM(receita_pedido) OVER (PARTITION BY funcionario ORDER BY order_date) AS acumulado
FROM receita_por_pedido
),

data_10_mil AS (
SELECT DISTINCT ON (funcionario)
    funcionario,
    order_date AS data_10k,
    acumulado
FROM receita_acumulada
WHERE acumulado >= 10000
ORDER BY funcionario, data_10k ASC
)

SELECT
    funcionario,
    MIN(data_10k),
    acumulado
FROM data_10_mil
GROUP BY funcionario, acumulado
LIMIT 1