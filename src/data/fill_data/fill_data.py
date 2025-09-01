"""
Criar uma tabela clients e uma tabela products e sales_data

adicionar um FK de products nas duas tabelas e de clients na tabela sales.

trocar o nome das colunas de ambas as tabelas já prontas.

popular o location de products_metrics a partir de country de sales_data

Adicionar plataforma de ads (google, facebook, instagram) na tabela products_metrics

adicionar cpf na tabela clients
"""

#CHAT GPT
# import pandas as pd
# import random
# import numpy as np


# """
# Colunas do df original:
# ['Ad_ID', 'Campaign_Name', 'Clicks', 'Impressions', 'Cost', 'Leads',
#  'Conversions', 'Conversion_Rate', 'Sale_Amount', 'Ad_Date', 'Location',
#  'Device', 'Keyword']
# """

# def correcting_products_metrics(product_metrics: pd.DataFrame, columns_to_remove: list, products_df) -> pd.DataFrame:
#     """
#     Corrige colunas, adiciona platform e product_id.
#     """

#     platforms = ["Facebook Ads", "Instagram Ads", "Google Ads"]

#     # Pesos para escolha das plataformas e produtos
#     choices_platforms_weights = [random.random() for _ in platforms]
#     choices_products_weights = [random.random() for _ in range(len(products_df))]

#     print("Pesos das plataformas: ", choices_platforms_weights)
#     print("Pesos dos produtos: ", choices_products_weights)

#     df_PM = product_metrics.drop(columns_to_remove, axis=1)

#     # Substituição de product_id e plataforma
#     df_PM["product_id"] = random.choices(products_df['product_id'].tolist(),
#                                          weights=choices_products_weights,
#                                          k=len(df_PM))
#     df_PM["platform"] = random.choices(platforms,
#                                        weights=choices_platforms_weights,
#                                        k=len(df_PM))

#     return df_PM


# def expand_to_1000_days(df_PM: pd.DataFrame, start_date="2024-11-30", num_days=1000) -> pd.DataFrame:
#     """
#     Expande o dataframe para cobrir 1000 dias.
#     Mantém os valores originais como base, replicando com pequenas variações.
#     """

#     # Criar range de datas decrescente
#     dates = pd.date_range(end=pd.to_datetime(start_date), periods=num_days)

#     expanded_data = []
#     rng = np.random.default_rng(seed=42)  # aleatoriedade controlada para repetibilidade

#     for date in dates:
#         # Número de registros no mês (60 a 110)
#         num_records = rng.integers(60, 111)

#         # Amostra de registros originais
#         sampled = df_PM.sample(n=min(num_records, len(df_PM)), replace=True).copy()

#         # Aplicar variação nas métricas
#         for col in ["clicks", "impressions", "conversions"]:
#             if col in sampled.columns:
#                 sampled[col] = (sampled[col] * rng.uniform(0.9, 1.1, size=len(sampled))).astype(int)

#         # Atualizar data
#         sampled["ad_date"] = date

#         expanded_data.append(sampled)

#     df_expanded = pd.concat(expanded_data, ignore_index=True)
#     return df_expanded


# if __name__ == "__main__":
#     columns = ['campaign_name', 'sale_amount', 'keyword', 'location']
#     product_metrics = pd.read_csv("src/data/base_products_metrics.csv", sep=',', encoding='UTF-8')
#     products_df = pd.read_csv("src/data/Products.csv", sep=',', encoding='UTF-8')

#     # Corrigir df original
#     product_metrics_df = correcting_products_metrics(product_metrics, columns, products_df)

#     # Expandir para 1000 dias
#     expanded_df = expand_to_1000_days(product_metrics_df, start_date="2024-11-30", num_days=1000)

#     print(expanded_df.columns)
#     print("Data mínima:", expanded_df['ad_date'].min())
#     print("Data máxima:", expanded_df['ad_date'].max())
#     print("Total de linhas:", len(expanded_df))

#     expanded_df.to_csv("src/data/product_metrics_expanded.csv", index=False, encoding="UTF-8")


