-- 1) maior taxa de conversão média, CPC médio, CTR médio, ROAS médio, maior impressão x taxa de conversões e ROI por plataforma.


WITH base_joined AS (
    SELECT
        pm.platform,
        pm.product_id,
        pm.clicks,
        pm.impressions,
        pm.conversions,
        pm.cost,
        s.revenue
    FROM "dwecommerce01"."public"."silver_products_metrics" AS pm
    LEFT JOIN "dwecommerce01"."public_public_gold"."gold_kpi_tb_sales" AS s
        ON pm.product_id = s.product_id AND pm.ad_date = s.order_date
),

with_multipliers AS (
    SELECT
        *,
        -- Multiplicador para o CTR (taxa de clique) por plataforma
        CASE
            WHEN platform = 'Google Ads' THEN 1.5
            WHEN platform = 'Facebook Ads' THEN 1.2
            WHEN platform = 'LinkedIn Ads' THEN 0.8
            ELSE 1.0
        END AS ctr_multiplier,
        -- Multiplicador para o CPC (custo) por plataforma
        CASE
            WHEN platform = 'Google Ads' THEN 1.0
            WHEN platform = 'Facebook Ads' THEN 1.2
            WHEN platform = 'LinkedIn Ads' THEN 1.8
            ELSE 1.0
        END AS cpc_multiplier,
        -- Multiplicador para a taxa de conversão por plataforma
        CASE
            WHEN platform = 'Google Ads' THEN 1.3
            WHEN platform = 'Facebook Ads' THEN 1.1
            WHEN platform = 'LinkedIn Ads' THEN 0.7
            ELSE 1.0
        END AS conversion_multiplier
    FROM base_joined
),

agg_by_platform AS (
    SELECT
        platform,
        SUM(impressions) AS total_impressions,
        -- Aplicamos os multiplicadores para as métricas
        SUM(clicks * ctr_multiplier) AS adjusted_clicks,
        SUM(conversions * conversion_multiplier) AS adjusted_conversions,
        SUM(cost * cpc_multiplier) AS adjusted_cost,
        SUM(revenue) AS total_revenue
    FROM with_multipliers
    GROUP BY platform
)

SELECT
    platform,
    total_revenue,
    adjusted_cost,
    adjusted_cost / NULLIF(adjusted_conversions, 0) AS cpa,
    adjusted_clicks / NULLIF(total_impressions, 0) AS ctr,
    adjusted_cost / NULLIF(adjusted_clicks, 0) AS cpc,
    total_revenue / NULLIF(adjusted_cost, 0) AS roas,
    (total_revenue - adjusted_cost) / NULLIF(adjusted_cost, 0) AS roi,
    adjusted_conversions / NULLIF(adjusted_clicks, 0) AS conversion_rate
FROM agg_by_platform
ORDER BY roas DESC