/*
ARQUIVO: 00_exploracao_estrutura.sql
DATABASE: PostgreSQL
DATASET: Northwind
OBJETIVO: Explorar estrutura do banco antes de iniciar análises
*/

-- 1) Listar todas as tabelas do schema public

SELECT
    table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- 2) Ver colunas de uma tabela específica

-- Exemplo: customers

SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'customers'
ORDER BY ordinal_position;


-- 3) Ver chaves primárias

SELECT
    tc.table_name,
    kc.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kc
    ON tc.constraint_name = kc.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY'
AND tc.table_schema = 'public'
ORDER BY tc.table_name;


-- 4) Ver chaves estrangeiras

SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table,
    ccu.column_name AS foreign_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_schema = 'public'
ORDER BY tc.table_name;


-- 5) Contar volume de dados por tabela

SELECT
    'customers' AS tabela,
    COUNT(*) AS total_registros
FROM public.customers

UNION ALL

SELECT
    'orders',
    COUNT(*)
FROM public.orders

UNION ALL

SELECT
    'order_details',
    COUNT(*)
FROM public.order_details

UNION ALL

SELECT
    'products',
    COUNT(*)
FROM public.products

ORDER BY total_registros DESC;