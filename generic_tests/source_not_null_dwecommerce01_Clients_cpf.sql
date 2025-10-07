{{ config({"severity":"Error"}) }}
{{ test_not_null(column_name="cpf", model=get_where_subquery(source('dwecommerce01', 'Clients'))) }}