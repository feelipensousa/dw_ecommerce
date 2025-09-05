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



aa

"""
