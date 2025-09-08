-- 2) custo total e CPA por plataforma

WITH source AS (
    platform,
    SUM(cost) as total_cost,
    SUM(cost) / NULLIF(SUM(conversions), 0) AS cpa
    FROM {{ ref('silver_products_metrics') }}
    GROUP BY platform
),
SELECT * FROM source  
