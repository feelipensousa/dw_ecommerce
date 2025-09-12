-- 1) maior taxa de conversão média, cpc médio, ctr médio, ROAS, teve mais impressões x taxa de conversões e ROI por país
{{ config(
    schema='public_gold',
    materialized='view'
) }}
WITH source AS (
    SELECT
        pm.product_id,
        pm.ad_date,
        pm.clicks,
        pm.impressions,
        pm.conversions,
        pm.cost,
        s.order_country,
        s.revenue
    FROM {{ ref('silver_products_metrics') }} AS pm
    LEFT JOIN {{ ref('silver_sales') }} AS s
        ON pm.product_id = s.product_id AND pm.ad_date = s.order_date
),

agg_by_country AS (
    SELECT
        order_country AS country,
        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        SUM(conversions) AS total_conversions,
        SUM(cost) AS total_cost,
        SUM(revenue) AS total_revenue
    FROM source
    GROUP BY country
)

SELECT
    country,
    total_clicks / NULLIF(total_impressions, 0) AS ctr,
    total_cost / NULLIF(total_clicks, 0) AS cpc,
    total_revenue / NULLIF(total_cost, 0) AS roas,
    (total_revenue - total_cost) / NULLIF(total_cost, 0) AS roi,
    total_conversions / NULLIF(total_clicks, 0) AS conversion_rate
FROM agg_by_country
ORDER BY roas DESC;