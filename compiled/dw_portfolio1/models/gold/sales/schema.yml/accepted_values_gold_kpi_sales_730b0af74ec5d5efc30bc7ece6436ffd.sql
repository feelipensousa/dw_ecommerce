
    
    

with all_values as (

    select
        segmento_rfm as value_field,
        count(*) as n_records

    from "dwecommerce01"."public_public_gold"."gold_kpi_sales_7"
    group by segmento_rfm

)

select *
from all_values
where value_field not in (
    'Campeão','Cliente Fiel','Potencial','Em Observação','Em Risco de Churn','Inativo'
)


