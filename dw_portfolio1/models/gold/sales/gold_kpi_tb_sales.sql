{{ config(
    schema='public_gold',
    materialized='table'  
) }}

WITH sales_KPI AS (
    SELECT *
    FROM {{ ref('silver_sales') }}
),
clients AS (
    SELECT
        client_id,
        full_name,
        country AS client_country,
        age
    FROM {{ ref('silver_clients') }}
),
products AS (
    SELECT
        product_id,
        category
    FROM {{ ref('silver_products') }}
),
dates AS (
    SELECT
        order_id,
        order_date,
        extract(month from order_date) AS month_num,
        extract(year from order_date) AS year
    FROM {{ ref('silver_sales') }}
),
joined AS (
    SELECT
        s.order_id,
        s.order_date,
        CASE 
            WHEN d.month_num BETWEEN 1 AND 4 THEN '1º Trimestre'
            WHEN d.month_num BETWEEN 5 AND 8 THEN '2º Trimestre'
            WHEN d.month_num BETWEEN 9 AND 12 THEN '3º Trimestre'
        END AS trimester,
        s.product_id,
        s.product,
        s.quantity,
        s.unit_price,
        s.revenue,
        s.order_country,
        c.full_name,
        c.client_country,
        c.age,
        CASE 
            WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
            WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
            WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
            WHEN c.age BETWEEN 46 AND 55 THEN '46-55'
            ELSE '56+'
        END AS age_range,
        p.category
    FROM sales_KPI s
    LEFT JOIN clients c ON s.client_id = c.client_id
    LEFT JOIN products p ON s.product_id = p.product_id
    LEFT JOIN dates d ON s.order_id = d.order_id
)
SELECT * FROM joined


