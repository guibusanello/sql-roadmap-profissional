/*
Preciso gratificar o funcionário que trouxe mais receita no último mês registrado na base.
O que eu preciso: O nome completo do funcionário e o valor total vendido por ele.
*/

SELECT 
    sub.first_name AS nome_funcionario,
    sub.last_name AS sobrenome_funcionario,
    COALESCE(gest.first_name, 'CEO') AS nome_gestor,
    COALESCE(gest.last_name, 'CEO') AS sobrenome_gestor
FROM employees sub
LEFT JOIN employees gest 
    ON sub.reports_to = gest.employee_id
ORDER BY nome_gestor, sobrenome_gestor