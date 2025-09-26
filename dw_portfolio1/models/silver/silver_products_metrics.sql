with source as (
    SELECT
        "ad_ID",
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
    FROM {{ source('dwecommerce01', 'Products_Metrics') }}
),

silver_metrics as (
    SELECT
        "ad_ID" as ad_id,
        clicks,
        impressions,
        cost,
        leads,
        conversions,
        ROUND(
            CASE
                WHEN clicks > 0 THEN conversions::decimal / clicks
                ELSE 0
            END, 4
        ) AS conversion_rate,
        LOWER(device) as device,
        product_id,
        platform,
        ad_date,
        ROUND(
            CASE
                WHEN impressions > 0 THEN clicks::decimal / impressions
                ELSE 0
            END, 4
        ) AS ctr
    FROM source
)

SELECT * FROM silver_metrics