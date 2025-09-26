WITH source AS (
    SELECT
        product_id,
        product_name,
        category,
        unit_price
    FROM {{ source('dwecommerce01', 'Products') }}        
),

silver_products AS (
    SELECT
        product_id,
        INITCAP(product_name) AS product_name,
        INITCAP(category) AS category,
        unit_price
    FROM source
)

SELECT * FROM silver_products
