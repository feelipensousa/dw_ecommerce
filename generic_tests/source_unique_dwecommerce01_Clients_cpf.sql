{{ config({"severity":"Error"}) }}
{{ test_unique(column_name="cpf", model=get_where_subquery(source('dwecommerce01', 'Clients'))) }}