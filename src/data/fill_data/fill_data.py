"""
# KPI'S da camada gold

Lógica de execução:
Tabelas:
    sales_data views:
[v]    1) rankear produtos que mais venderam (quantidade e receita) por categoria
[x]    2) rankear categorias que mais venderam por país (consertar deixar a maior categoria por cada país, está dando todas as categorias)
[v]    3) rankear períodos do ano que mais venderam
[v]    4) rankear faixa de idade de clientes que mais geraram receita e categorias por faixa de idade
[v]    5) calcular ltv médio por cliente
[v]    6) calcular ticket médio por cliente
[x]    7) RFM clientes -------COLOCAR PESO NOS CLIENTS PARA AVALIAR CHURNS E CONSERTAR PARÂMETROS (MÉDIA 414 DIAS)

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
[v]        - 1) maior taxa de conversão média, CPC médio, CTR médio, ROAS médio, maior impressão x taxa de conversões e ROI por plataforma.
[v]        - 2) custo total e CPA por plataforma

    
    - Idade:
[x]        - 1) maior taxa de conversão média, cpc médio, ctr médio, ROAS, teve mais impressões x taxa de conversões e ROI por idade --trocar o age por age_range
[x]        - 2) custo total e CPA por idade


    - País:
[v]        - 1) maior taxa de conversão média, cpc médio, ctr médio, ROAS, teve mais impressões x taxa de conversões e ROI por país ---- Ver qual é o país nulo.
[v]        - 2) custo total e CPA por país




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
