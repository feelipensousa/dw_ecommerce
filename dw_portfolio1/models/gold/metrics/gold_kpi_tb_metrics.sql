{{ config(
    schema='public_gold',
    materialized='table'
) }}

WITH metrics AS (
    SELECT *
    FROM {{ ref('silver_products_metrics') }}
),
sales AS (
    SELECT *
    FROM {{ ref('gold_kpi_tb_sales') }}
),
gold_metrics AS (
    SELECT
        m.ad_id,
        m.clicks,
        m.impressions,
        m.cost,
        m.leads,
        m.conversions,
        m.conversion_rate,
        m.device,
        m.product_id,
        m.platform,
        m.ad_date,
        m.ctr,
        s.client_id,
        s.client_country,
        s.age_range,
        s.order_country,
        s.revenue,
        s.category,
        s.trimester
    FROM metrics m
    LEFT JOIN sales s
        ON m.product_id = s.product_id
)
SELECT * FROM gold_metrics

