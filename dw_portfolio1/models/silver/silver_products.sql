with source as (
    SELECT
        product_id,
        product_name,
        category,
        unit_price,
    FROM {{ source ('db_ecommerce_k53u', 'Products') }}        
)

silver_products as (
    SELECT
        product_id,
        INITCAP(product_name) as product_name,
        INITCAP(category) as category,
        unit_price,
    FROM source
)

SELECT * FROM silver_products