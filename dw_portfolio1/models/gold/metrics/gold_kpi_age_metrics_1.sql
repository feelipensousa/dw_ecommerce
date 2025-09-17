-- 1) maior taxa de conversão média, cpc médio, ctr médio, ROAS, teve mais impressões x taxa de conversões e ROI por idade
{{ config(
    schema='public_gold',
    materialized='view'
) }}
WITH source AS (
    SELECT
        s.client_id,
        s.product_id,
        s.revenue,
        pm.clicks,
        pm.impressions,
        pm.conversions,
        pm.cost,
        s.age_range 
    FROM {{ ref('gold_kpi_tb_sales') }} AS s
    LEFT JOIN {{ ref('silver_products_metrics') }} AS pm
        ON s.product_id = pm.product_id
),
agg_by_age AS(
    SELECT
        age_range,
        SUM(clicks) AS total_clicks,
        SUM(impressions) AS total_impressions,
        SUM(conversions) AS total_conversions,
        SUM(cost) AS total_cost,
        SUM(revenue) AS total_revenue
    FROM source
    GROUP BY age_range
)
SELECT
    age_range,
    total_revenue,
    total_cost,
    total_clicks / NULLIF(total_impressions, 0) AS ctr,
    total_cost / NULLIF(total_clicks, 0) AS cpc,
    total_revenue / NULLIF(total_cost, 0) AS roas,
    (total_revenue - total_cost) / NULLIF(total_cost, 0) AS roi,
    total_conversions / NULLIF(total_clicks, 0) AS conversion_rate
FROM agg_by_age
ORDER BY roas DESC