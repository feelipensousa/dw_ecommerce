# Meu primeiro projeto completo.
https://www.kaggle.com/datasets/nayakganesh007/google-ads-sales-dataset
https://www.kaggle.com/datasets/shreyanshverma27/online-sales-dataset-popular-marketplace-data


# Pipeline ETL para Análise de Vendas e Métricas de Marketing de E-commerce

## Divisão do ReadME:
1. OverView
2. Tecnologias
3. Problema e como foi executado
4. Arquitetura medalhão
5. Como clonar
6. Conclusão com resultados



## 1. OverView do Projeto

Este projeto demonstra a construção de um pipeline de dados completo, desde a geração de dados brutos até a criação de uma camada analítica robusta para um dashboard de e-commerce. O objetivo é simular um cenário de negócio real, onde dados de vendas e marketing são unificados para responder a perguntas estratégicas, como o Retorno sobre o Gasto com Anúncios (ROAS), o Lifetime Value (LTV) dos clientes e a performance de produtos e campanhas.



## Tecnologias Utilizadas

O projeto utiliza uma pilha moderna e modular, seguindo as melhores práticas da indústria:

* **Python**: Essencial para a geração de dados fictícios e o processo de carga (`E` e `L` do ETL). Bibliotecas como `Pandas`, `Faker` e `random` foram fundamentais para criar um dataset coerente e realista.
* **PostgreSQL**: Servindo como o **Data Warehouse**, onde os dados são armazenados e transformados.
* **dbt (data build tool)**: A ferramenta principal para a transformação dos dados (`T` do ELT). O dbt foi utilizado para criar a arquitetura Medalhão, garantindo a qualidade, a documentação e a correta correlação dos dados.
* **Docker**: Para encapsular o ambiente do banco de dados e garantir a **reprodutibilidade** do projeto.
* **Power BI/Looker Studio**: A ferramenta de Business Intelligence para a visualização final dos **KPIs** e insights.


## Arquitetura Medalhão

O projeto segue a arquitetura de dados Medalhão, com os dados fluindo por três camadas principais:

* **Bronze (`Raw`)**: A camada de dados brutos. As bases de dados originais (`base_products_metrics.csv` e `base_products.csv`) são a fonte de dados.
* **Silver (`Cleaned`)**: A camada onde os dados são limpos, padronizados e estruturados. Nesta etapa, os scripts em Python geraram uma base de dados coerente para clientes, produtos, vendas e métricas.
* **Gold (`Business-Ready`)**: A camada final, otimizada para análise e consumo por ferramentas de BI. As tabelas aqui contêm os KPIs e as métricas de negócio agregadas.



## Base de Dados e Modelagem

As tabelas do projeto foram modeladas para um **Data Warehouse**, seguindo o padrão Star Schema, com chaves primárias e estrangeiras bem definidas.

**Tabelas Criadas na Camada Silver:**

* **Table `Clients`**
    ```
    client_id integer [primary key], first_name varchar, last_name varchar, cpf varchar, email varchar unique, age integer, country varchar
    ```
* **Table `Products`**
    ```
    product_id integer [primary key], product_name varchar(255), category varchar(100), unit_price decimal(10,2)
    ```
* **Table `Sales_Data`**
    ```
    order_id integer [primary key], quantity integer, order_date datetime, order_country varchar(100), product varchar, product_id integer, client_id integer
    ```
* **Table `Products_Metrics`**
    ```
    ad_ID integer [primary key], clicks integer, impressions integer, cost decimal(10,2), leads integer, conversions integer, conversion_rate float, ad_date datetime, Device varchar, product_id integer, platform varchar, cpc float, ctr float, cpa float
    ```

**Relacionamentos (`dbt sources`):**

* `Products.product_id` < `Sales_Data.product_id`
* `Clients.client_id` < `Sales_Data.client_id`
* `Products.product_id` < `Products_Metrics.product_id`



## Execução do Projeto

O projeto é totalmente reprodutível. A base de dados é gerada a partir dos scripts em Python localmente e carregada no PostgreSQL.

**Datasets base utilizados:**
* **base\_products\_metrics.csv**: [https://www.kaggle.com/datasets/nayakganesh007/google-ads-sales-dataset](https://www.kaggle.com/datasets/nayakganesh007/google-ads-sales-dataset)
* **base\_products.csv**: [https://www.kaggle.com/datasets/shreyanshverma27/online-sales-dataset-popular-marketplace-data](https://www.kaggle.com/datasets/shreyanshverma27/online-sales-dataset-popular-marketplace-data)

**Scripts para Geração da Base de Dados:**
* `src/generate_dataset/generate_clients.py`
* `src/generate_dataset/generate_products_metrics.py`
* `src/generate_dataset/generate_products.py`
* `src/generate_dataset/generate_sales.py`
* `src/load/db_loader.py` (Script para carregar os dados no PostgreSQL)


## Principais KPIs e Análises (Camada Gold)

A camada `gold` foi projetada com views e tabelas agregadas para responder a perguntas de negócio:

* **Análise de Vendas:**
    * Rank de produtos e categorias por receita e quantidade vendida.
    * Desempenho de vendas por período do ano.
    * **LTV** médio por cliente e **Ticket Médio**.
    * **RFM** para segmentação de clientes e análise de `churn`.

* **Análise de Marketing (por Plataforma, Idade e País):**
    * **Performance do Funil**: `CTR`, `CPC` e `CPA`.
    * **Retorno sobre o Investimento**: `ROAS` e `ROI` por plataforma/país/idade.
    * **Eficiência**: Qual plataforma/país/idade mais converteu e teve mais impressões por taxa de conversão.
    * **Custo**: Análise do custo total e CPA por cada dimensão.


## Conclusão e Próximos Passos

O projeto demonstra a habilidade de construir um pipeline de dados robusto e funcional, focando em qualidade, organização e valor de negócio. Os próximos passos incluem a execução final do `dbt` e a conexão do `Power BI` para a criação do dashboard.