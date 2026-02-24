/*
A equipe de Marketing quer fazer uma campanha de reativação. Eles precisam de uma lista de todos os 
clientes que não fazem um pedido há mais de 6 meses (considerando a data do último pedido no sistema).
O que eu preciso: Nome da empresa do cliente, o contato e a data do último pedido realizado por eles.
*/

-- Clientes que não fazem um pedido a mais de 6 meses

WITH pedidos AS (
SELECT
    c.company_name,
    c.contact_name,
    c.phone,
    MAX(o.order_date) AS ultima_compra
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_date IS NOT NULL
GROUP BY c.company_name, c.contact_name, c.phone
)

SELECT
    company_name,
    contact_name,
    phone,
    ultima_compra
FROM pedidos
WHERE ultima_compra < CURRENT_DATE - INTERVAL '6 months'