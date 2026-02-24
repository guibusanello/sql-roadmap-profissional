/*
A diretoria quer saber onde abrir o próximo centro de distribuição.
O que eu preciso: O total de vendas líquidas agrupado por País de Destino 
(ship_country na tabela Orders).
Extra: Calcule o percentual que cada país representa no faturamento total da empresa.
*/

WITH receitas AS (
SELECT
    o.ship_country,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita_liquida,
    SUM(SUM((od.unit_price * od.quantity) * (1 - od.discount))) OVER () AS receita_total_empresa
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.ship_country
)

SELECT
    ship_country,
    receita_liquida,
    receita_total_empresa,
    (receita_liquida / receita_total_empresa) * 100 AS market_share_perc
FROM receitas
ORDER BY market_share_perc DESC