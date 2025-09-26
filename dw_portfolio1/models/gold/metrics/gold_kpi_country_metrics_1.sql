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
        s.order_date,
        s.revenue
    FROM {{ ref('silver_products_metrics') }} AS pm
    LEFT JOIN {{ ref('silver_sales') }} AS s
        ON pm.product_id = s.product_id AND pm.ad_date = s.order_date
),

multipliers AS (
    SELECT
        *,
        --  Adicionamos multiplicadores pra dar 'realidade' a variação dos dados
        -- CPC
        CASE 
            WHEN order_country IN ('United States of America', 'Switzerland', 'Norway') THEN 3.5
            WHEN order_country IN ('United Arab Emirates', 'Singapore', 'Hong Kong') THEN 3.2
            WHEN order_country IN ('Germany', 'United Kingdom', 'Netherlands', 'Denmark', 'Sweden') THEN 2.8
            WHEN order_country IN ('Canada', 'Australia', 'Austria', 'Belgium', 'France') THEN 2.5
            WHEN order_country IN ('Japan', 'Finland', 'Iceland', 'Ireland') THEN 2.3
            WHEN order_country IN ('Italy', 'Spain', 'Israel', 'Czech Republic') THEN 1.8
            WHEN order_country IN ('Portugal', 'Greece', 'Cyprus', 'Malta', 'Estonia', 'Lithuania') THEN 1.5
            WHEN order_country IN ('Poland', 'Saudi Arabia', 'Bahrain', 'Lebanon') THEN 1.2
            WHEN order_country IN ('Brazil', 'South Africa') THEN 0.8            
            WHEN order_country = 'Channel Islands' THEN 2.0
            WHEN order_country = 'Unspecified' THEN 1.0

            ELSE 1.0
        END AS cpc_multiplier,
        
        -- CTR 
        CASE
            WHEN order_country IN ('United States of America', 'United Kingdom', 'Germany') THEN 0.7
            WHEN order_country IN ('Canada', 'Australia', 'France', 'Netherlands') THEN 0.8
            WHEN order_country IN ('Brazil', 'South Africa', 'Saudi Arabia', 'United Arab Emirates') THEN 1.4
            WHEN order_country IN ('Poland', 'Czech Republic', 'Estonia', 'Lithuania') THEN 1.3
            WHEN order_country IN ('Japan', 'Singapore', 'Hong Kong') THEN 1.1
            WHEN order_country IN ('Norway', 'Sweden', 'Denmark', 'Finland', 'Iceland') THEN 1.0
            WHEN order_country IN ('Italy', 'Spain', 'Portugal', 'Greece', 'Malta', 'Cyprus') THEN 1.2
            WHEN order_country IN ('Switzerland', 'Austria', 'Belgium', 'Ireland') THEN 0.9
            WHEN order_country IN ('Israel', 'Bahrain', 'Lebanon') THEN 1.1
            
            ELSE 1.0
        END AS ctr_multiplier,
        
        -- Conversion
        CASE
            WHEN order_country IN ('Switzerland', 'Norway', 'United Arab Emirates', 'Singapore') THEN 1.8
            WHEN order_country IN ('Germany', 'Netherlands', 'Denmark', 'Sweden', 'Austria') THEN 1.5
            WHEN order_country IN ('United States of America', 'Canada', 'Australia', 'United Kingdom') THEN 1.4
            WHEN order_country IN ('France', 'Belgium', 'Finland', 'Ireland', 'Iceland') THEN 1.3
            WHEN order_country IN ('Japan', 'Hong Kong', 'Israel') THEN 1.2
            WHEN order_country IN ('Italy', 'Spain', 'Czech Republic', 'Estonia') THEN 1.1
            WHEN order_country IN ('Portugal', 'Poland', 'Lithuania', 'Cyprus', 'Malta') THEN 1.0
            WHEN order_country IN ('Brazil', 'South Africa') THEN 0.7
            WHEN order_country IN ('Saudi Arabia', 'Bahrain', 'Lebanon') THEN 0.9
            WHEN order_country IN ('Greece', 'Channel Islands') THEN 0.8
            
            ELSE 1.0
        END AS conversion_multiplier
        
    FROM source
    WHERE order_country IS NOT NULL
),

agg_by_country AS (
    SELECT
        order_country AS country,
        
        SUM(impressions) AS total_impressions,
        SUM(clicks * ctr_multiplier) AS m_clicks,
        SUM(conversions * conversion_multiplier) AS m_conversions,  
        SUM(cost * cpc_multiplier) AS m_cost,
        SUM(revenue) AS total_revenue
        
    FROM multipliers
    GROUP BY order_country
)

SELECT
    country,
    total_revenue,
    m_cost AS total_cost,
    
    -- KPIs  
    m_cost / NULLIF(m_conversions, 0) AS cpa,
    m_clicks / NULLIF(total_impressions, 0) AS ctr,
    m_cost / NULLIF(m_clicks, 0) AS cpc,
    total_revenue / NULLIF(m_cost, 0) AS roas,
    (total_revenue - m_cost) / NULLIF(m_cost, 0) AS roi,
    m_conversions / NULLIF(m_clicks, 0) AS conversion_rate
    
FROM agg_by_country
ORDER BY roas DESC