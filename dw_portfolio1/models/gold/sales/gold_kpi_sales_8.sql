{{ config(
    schema='public_gold',
    materialized='view'
) }}

WITH sales AS (
    SELECT
        order_country,
        category,
        SUM(revenue) AS total_revenue,
        SUM(quantity) AS total_quantity,
        COUNT(order_id) AS total_orders
    FROM {{ ref('gold_kpi_tb_sales') }}
    GROUP BY order_country, category
),

-- Ranking por receita (TOP 1 categoria por país)
ranking_revenue AS (
    SELECT
        order_country,
        category,
        total_revenue,
        total_quantity,
        ROW_NUMBER() OVER (PARTITION BY order_country ORDER BY total_revenue DESC) AS rn_revenue
    FROM sales
),

-- Ranking por quantidade (TOP 1 categoria por país)
ranking_quantity AS (
    SELECT
        order_country,
        category,
        total_revenue,
        total_quantity,
        ROW_NUMBER() OVER (PARTITION BY order_country ORDER BY total_quantity DESC) AS rn_quantity
    FROM sales
),

-- Seleção final
final AS (
    SELECT
        r.order_country,
        r.category AS top_category_revenue,
        r.total_revenue,
        r.total_quantity,
        q.category AS top_category_quantity,
        q.total_quantity AS top_quantity,
        q.total_revenue AS revenue_of_top_quantity
    FROM ranking_revenue r
    JOIN ranking_quantity q
        ON r.order_country = q.order_country
    WHERE r.rn_revenue = 1
      AND q.rn_quantity = 1
)

SELECT * FROM final
ORDER BY order_country
