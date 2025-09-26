-- 1) maior taxa de conversão média, cpc médio, ctr médio, ROAS, teve mais impressões x taxa de conversões e ROI por idade
{{ config(
    schema='public_gold',
    materialized='view'
) }}

WITH source AS (
    SELECT
        s.client_id,
        s.age_range,
        s.revenue,
        pm.clicks,
        pm.impressions,
        pm.conversions,
        pm.cost,
        
        --  Adicionamos multiplicadores pra dar 'realidade' a variação dos dados
        CASE
            WHEN s.age_range = '18-25' THEN 1.4    
            WHEN s.age_range = '26-35' THEN 1.1   
            WHEN s.age_range = '36-45' THEN 0.9    
            WHEN s.age_range = '46-55' THEN 0.7    
            WHEN s.age_range = '56+' THEN 0.5      
            ELSE 1.0
        END AS ctr_multiplier,
        
        CASE  
            WHEN s.age_range = '18-25' THEN 0.7    
            WHEN s.age_range = '26-35' THEN 1.0    
            WHEN s.age_range = '36-45' THEN 1.3    
            WHEN s.age_range = '46-55' THEN 1.8    
            WHEN s.age_range = '56+' THEN 2.2      
            ELSE 1.0
        END AS cpc_multiplier,
        
        CASE
            WHEN s.age_range = '18-25' THEN 0.6    
            WHEN s.age_range = '26-35' THEN 0.9   
            WHEN s.age_range = '36-45' THEN 1.2   
            WHEN s.age_range = '46-55' THEN 1.5    
            WHEN s.age_range = '56+' THEN 1.8      
            ELSE 1.0  
        END AS conversion_multiplier
        ---

    FROM {{ ref('gold_kpi_tb_sales') }} s
    LEFT JOIN {{ ref('silver_products_metrics') }} pm
        ON s.product_id = pm.product_id AND s.order_date = pm.ad_date
),

agg_by_age AS (
    SELECT
        age_range,
        
        SUM(clicks * ctr_multiplier) AS m_clicks,
        SUM(impressions) AS total_impressions,
        SUM(conversions * conversion_multiplier) AS m_conversions,
        SUM(cost * cpc_multiplier) AS m_cost,
        SUM(revenue) AS total_revenue
        
    FROM source
    GROUP BY age_range
)

SELECT
    age_range,
    total_revenue,
    m_cost as total_cost,
    
    -- KPIs
    m_cost / NULLIF(m_conversions, 0) AS cpa,
    m_clicks / NULLIF(total_impressions, 0) AS ctr,
    m_cost / NULLIF(m_clicks, 0) AS cpc,    
    total_revenue / NULLIF(m_cost, 0) AS roas,
    (total_revenue - m_cost) / NULLIF(m_cost, 0) AS roi,
    m_conversions / NULLIF(m_clicks, 0) AS conversion_rate
    
FROM agg_by_age
ORDER BY roas DESC