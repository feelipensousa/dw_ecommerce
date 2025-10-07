

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
    FROM "dwecommerce01"."public"."silver_products_metrics" AS pm
    LEFT JOIN "dwecommerce01"."public"."silver_sales" AS s
        ON pm.product_id = s.product_id AND pm.ad_date = s.order_date
),

country_multipliers AS (
    SELECT
        *,
        -- MULTIPLICADORES POR CARACTERÍSTICAS DO MERCADO
        
        -- 1. MULTIPLICADOR DE COMPETIÇÃO (CPC)
        -- Baseado em: PIB per capita, maturidade digital, competição publicitária
        CASE 
            -- TIER 1: Mercados ultra-competitivos (CPC altíssimo)
            WHEN order_country IN ('United States of America', 'Switzerland', 'Norway') THEN 3.5
            WHEN order_country IN ('United Arab Emirates', 'Singapore', 'Hong Kong') THEN 3.2
            
            -- TIER 2: Mercados desenvolvidos com alta competição  
            WHEN order_country IN ('Germany', 'United Kingdom', 'Netherlands', 'Denmark', 'Sweden') THEN 2.8
            WHEN order_country IN ('Canada', 'Australia', 'Austria', 'Belgium', 'France') THEN 2.5
            WHEN order_country IN ('Japan', 'Finland', 'Iceland', 'Ireland') THEN 2.3
            
            -- TIER 3: Mercados desenvolvidos com competição média
            WHEN order_country IN ('Italy', 'Spain', 'Israel', 'Czech Republic') THEN 1.8
            WHEN order_country IN ('Portugal', 'Greece', 'Cyprus', 'Malta', 'Estonia', 'Lithuania') THEN 1.5
            
            -- TIER 4: Mercados emergentes (CPC baixo-médio)
            WHEN order_country IN ('Poland', 'Saudi Arabia', 'Bahrain', 'Lebanon') THEN 1.2
            WHEN order_country IN ('Brazil', 'South Africa') THEN 0.8
            
            -- Países pequenos/específicos
            WHEN order_country = 'Channel Islands' THEN 2.0
            WHEN order_country = 'Unspecified' THEN 1.0
            ELSE 1.0
        END AS cpc_multiplier,
        
        -- 2. MULTIPLICADOR DE ENGAJAMENTO (CTR)  
        -- Baseado em: cultura digital, saturação de ads, comportamento online
        CASE
            -- Alta saturação = CTR baixo (usuários cegos a ads)
            WHEN order_country IN ('United States of America', 'United Kingdom', 'Germany') THEN 0.7
            WHEN order_country IN ('Canada', 'Australia', 'France', 'Netherlands') THEN 0.8
            
            -- Mercados emergentes digitais = CTR alto (menor saturação)
            WHEN order_country IN ('Brazil', 'South Africa', 'Saudi Arabia', 'United Arab Emirates') THEN 1.4
            WHEN order_country IN ('Poland', 'Czech Republic', 'Estonia', 'Lithuania') THEN 1.3
            
            -- Mercados asiáticos (comportamento específico)
            WHEN order_country IN ('Japan', 'Singapore', 'Hong Kong') THEN 1.1
            
            -- Mercados nórdicos (alta qualidade, baixo spam)
            WHEN order_country IN ('Norway', 'Sweden', 'Denmark', 'Finland', 'Iceland') THEN 1.0
            
            -- Mercados mediterrâneos (engajamento médio-alto)
            WHEN order_country IN ('Italy', 'Spain', 'Portugal', 'Greece', 'Malta', 'Cyprus') THEN 1.2
            
            -- Outros desenvolvidos
            WHEN order_country IN ('Switzerland', 'Austria', 'Belgium', 'Ireland') THEN 0.9
            WHEN order_country IN ('Israel', 'Bahrain', 'Lebanon') THEN 1.1
            
            ELSE 1.0
        END AS ctr_multiplier,
        
        -- 3. MULTIPLICADOR DE CONVERSÃO
        -- Baseado em: poder aquisitivo, confiança em compras online, cultura de consumo
        CASE
            -- Mercados premium (alta conversão)
            WHEN order_country IN ('Switzerland', 'Norway', 'United Arab Emirates', 'Singapore') THEN 1.8
            WHEN order_country IN ('Germany', 'Netherlands', 'Denmark', 'Sweden', 'Austria') THEN 1.5
            WHEN order_country IN ('United States of America', 'Canada', 'Australia', 'United Kingdom') THEN 1.4
            
            -- Mercados maduros (conversão boa)
            WHEN order_country IN ('France', 'Belgium', 'Finland', 'Ireland', 'Iceland') THEN 1.3
            WHEN order_country IN ('Japan', 'Hong Kong', 'Israel') THEN 1.2
            
            -- Mercados com boa conversão mas menor ticket
            WHEN order_country IN ('Italy', 'Spain', 'Czech Republic', 'Estonia') THEN 1.1
            WHEN order_country IN ('Portugal', 'Poland', 'Lithuania', 'Cyprus', 'Malta') THEN 1.0
            
            -- Mercados emergentes (conversão menor por desconfiança/poder aquisitivo)
            WHEN order_country IN ('Brazil', 'South Africa') THEN 0.7
            WHEN order_country IN ('Saudi Arabia', 'Bahrain', 'Lebanon') THEN 0.9
            
            -- Mercados específicos
            WHEN order_country IN ('Greece', 'Channel Islands') THEN 0.8
            
            ELSE 1.0
        END AS conversion_multiplier
        
    FROM source
    WHERE order_country IS NOT NULL
),

adjusted_metrics AS (
    SELECT
        order_country AS country,
        
        -- MÉTRICAS BÁSICAS (sem ajuste)
        SUM(impressions) AS total_impressions,
        
        -- MÉTRICAS AJUSTADAS POR MULTIPLICADORES
        SUM(clicks * ctr_multiplier) AS adjusted_clicks,
        SUM(conversions * conversion_multiplier) AS adjusted_conversions,  
        SUM(cost * cpc_multiplier) AS adjusted_cost,
        SUM(revenue) AS adjusted_revenue,
        
        -- MÉTRICAS ORIGINAIS PARA COMPARAÇÃO
        SUM(clicks) AS original_clicks,
        SUM(conversions) AS original_conversions,
        SUM(cost) AS original_cost,
        SUM(revenue) AS original_revenue
        
    FROM country_multipliers
    GROUP BY order_country
)

SELECT
    country,
    adjusted_revenue AS total_revenue,
    adjusted_cost AS total_cost,
    
    -- KPIs REALÍSTICOS  
    adjusted_cost / NULLIF(adjusted_conversions, 0) AS cpa,
    adjusted_clicks / NULLIF(total_impressions, 0) AS ctr,
    adjusted_cost / NULLIF(adjusted_clicks, 0) AS cpc,
    adjusted_revenue / NULLIF(adjusted_cost, 0) AS roas,
    (adjusted_revenue - adjusted_cost) / NULLIF(adjusted_cost, 0) AS roi,
    adjusted_conversions / NULLIF(adjusted_clicks, 0) AS conversion_rate
    
    
FROM adjusted_metrics
ORDER BY roas DESC