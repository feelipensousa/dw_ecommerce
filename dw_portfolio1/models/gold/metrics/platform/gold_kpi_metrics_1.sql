WITH source AS (
    SELECT
        product_id,
        platform,
        SUM(cost) AS total_cost,
        AVG(conversion_rate) AS avg_conversion_rate,
        AVG(cpc) AS avg_cpc,
        AVG(ctr) AS avg_ctr,
        SUM(impressions) * AVG(conversion_rate) AS impressions_conversion_score
    FROM {{ ref('silver_products_metrics') }}
    GROUP BY product_id, platform
),
revenue_amount AS (
    SELECT
        product_id,
        SUM(revenue) AS total_revenue
    FROM {{ ref('gold_kpi_tb_sales') }}
    GROUP BY product_id
),
joined AS (
    SELECT
        s.platform,
        s.product_id,
        s.avg_conversion_rate,
        s.avg_cpc,
        s.avg_ctr,
        s.impressions_conversion_score,
        r.total_revenue,
        s.total_cost
    FROM source s
    LEFT JOIN revenue_amount r ON r.product_id = s.product_id
),
agg_platform AS (
    SELECT
        platform,
        AVG(avg_conversion_rate) AS avg_conversion_rate,
        AVG(avg_cpc) AS avg_cpc,
        AVG(avg_ctr) AS avg_ctr,
        SUM(impressions_conversion_score) AS impressions_conversion_score,
        SUM(total_revenue) / NULLIF(SUM(total_cost),0) AS roas
    FROM joined
    GROUP BY platform
)
SELECT * FROM agg_platform
ORDER BY roas DESC;
