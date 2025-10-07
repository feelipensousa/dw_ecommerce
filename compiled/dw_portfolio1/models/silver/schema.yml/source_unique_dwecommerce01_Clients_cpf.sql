
    
    

select
    cpf as unique_field,
    count(*) as n_records

from "dwecommerce01"."public"."Clients"
where cpf is not null
group by cpf
having count(*) > 1


