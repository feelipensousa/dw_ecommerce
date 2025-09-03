"""
KPI'S da camada gold
Tabela Sales_Metrics:
    - Qual produto está vendendo mais / podendo ter filtro separado por categoria (receita e quantidade)
    - qual categoria está vendendo mais por país
    - período do ano que mais vendeu
    - idade de cliente que mais faturou
    - categoria por idade media
    - ltv clientes
    - ticket médio (cliente)
    
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
