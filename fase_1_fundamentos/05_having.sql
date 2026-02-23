/*
ARQUIVO: 05_having.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Filtrar resultados agregados
*/

-- 1) Países com mais de 20 pedidos

SELECT
    ship_country,
    COUNT(*) AS total_pedidos
FROM public.orders
GROUP BY ship_country
HAVING COUNT(*) > 20
ORDER BY total_pedidos DESC;

-- 2) Produtos com receita maior que 10.000

SELECT
    product_id,
    SUM(unit_price * quantity * (1 - discount)) AS receita_total
FROM public.order_details
GROUP BY product_id
HAVING SUM(unit_price * quantity * (1 - discount)) > 10000
ORDER BY receita_total DESC;

-- 3) Clientes com mais de 5 pedidos

SELECT
    customer_id,
    COUNT(order_id) AS total_pedidos
FROM public.orders
GROUP BY customer_id
HAVING COUNT(order_id) > 5
ORDER BY total_pedidos DESC;

-- 4) Categorias com preço médio acima de 30

SELECT
    c.category_name,
    AVG(p.unit_price) AS preco_medio
FROM public.products p
JOIN public.categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
HAVING AVG(p.unit_price) > 30
ORDER BY preco_medio DESC;