WITH ultima_data AS (
SELECT
    MAX(order_date) AS data
FROM orders
),

vendas_mes AS (
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita_liquida_funcionario
FROM employees e
JOIN orders o
ON e.employee_id = o.employee_id
JOIN order_details od
ON o.order_id = od.order_id
CROSS JOIN ultima_data u
WHERE DATE_TRUNC('month', o.order_date) = DATE_TRUNC('month', u.data)
GROUP BY e.employee_id, e.first_name, e.last_name
)

SELECT
    first_name || ' ' || last_name AS nome_completo,
    receita_liquida_funcionario
FROM vendas_mes
ORDER BY receita_liquida_funcionario DESC
LIMIT 1