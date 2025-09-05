with source as (
    SELECT
        ad_ID,
        clicks,
        impressions,
        cost,
        leads,
        conversions,
        conversion_rate,
        device,
        product_id,
        platform,
        ad_date
    FROM {{ source('db_ecommerce_k53u', 'Products_Metrics') }}
),

silver_metrics as (
    SELECT
        ad_ID,
        clicks,
        impressions,
        cost,
        leads,
        conversions,
        CASE
            WHEN clicks > 0 THEN conversions / clicks
            ELSE 0
        END AS conversion_rate,
        LOWER(device) as device,
        product_id,
        platform,
        ad_date,
        -- Adicionamos novas métricas de análise
        CASE
            WHEN clicks > 0 THEN cost / clicks
            ELSE 0
        END AS cpc, -- Custo por clique
        CASE
            WHEN impressions > 0 THEN clicks / impressions
            ELSE 0
        END AS ctr, -- Taxa de cliques
    FROM source
)

SELECT * FROM silver_metrics