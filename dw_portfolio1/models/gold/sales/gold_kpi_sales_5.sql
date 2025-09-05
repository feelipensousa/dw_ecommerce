-- 5) calcular ltv médio por cliente
WITH source AS (
    SELECT
        client_id,
        full_name,
        SUM(revenue) AS total_amount_spent,
        MIN(order_date) AS first_purchase,
        MAX(order_date) AS last_purchase
    FROM {{ ref('gold_kpi_tb_sales') }}
    GROUP BY client_id, full_name
),
ltv AS (
    SELECT
        client_id,
        full_name,
        total_amount_spent,
        EXTRACT(YEAR FROM age(MAX(last_purchase), MIN(first_purchase))) * 12 
          + EXTRACT(MONTH FROM age(MAX(last_purchase), MIN(first_purchase))) AS months_active
    FROM source
)
SELECT
    client_id,
    full_name,
    total_amount_spent,
    CASE 
        WHEN total_amount_spent > 5000 THEN 'Alto'
        WHEN total_amount_spent BETWEEN 1000 AND 5000 THEN 'Médio'
        ELSE 'Baixo'
    END AS ltv_category,
    ROUND(total_amount_spent / NULLIF(months_active,0),2) AS avg_monthly_ltv
FROM ltv;
