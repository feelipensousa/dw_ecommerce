-- 6) calcular ltv médio por cliente
WITH source AS (
    SELECT
        client_id,
        full_name,
        SUM(revenue) as total_amount_spent
    FROM {{ ref ('gold_kpi_tb_sales')}}
    GROUP BY client_id
),
SELECT
    client_id,
    full_name,
    total_amount_spent,
    CASE 
        WHEN total_amount_spent > 5000 THEN 'Alto'
        WHEN total_amount_spent BETWEEN 1000 AND 5000 THEN 'Médio'
        ELSE 'Baixo'
    END AS ltv_category
FROM source

-- Ver melhoria.