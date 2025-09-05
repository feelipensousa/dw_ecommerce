-- 4) rankear faixa de idade de clientes que mais geraram receita e categorias por faixa de idade
WITH source AS (
    SELECT
        age_range,
        category,
        SUM(revenue) as total_amount_spent,
    FROM {{ ref ('gold_kpi_tb_sales')}}
)

-- Em análise pra entender a lógica.