"""
KPI'S da camada gold
Tabela Sales_data:
    - Qual produto está vendendo mais / podendo ter filtro separado por categoria (receita e quantidade) (1)
    - qual categoria está vendendo mais por país (2)
    - período do ano que mais vendeu (3)
    - idade de cliente que mais faturou (4)
    - categoria por idade media (5)
    - ltv clientes (6)
    - ticket médio de clientes (7)
    
Tabela Products_Metrics:
    Tabela com calculo de ROAS e CAC
    Views:
    - Plataformma:
        - produtos com maior taxa de conversão média por plataforma
        - maiores cpc, ctr, cpa por plataforma
        - maior ROAS por plataforma
        - qual plataforma mais converteu 
        - qual plataformas teve mais impressões x taxa de conversões
    
    - Idade:
        - produtos com maior taxa de conversão média por idade
        - maiores cpc, ctr, cpa por idade
        - maior ROAS por idade
        - qual idade mais converteu
        - qual idade teve mais impressões x taxa de conversões

    - País:
        - produtos com maior taxa de conversão média por país
        - maiores cpc, ctr, cpa por país
        - maior ROAS por país
        - qual país mais converteu
        - qual país teve mais impressões x taxa de conversões


Lógica de execução:
Tabelas:
    sales_data views:
    1) rankear produtos que mais venderam (quantidade e receita) por categoria
    2) rankear categorias que mais venderam por país
    3) rankear períodos do ano que mais venderam
    4) rankear faixa de idade de clientes que mais geraram receita
    5) rankear categorias por faixa de idade
    6) calcular ltv médio por cliente
    7) calcular ticket médio por cliente
    8) RFM clientes

    products_metrics



  ad_ID integer [primary key]
  clicks integer
  impressions integer
  cost decimal(10,2)
  leads integer
  conversions integer
  conversion_rate float
  ad_date datetime
  Device varchar
  product_id integer
  platform varchar
  cpc float
  ctr float
  cpa float



"""
