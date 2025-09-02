with source as (
    SELECT
        order_id,
        quantity,
        order_date,
        order_country,
        product,
        product_id,
        client_id
    FROM {{ source ('db_ecommerce_k53u', 'Sales_data') }}        
),

products as (
    SELECT
        product_id,
        unit_price
    FROM {{ source ('db_ecommerce_k53u', 'Products') }}
),

joined as (
    SELECT
        s.*,
        p.unit_price
    FROM source s
    LEFT JOIN products p ON s.product_id = p.product_id
),

renamed as ( -- Adicionamos a coluna revenue e renomeamos os países
    SELECT
        order_id,
        quantity,
        unit_price,
        quantity * unit_price as revenue,
        order_date,
        CASE
            WHEN order_country = 'EUROPEAN COMMUNITY' THEN 'Estonia'
            WHEN order_country = 'RSA' THEN 'South Africa'
            WHEN order_country = 'EIRE' THEN 'Ireland'
            WHEN order_country = 'USA' THEN 'United States of America'
            ELSE order_country
        END as order_country,
        product,
        product_id,
        client_id
    FROM joined
)

SELECT * FROM renamed