-- 2) custo total e CPA por idade
{{ config(
    schema='public_gold',
    materialized='view'
) }}
WITH source AS(
    SELECT
        s.client_id,
        s.product_id,
        pm.conversions,
        pm.cost,
        s.age_range -- Não é por age e sim por age_range da gold_sales
    FROM {{ ref('gold_kpi_tb_sales') }} AS s
    LEFT JOIN {{ ref('silver_products_metrics') }} AS pm
        ON s.product_id = pm.product_id
),
agg_by_age AS (
    SELECT
        age_range,
        SUM(cost) AS total_cost,
        SUM(conversions) AS total_conversions
    FROM source
    GROUP BY age_range
)
SELECT
    age_range,
    total_cost,
    total_cost / NULLIF(total_conversions, 0) AS cpa
FROM agg_by_age
ORDER BY total_cost DESC
