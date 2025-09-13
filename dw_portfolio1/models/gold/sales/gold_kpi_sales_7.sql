-- 7) RFM clientes
{{ config(
    schema='public_gold',
    materialized='view'
) }}
WITH source AS (
    SELECT 
        client_id,
        full_name,
        SUM(revenue) AS amount_client_spent,
        COUNT(order_id) AS total_orders,
        COUNT(DISTINCT to_char(order_date, 'YYYY-MM')) AS active_months,
        MAX(order_date) AS last_order_date
    FROM {{ ref('gold_kpi_tb_sales') }}
    GROUP BY client_id, full_name
),
rfm_calc AS (
    SELECT
        client_id,
        full_name,
        amount_client_spent,
        CASE 
            WHEN active_months > 0 
            THEN total_orders::float / active_months
            ELSE 0 
        END AS monthly_frequency,
        EXTRACT(DAY FROM (CURRENT_DATE - last_order_date))::int AS days_since_last_purchase
    FROM source
),
rfm_segment AS (
    SELECT
        *,
        CASE
            WHEN amount_client_spent IS NULL OR amount_client_spent = 0 THEN 'Inativo'
            WHEN amount_client_spent > 5000 AND days_since_last_purchase <= 30 AND monthly_frequency >= 2 THEN 'Campeão'
            WHEN amount_client_spent > 3000 AND days_since_last_purchase <= 60 THEN 'Cliente Fiel'
            WHEN amount_client_spent > 1000 AND days_since_last_purchase <= 90 THEN 'Potencial'
            WHEN amount_client_spent > 0 AND days_since_last_purchase > 180 THEN 'Em Risco de Churn'
            WHEN amount_client_spent > 0 THEN 'Em Observação'
            ELSE 'Inativo'
        END AS segmento_rfm
    FROM rfm_calc
)
SELECT * FROM rfm_segment

-- Provavelmente analisar churn por categoria, pensar em outros gráficos.