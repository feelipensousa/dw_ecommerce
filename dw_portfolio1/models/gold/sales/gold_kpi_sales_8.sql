-- 8) Rankear categorias que mais venderam por país
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

-- Ranking por receita (dentro de cada país)
ranking_revenue AS (
    SELECT
        order_country,
        category,
        total_revenue,
        RANK() OVER (PARTITION BY order_country ORDER BY total_revenue DESC) AS rank_revenue
    FROM sales
),

-- Ranking por quantidade vendida (dentro de cada país)
ranking_quantity AS (
    SELECT
        order_country,
        category,
        total_quantity,
        RANK() OVER (PARTITION BY order_country ORDER BY total_quantity DESC) AS rank_quantity
    FROM sales
)

SELECT
    s.order_country,
    s.category,
    s.total_revenue,
    s.total_quantity,
    r.rank_revenue,
    q.rank_quantity
FROM sales s
LEFT JOIN ranking_revenue r 
    ON s.order_country = r.order_country AND s.category = r.category
LEFT JOIN ranking_quantity q 
    ON s.order_country = q.order_country AND s.category = q.category
ORDER BY s.order_country, r.rank_revenue
