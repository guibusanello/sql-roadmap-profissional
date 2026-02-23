/*
ARQUIVO: 01_select_basico.sql
FASE: Fundamentos
OBJETIVO: Entender extração básica de dados
*/

-- Selecionando todas as colunas
SELECT *
FROM customers;

-- Selecionando colunas específicas
SELECT
    customer_id,
    company_name,
    city
FROM customers;

-- Renomeando colunas (alias)
SELECT
    customer_id AS id,
    company_name AS nome_cliente
FROM customers;