-- 6) calcular ticket médio por cliente

WITH source AS (
    SELECT
        COUNT(DISTINCT client_id) AS total_clients,
        SUM(revenue) AS total_amount_spent
    FROM "dwecommerce01"."public_public_gold"."gold_kpi_tb_sales"
)
SELECT
    total_amount_spent / total_clients AS avg_ticket_per_client
FROM source