"""
O que fazer no dbt:
    *camada silver*:
    tabela Clients:
        unificar nomes (first_name e last_name) em full_name
        fazer de para em country (EIRE, RSA, European Community)
    tabela Products:
    
    Tabela Sales_Data:
        fazer de para para os order_country (EIRE, RSA, European Community)
        talvez adicionar uma coluna com o total da venda (quantity * price)
    tabela Products_Metrics:
        deixar device em lowercase

"""