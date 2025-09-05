-- 4) rankear faixa de idade de clientes que mais geraram receita por categorias
WITH source AS (
    SELECT
        age_range,
        category,
        SUM(revenue) AS total_amount_spent
    FROM {{ ref('gold_kpi_tb_sales') }}
    GROUP BY age_range, category
),
ranking AS (
    SELECT
        age_range,
        category,
        total_amount_spent,
        RANK() OVER (PARTITION BY age_range ORDER BY total_amount_spent DESC) AS value_rank
    FROM source
)
SELECT
    age_range,
    category,
    total_amount_spent,
    value_rank
FROM ranking
WHERE value_rank = 1
ORDER BY age_range;
