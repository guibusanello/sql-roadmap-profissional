-- Cálculo do RFM

WITH rfm_base AS (
    SELECT
        c.customer_id,
        c.company_name,
        MAX(o.order_date) AS ultima_compra, -- recency
        COUNT(DISTINCT o.order_id) AS total_pedidos, -- frequency
        SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS receita_cliente -- monetary
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_details od
    ON o.order_id = od.order_id
    GROUP BY c.customer_id, c.company_name
),

rfm_calculado AS (
    SELECT
        *,
        (SELECT
            MAX(order_date)
        FROM orders) - ultima_compra AS recencia
    FROM rfm
)

SELECT *
FROM rfm_calculado

-- Score RFM (1 a 5)

WITH rfm_base AS (
    SELECT
        c.customer_id,
        c.company_name,
        MAX(o.order_date) AS ultima_compra,
        COUNT(DISTINCT o.order_id) AS frequencia,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS monetario
    FROM public.customers c
    JOIN public.orders o
        ON c.customer_id = o.customer_id
    JOIN public.order_details od
        ON o.order_id = od.order_id
    GROUP BY c.customer_id, c.company_name
),

rfm AS (
    SELECT
        *,
        (SELECT MAX(order_date) FROM orders) - ultima_compra AS recencia
    FROM rfm_base
),

score AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recencia DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequencia) AS f_score,
        NTILE(5) OVER (ORDER BY monetario) AS m_score
    FROM rfm
)

SELECT
    *,
    r_score::text || f_score::text || m_score::text AS rfm_score
FROM score
ORDER BY monetario DESC;

-- Segmentação

WITH rfm_base AS (
    SELECT
        c.customer_id,
        c.company_name,
        MAX(o.order_date) AS ultima_compra,
        COUNT(DISTINCT o.order_id) AS frequencia,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS monetario
    FROM public.customers c
    JOIN public.orders o
        ON c.customer_id = o.customer_id
    JOIN public.order_details od
        ON o.order_id = od.order_id
    GROUP BY c.customer_id, c.company_name
),

rfm AS (
    SELECT
        *,
        (SELECT MAX(order_date) FROM public.orders) - ultima_compra AS recencia
    FROM rfm_base
),

rfm_final AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recencia ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequencia) AS f_score,
        NTILE(5) OVER (ORDER BY monetario) AS m_score
    FROM rfm
)

SELECT
    customer_id,
    company_name,
    r_score,
    f_score,
    m_score,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'Campeoes'
        WHEN r_score >= 3 AND f_score >= 3
            THEN 'Leais'
        WHEN r_score <= 2 AND f_score >= 3
            THEN 'Em Risco'
        ELSE 'Outros'
    END AS segmento
FROM rfm_final
ORDER BY segmento;