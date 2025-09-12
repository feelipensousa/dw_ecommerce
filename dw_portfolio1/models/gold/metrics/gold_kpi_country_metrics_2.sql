-- 2) custo total e CPA por país
{{ config(
    schema='public_gold',
    materialized='view'
) }}
WITH source AS (
    SELECT
        pm.cost,
        pm.conversions,
        s.order_country
    FROM {{ ref('silver_products_metrics') }} AS pm
    LEFT JOIN {{ ref('silver_sales') }} AS s
        ON pm.product_id = s.product_id
),
agg_by_country AS (
    SELECT
        order_country AS country,
        SUM(cost) AS total_cost,
        SUM(conversions) AS total_conversions
    FROM source
    GROUP BY country
)
SELECT
    country,
    total_cost,
    total_cost / NULLIF(total_conversions, 0) AS cpa
FROM agg_by_country
ORDER BY total_cost DESC;