-- 8) RFM clientes
WITH sales_KPI_RFM AS (
    SELECT 
        SUM(revenue) AS amount_client_spent,
        AVG(COUNT(order_id)) OVER (PARTITION BY client_id) AS frequency, -- Fazer mensal
        --case
        --    when count(distinct to_char(fp.dt_pedido, 'YYYY-MM')) > 0 
        --    then count(fp.sk_pedido)::float / count(distinct to_char(fp.dt_pedido, 'YYYY-MM'))
        --    else 0 
        --end as frequencia_media_mensal
        full_name,
        client_id,
        CURRENT_DATE - MAX(order_date) AS last_purchase_date,
        CASE
            WHEN amount_client_spent IS NULL OR amount_client_spent = 0 THEN 'Inativo'
            WHEN amount_client_spent > 5000 AND last_purchase_date <= 30 AND frequency >= 2 THEN 'Campeão' -- frequência média mensal
            WHEN amount_client_spent > 3000 AND last_purchase_date <= 60 THEN 'Cliente Fiel'
            WHEN amount_client_spent > 1000 AND last_purchase_date <= 90 THEN 'Potencial'
            WHEN amount_client_spent > 0 AND last_purchase_date > 180 THEN 'Em Risco de Churn'
            WHEN amount_client_spent > 0 THEN 'Em Observação'
            ELSE 'Inativo'
        END AS segmento_rfm

    FROM {{ ref('gold_kpi_tb_sales') }}
    GROUP BY client_id, full_name
)
SELECT * FROM sales_KPI_RFM;

-- Verificar se está correto e fazer ajuste.