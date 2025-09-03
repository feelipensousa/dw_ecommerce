{{ config(
    materialized='table'  
) }}

WITH sales_KPI AS (
SELECT
    *
FROM {{ref ('silver_sales')}}
)

WITH clients AS (
SELECT
    full_name,
    country AS client_country,
    age
FROM {{ref ('silver_clients')}}
)

WITH products AS (
SELECT
    category
FROM {{ref ('silver_products')}}
)

joined AS (
SELECT
    s.order_id,
    s.order_date,
    s.product_id,
    s.product
    s.quantity,
    s.unit_price,
    s.revenue,
    s.order_country,
    c.full_name,
    c.client_country,
    c.age,
    p.category

FROM sales_KPI s
LEFT JOIN clients c ON s.client_id = c.client_id
LEFT JOIN products p ON s.product_id = p.product_id

)