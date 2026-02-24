/*
Quero um relatório de "Atenção Urgente" que mostre:
- O nome do produto e o nome do fornecedor (Suppliers).
- A quantidade total disponível (Estoque + Pedidos em curso).
- Uma coluna calculada chamada status que diga:
    - RECOMPRAR: Se a disponibilidade total for menor que o reorder_level.
    - OK: Se estiver acima.

Filtre apenas os produtos que não estão descontinuados (discontinued = 0).
*/

SELECT
    p.product_id,
    p.product_name,
    p.supplier_id,
    s.company_name,
    s.contact_name,
    s.phone,
    (p.units_in_stock + p.units_on_order) AS qtd_total,
    CASE
        WHEN (p.units_in_stock + p.units_on_order) < p.reorder_level THEN 'RECOMPRAR'
        ELSE 'OK'
        END AS status
FROM products p
JOIN suppliers s
ON p.supplier_id = s.supplier_id
WHERE discontinued = 0
