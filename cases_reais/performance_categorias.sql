/*
A diretoria está preocupada com a margem de lucro. Eles acham que estamos dando muito desconto em 
categorias que já vendem bem sozinhas.

O que eu preciso: Um relatório que mostre o Total de Vendas (Revenue) por Categoria de Produto, 
mas quero ver também a média de desconto aplicada em cada categoria.
*/

WITH categorias AS (
SELECT
    ct.category_name,
    SUM(od.unit_price * od.quantity) AS receita_bruta,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita_liquida,
    AVG(od.discount) AS media_desconto
FROM categories ct
JOIN products p
ON ct.category_id = p.category_id
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY ct.category_name
ORDER BY receita_bruta DESC, receita_liquida DESC
)

SELECT
    category_name,
    receita_bruta,
    receita_liquida,
    (media_desconto * 100) AS media_desconto_perc,
    (receita_bruta - receita_liquida) AS diferenca_absoluta
FROM categorias