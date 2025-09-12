-- 2) custo total e CPA por idade
{{ config(
    schema='public_gold',
    materialized='view'
) }}
WITH source AS(
    SELECT
        SELECT
        s.client_id,
        s.product_id,
        pm.conversions,
        pm.cost,
        c.age
    FROM {{ ref('silver_sales') }} AS s
    LEFT JOIN {{ ref('silver_products_metrics') }} AS pm
        ON s.product_id = pm.product_id
    LEFT JOIN {{ ref('silver_clients') }} AS c
        ON s.client_id = c.client_id
),
agg_by_age AS (
    SELECT
        age,
        SUM(cost) AS total_cost,
        SUM(conversions) AS total_conversions
    FROM source
    GROUP BY age
)
SELECT
    age,
    total_cost,
    total_cost / NULLIF(total_conversions, 0) AS cpa
FROM agg_by_age
ORDER BY total_cost DESC;
