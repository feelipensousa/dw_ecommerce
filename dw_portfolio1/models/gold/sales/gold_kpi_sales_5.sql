-- 5) calcular ltv médio por cliente
{{ config(
    schema='public_gold',
    materialized='view'
) }}
WITH source AS (
    SELECT
        client_id,
        MAX(full_name) AS full_name,
        SUM(revenue) AS total_amount_spent,
        MIN(order_date::date) AS first_purchase,
        MAX(order_date::date) AS last_purchase
    FROM {{ ref('gold_kpi_tb_sales') }}
    GROUP BY client_id
),
ltv AS (
    SELECT
        client_id,
        full_name,
        total_amount_spent,
        GREATEST(
            EXTRACT(YEAR FROM age(last_purchase, first_purchase)) * 12 
            + EXTRACT(MONTH FROM age(last_purchase, first_purchase)), 
            1
        ) AS months_active
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
    ROUND((total_amount_spent / NULLIF(months_active,0))::numeric, 2) AS avg_monthly_ltv
FROM ltv

