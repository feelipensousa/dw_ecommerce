
    
    

select
    order_id as unique_field,
    count(*) as n_records

from "dwecommerce01"."public_public_gold"."gold_kpi_tb_sales"
where order_id is not null
group by order_id
having count(*) > 1


