-- 1) Produtos e categorias que mais venderam (quantidade e receita)
{{ config(
    schema='public_gold',
    materialized='view'
) }}

WITH sales AS (
    SELECT
        product,
        category,
        SUM(revenue) AS total_revenue,
        COUNT(order_id) AS total_orders,
        SUM(quantity) AS total_quantity
    FROM {{ ref('gold_kpi_tb_sales') }}
    GROUP BY product, category
)

-- Ranking por receita
, ranking_revenue AS (
    SELECT
        product,
        category,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS rank_revenue
    FROM sales
)

-- Ranking por quantidade vendida
, ranking_quantity AS (
    SELECT
        product,
        category,
        total_quantity,
        RANK() OVER (ORDER BY total_quantity DESC) AS rank_quantity
    FROM sales
)

SELECT
    s.product,
    s.category,
    s.total_revenue,
    s.total_quantity,
    r.rank_revenue,
    q.rank_quantity
FROM sales s
LEFT JOIN ranking_revenue r ON s.product = r.product AND s.category = r.category
LEFT JOIN ranking_quantity q ON s.product = q.product AND s.category = q.category
ORDER BY r.rank_revenue, q.rank_quantity;
