"""
# KPI'S da camada gold

Lógica de execução:
Tabelas:
    sales_data views:
    1) rankear produtos que mais venderam (quantidade e receita) por categoria
    2) rankear categorias que mais venderam por país
    3) rankear períodos do ano que mais venderam
    4) rankear faixa de idade de clientes que mais geraram receita e categorias por faixa de idade
    5) calcular ltv médio por cliente
    6) calcular ticket médio por cliente
    7) RFM clientes -------COLOCAR PESO NOS CLIENTS PARA AVALIAR CHURNS

        📊 Dashboard 1 — Vendas & Produtos (foco em performance)

        Produtos mais vendidos (quantidade x receita, separados).
        Categorias por país (mapa + ranking).
        Períodos do ano mais fortes (linha/coluna para sazonalidade).
        Ticket médio por cliente.

        📊 Dashboard 2 — Clientes & Retenção (foco em comportamento)

        Receita por faixa de idade.
        Categorias preferidas por faixa etária
        LTV médio (com distribuição por cliente).
        Segmentação RFM (pizza, barras, heatmap).
        % de clientes em risco de churn.

    
    Tabela Products_Metrics:
    Tabela com calculo de ROAS e CAC
    Views:
    - Plataformma:
        - 1) produtos com maior taxa de conversão média, CPC médio, CTR médio, ROAS médio, maior impressão x taxa de conversões por plataforma
        - 3) custo total e CPA por plataforma
        - 4)  receita x custo por plataforma (ROI)

    
    - Idade:
        - produtos com maior taxa de conversão média por idade
        - maiores cpc médio, ctr médio, ROAS por idade
        - 
        - 
        - qual idade teve mais impressões x taxa de conversões

    - País:
        - produtos com maior taxa de conversão média por país
        - maiores cpc, ctr, ROAS por país
        - 
        - 
        - qual país teve mais impressões x taxa de conversões



  ad_ID 
  clicks
  impressions 
  cost 
  leads 
  conversions 
  conversion_rate 
  ad_date 
  Device 
  product_id 
  platform 
  cpc 
  ctr 


"""
