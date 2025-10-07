
  create view "dwecommerce01"."public_public_gold"."gold_kpi_sales_3__dbt_tmp"
    
    
  as (
    -- 3) rankear períodos do ano que mais venderam

WITH trimester_sales AS (
    SELECT
        trimester,
        SUM(revenue) AS total_revenue,
        COUNT(order_id) AS total_orders,
        SUM(quantity) AS total_quantity
    FROM "dwecommerce01"."public_public_gold"."gold_kpi_tb_sales"
    GROUP BY trimester
    ORDER BY total_revenue DESC, total_quantity DESC
)

SELECT * FROM trimester_sales
  );