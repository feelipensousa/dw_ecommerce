-- 3) rankear períodos do ano que mais venderam
{{ config(
    schema='public_gold',
    materialized='view'
) }}
WITH trimester_sales AS (
    SELECT
        trimester,
        SUM(revenue) AS total_revenue,
        COUNT(order_id) AS total_orders,
        SUM(quantity) AS total_quantity
    FROM {{ ref('gold_kpi_tb_sales') }}
    GROUP BY trimester
    ORDER BY total_revenue DESC, total_quantity DESC
)

SELECT * FROM trimester_sales
