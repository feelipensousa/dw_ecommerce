
  
    

  create  table "dwecommerce01"."public_public_gold"."gold_kpi_tb_metrics__dbt_tmp"
  
  
    as
  
  (
    

WITH source AS (
    SELECT *
    FROM "dwecommerce01"."public"."silver_products_metrics"
)

SELECT * FROM source
  );
  