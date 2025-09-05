-- 7) calcular ticket médio por cliente
WITH source AS (
    SELECT
        COUNT(DISTINCT client_id) AS total_clients,
        SUM(revenue) AS total_amount_spent
    FROM {{ ref ('gold_kpi_tb_sales') }}
)
SELECT
    total_amount_spent / total_clients AS avg_ticket_per_client
FROM source;


-- Em análise pra entender a lógica.