# GEMINI
import pandas as pd
from datetime import datetime, timedelta
import random

def generate_products_metrics_data(base_metrics_df: pd.DataFrame, products_df: pd.DataFrame, num_days: int) -> pd.DataFrame:
    """
    Gera um DataFrame de métricas de marketing replicando e variando dados de uma base.

    Args:
        base_metrics_df (pd.DataFrame): DataFrame base para replicação (ex: 2600 linhas).
        products_df (pd.DataFrame): DataFrame de produtos para referência.
        num_days (int): Número de dias a serem gerados.

    Returns:
        pd.DataFrame: DataFrame final de métricas de marketing.
    """
    platforms = ["Facebook Ads", "Instagram Ads", "Google Ads", "LinkedIn Ads"]
    
    # Adicionamos pesos para que as plataformas não tenham a mesma chance de aparecer
    choices_platforms_weights = [random.random() for _ in platforms]
    
    # Pesos para os produtos
    choices_products_weights = [random.random() for _ in range(len(products_df))]

    metrics_data = []
    ad_id = 0
    
    start_date = datetime(2024, 11, 30)

    # Prepara a base de dados para a replicação
    base_metrics_cleaned = base_metrics_df.copy()
    
    # Remove as colunas indesejadas e adiciona as novas
    base_metrics_cleaned.drop(['Campaign_Name', 'Sale_Amount', 'Keyword', 'Location', 'Ad_Date', 'Device'], axis=1, inplace=True)
    base_metrics_cleaned['product_id'] = random.choices(products_df['product_id'].tolist(), weights=choices_products_weights, k=len(base_metrics_cleaned))
    base_metrics_cleaned['platform'] = random.choices(platforms, weights=choices_platforms_weights, k=len(base_metrics_cleaned))

    for day in range(num_days):
        current_date = start_date - timedelta(days=day)
        
        # Define um intervalo de registros por dia (60 a 110)
        num_records_for_day = random.randint(60, 110)
        
        # Seleciona uma amostra aleatória da base para este dia
        daily_sample = base_metrics_cleaned.sample(n=num_records_for_day, replace=True).copy()
        
        # Adiciona a data correta para a amostra do dia
        daily_sample['Ad_Date'] = current_date
        
        # Aplica a variação aleatória às métricas
        for col in ['Clicks', 'Impressions', 'Leads', 'Conversions', 'Cost']:
            daily_sample[col] = daily_sample[col].apply(lambda x: x * random.uniform(0.9, 1.1))
            daily_sample[col] = daily_sample[col].astype(int) # Converte para inteiro após o cálculo
        
        # Recalcula a taxa de conversão
        daily_sample['Conversion_Rate'] = daily_sample.apply(
            lambda row: round(row['Conversions'] / row['Clicks'], 2) if row['Clicks'] > 0 else 0, axis=1
        )
        
        # Adiciona os Ad_IDs sequencialmente
        for _, row in daily_sample.iterrows():
            ad_id += 1
            row['Ad_ID'] = ad_id
            metrics_data.append(row.to_dict())


    return pd.DataFrame(metrics_data)


if __name__ == "__main__":
    columns = ['campaign_name', 'sale_amount', 'keyword', 'location']
    
    # Carregue a base de dados original
    product_metrics_base_df = pd.read_csv("src/data/base_products_metrics.csv", sep=',', encoding='UTF-8')
    products_df = pd.read_csv("src/data/Products.csv", sep=',', encoding='UTF-8')

    # Gere o novo DataFrame de métricas
    products_metrics_df = generate_products_metrics_data(product_metrics_base_df, products_df, num_days=1000)

    # Salve o resultado final
    products_metrics_df.to_csv("src/data/Products_Metrics.csv", index=False)
    
    print("Geração do DataFrame Products_Metrics concluída.")
    print(f"Total de registros gerados: {len(products_metrics_df)}")
    print(f"Data mínima: {products_metrics_df['Ad_Date'].min()}")
    print(f"Data máxima: {products_metrics_df['Ad_Date'].max()}")
    print("Colunas:", products_metrics_df.columns.tolist())
