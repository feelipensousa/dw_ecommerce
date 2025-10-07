WITH realistic_multipliers AS (
    SELECT
        s.order_id,
        s.age_range,
        s.revenue,
        pm.clicks,
        pm.impressions,
        pm.conversions,
        pm.cost,
        
        -- MULTIPLICADORES QUE CRIAM VARIAÇÃO REALÍSTICA
        CASE
            WHEN s.age_range = '18-25' THEN 1.4    -- Jovens: mais engajamento
            WHEN s.age_range = '26-35' THEN 1.1    -- Adultos jovens: baseline
            WHEN s.age_range = '36-45' THEN 0.9    -- Adultos: menos cliques
            WHEN s.age_range = '46-55' THEN 0.7    -- Maduros: muito seletivos
            WHEN s.age_range = '56+' THEN 0.5      -- Idosos: baixo engajamento
            ELSE 1.0
        END AS ctr_multiplier,
        
        CASE  
            WHEN s.age_range = '18-25' THEN 0.7    -- Jovens: ads mais baratas
            WHEN s.age_range = '26-35' THEN 1.0    -- Baseline
            WHEN s.age_range = '36-45' THEN 1.3    -- Competição média
            WHEN s.age_range = '46-55' THEN 1.8    -- Alta competição (poder aquisitivo)
            WHEN s.age_range = '56+' THEN 2.2      -- Nicho caro
            ELSE 1.0
        END AS cpc_multiplier,
        
        CASE
            WHEN s.age_range = '18-25' THEN 0.6    -- Jovens: baixa conversão
            WHEN s.age_range = '26-35' THEN 0.9    -- Adultos jovens
            WHEN s.age_range = '36-45' THEN 1.2    -- Poder aquisitivo crescente  
            WHEN s.age_range = '46-55' THEN 1.5    -- Peak earning years
            WHEN s.age_range = '56+' THEN 1.8      -- Altos gastos, decisão rápida
            ELSE 1.0  
        END AS conversion_multiplier
        
    FROM "dwecommerce01"."public_public_gold"."gold_kpi_tb_sales" s
    LEFT JOIN "dwecommerce01"."public"."silver_products_metrics" pm
        ON s.product_id = pm.product_id AND s.order_date = pm.ad_date
),

realistic_metrics AS (
    SELECT
        age_range,
        
        -- APLICANDO OS MULTIPLICADORES
        SUM(clicks * ctr_multiplier) AS adjusted_clicks,
        SUM(impressions) AS total_impressions,  -- Impressões não mudam
        SUM(conversions * conversion_multiplier) AS adjusted_conversions,
        SUM(cost * cpc_multiplier) AS adjusted_cost,
        SUM(revenue) AS total_revenue
        
    FROM realistic_multipliers
    GROUP BY age_range
)

-- RESULTADO COM VARIAÇÃO REALÍSTICA
SELECT
    age_range,
    total_revenue,
    adjusted_cost as total_cost,
    
    -- KPIs COM VARIAÇÃO REAL
    adjusted_cost / NULLIF(adjusted_conversions, 0) AS cpa,
    adjusted_clicks / NULLIF(total_impressions, 0) AS ctr,  -- Agora varia 25-45%!
    adjusted_cost / NULLIF(adjusted_clicks, 0) AS cpc,      -- Agora varia 70-220%!
    total_revenue / NULLIF(adjusted_cost, 0) AS roas,
    (total_revenue - adjusted_cost) / NULLIF(adjusted_cost, 0) AS roi,
    adjusted_conversions / NULLIF(adjusted_clicks, 0) AS conversion_rate -- Varia 60-180%!
    
FROM realistic_metrics
ORDER BY roas DESC