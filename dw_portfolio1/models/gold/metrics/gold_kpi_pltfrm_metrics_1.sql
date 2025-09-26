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
        ON pm.product_id = s.product_id AND pm.ad_date = s.order_date
),

multipliers AS (
    SELECT
        *,
        --  Adicionamos multiplicadores pra dar 'realidade' a variação dos dados
        -- CTR
        CASE
            WHEN platform = 'Google Ads' THEN 1.5
            WHEN platform = 'Facebook Ads' THEN 1.2
            WHEN platform = 'LinkedIn Ads' THEN 0.8
            ELSE 1.0
        END AS ctr_multiplier,
        -- CPC
        CASE
            WHEN platform = 'Google Ads' THEN 1.0
            WHEN platform = 'Facebook Ads' THEN 1.2
            WHEN platform = 'LinkedIn Ads' THEN 1.8
            ELSE 1.0
        END AS cpc_multiplier,
        -- Conversions
        CASE
            WHEN platform = 'Google Ads' THEN 1.3
            WHEN platform = 'Facebook Ads' THEN 1.1
            WHEN platform = 'LinkedIn Ads' THEN 0.7
            ELSE 1.0
        END AS conversion_multiplier
    FROM source
),

agg_by_platform AS (
    SELECT
        platform,
        SUM(impressions) AS total_impressions,
        SUM(clicks * ctr_multiplier) AS m_clicks,
        SUM(conversions * conversion_multiplier) AS m_conversions,
        SUM(cost * cpc_multiplier) AS m_cost,
        SUM(revenue) AS total_revenue
    FROM multipliers
    GROUP BY platform
)

SELECT
    platform,
    total_revenue,
    m_cost,
    m_cost / NULLIF(m_conversions, 0) AS cpa,
    m_clicks / NULLIF(total_impressions, 0) AS ctr,
    m_cost / NULLIF(m_clicks, 0) AS cpc,
    total_revenue / NULLIF(m_cost, 0) AS roas,
    (total_revenue - m_cost) / NULLIF(m_cost, 0) AS roi,
    m_conversions / NULLIF(m_clicks, 0) AS conversion_rate
FROM agg_by_platform
ORDER BY roas DESC