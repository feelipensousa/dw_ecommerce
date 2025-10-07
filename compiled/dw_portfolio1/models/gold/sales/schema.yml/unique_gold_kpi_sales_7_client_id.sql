
    
    

select
    client_id as unique_field,
    count(*) as n_records

from "dwecommerce01"."public_public_gold"."gold_kpi_sales_7"
where client_id is not null
group by client_id
having count(*) > 1


