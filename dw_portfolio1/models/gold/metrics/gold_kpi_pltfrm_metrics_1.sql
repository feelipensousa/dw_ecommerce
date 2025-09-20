-- 1) maior taxa de conversão média, CPC médio, CTR médio, ROAS médio, maior impressão x taxa de conversões e ROI por plataforma.
{{ config(
    schema='public_gold',
    materialized='view'
) }}
WITH source AS (
    SELECT
        pm.platform,
        pm.product_id,
        pm.clicks,
        pm.impressions,
        pm.conversions,
        pm.cost,
        s.revenue
    FROM {{ ref('silver_products_metrics') }} AS pm
    LEFT JOIN {{ ref('gold_kpi_tb_sales') }} AS s
        ON pm.product_id = s.product_id
),
agg_by_platform AS (
    SELECT
        platform,
        SUM(clicks) AS total_clicks,
        SUM(impressions) AS total_impressions,
        SUM(conversions) AS total_conversions,
        SUM(cost) AS total_cost,
        SUM(revenue) AS total_revenue
    FROM source
    GROUP BY platform
)
SELECT
    platform,
    total_revenue,
    total_cost,
    total_cost / NULLIF(total_conversions, 0) AS cpa,
    total_revenue / NULLIF(total_cost, 0) AS roas,
    total_clicks / NULLIF(total_impressions, 0) AS ctr,
    total_cost / NULLIF(total_clicks, 0) AS cpc,
    (total_revenue - total_cost) / NULLIF(total_cost, 0) AS roi,
    total_conversions / NULLIF(total_clicks, 0) AS conversion_rate
    
FROM agg_by_platform
ORDER BY roas DESC