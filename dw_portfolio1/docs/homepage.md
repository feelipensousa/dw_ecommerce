{% docs __overview__ %}

# Pipeline de Dados de E-commerce Fictício: 

### Visão Geral do Projeto

Este projeto demonstra a construção de um pipeline de dados completo e robusto, com foco em responder a perguntas estratégicas de negócio para uma empresa de e-commerce. A pipeline começa com a geração de dados fakes em Python para a criação de modelos de análise otimizados para um dashboard.

O principal objetivo é unificar dados de vendas e marketing para responder a perguntas como o Retorno sobre o Gasto com Anúncios (ROAS), o Valor Vitalício do Cliente (LTV) e a performance de campanhas.

---

### Arquitetura do Projeto

O pipeline segue a arquitetura de dados Medalhão, com os dados fluindo por três camadas principais:

- **Bronze (`Raw`)**: A camada de dados brutos. As bases de dados originais (`base_products_metrics.csv` e `base_products.csv`) são a fonte de dados.
- **Silver (`Cleaned`)**: A camada onde os dados são limpos, padronizados e estruturados. Nesta etapa, os scripts em Python geraram uma base de dados coerente para clientes, produtos, vendas e métricas.
- **Gold (`Business-Ready`)**: A camada final, otimizada para análise e consumo por ferramentas de BI. As tabelas aqui contêm os KPIs e as métricas de negócio agregadas.

---

### Base de Dados e Modelagem

As tabelas do projeto foram modeladas para um **Data Warehouse**, seguindo o padrão Star Schema, com chaves primárias e estrangeiras bem definidas.

Sendo esse relacionamento entre tabelas e diagramas melhor visto no ícone do canto direito "View Lineage Graph".

---
### Principais KPIs e Análises (Camada Gold)

A camada `gold` foi projetada com views e tabelas agregadas para responder a perguntas de negócio:

- **Análise de Vendas:**
    - Rank de produtos e categorias por receita e quantidade vendida.
    - Desempenho de vendas por período do ano.
    - **LTV** médio por cliente e **Ticket Médio**.
    - **RFM** para segmentação de clientes e análise de `churn`.

- **Análise de Marketing (por Plataforma, Idade e País):**
    - **Performance do Funil**: `CTR`, `CPC` e `CPA`.
    - **Retorno sobre o Investimento**: `ROAS` e `ROI` por plataforma/país/idade.
    - **Eficiência**: Qual plataforma/país/idade mais converteu e teve mais impressões por taxa de conversão.
    - **Custo**: Análise do custo total e CPA por cada dimensão.


---

### 7. Conclusão e Próximos Passos

O projeto demonstra a habilidade de construir um pipeline de dados robusto e funcional, focando em qualidade, organização e valor de negócio. Os próximos passos incluem a execução final do `dbt` e a conexão do `Power BI` para a criação do dashboard.

---

**Link do Repositório GitHub:**

[https://github.com/feelipensousa/dw_ecommerce](https://github.com/feelipensousa/dw_ecommerce)

{% enddocs %}