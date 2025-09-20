import pandas as pd
from datetime import datetime, timedelta
import random


def generate_products_metrics_data(base_metrics_df: pd.DataFrame, products_df: pd.DataFrame, num_days: int) -> pd.DataFrame:
    """
    Expande e trata o DataFrame original de métricas de marketing com a geração de dados aleatórios.

    Args:
        base_metrics_df (pd.DataFrame): DataFrame base para replicação (ex: 2600 linhas).
        products_df (pd.DataFrame): DataFrame de produtos para referência.
        num_days (int): Número de dias a serem gerados.

    Returns:
        pd.DataFrame: DataFrame final de métricas de marketing.
    """

    print("Iniciando geração de dados de métricas de produtos...") # Substituir pelo log de contagem de tempo
    platforms = ["Facebook Ads", "Instagram Ads", "Google Ads", "LinkedIn Ads"]
    
    # Adicionando pesos pra não ter distribuição normal entre as plataformas e os produtos.
    choices_platforms_weights = [random.random() for _ in platforms]
    choices_products_weights = [random.random() for _ in range(len(products_df))]

    metrics_data = []
    ad_id = 0
    
    start_date = datetime(2024, 11, 30) # Data de referência

    base_metrics_cleaned = base_metrics_df.copy()
    
    # Removemos as colunas indesejadas e adicionamos as novas
    base_metrics_cleaned.drop(['campaign_name', 'sale_amount', 'keyword', 'location', 'ad_date'], axis=1, inplace=True)
    base_metrics_cleaned['product_id'] = random.choices(products_df['product_id'].tolist(), weights=choices_products_weights, k=len(base_metrics_cleaned))
    base_metrics_cleaned['platform'] = random.choices(platforms, weights=choices_platforms_weights, k=len(base_metrics_cleaned))

    for day in range(num_days): # Populamos a tabela
        current_date = start_date - timedelta(days=day)
        
        num_records_for_day = random.randint(60, 110) # Quantidade de registros por dia (60 a 110)
        daily_sample = base_metrics_cleaned.sample(n=num_records_for_day, replace=True).copy()
        
        daily_sample['ad_date'] = current_date # Corrigimos as datas da coluna 'ad_date'
        
        # Variamos as métricas a partir das existentes na tabela base (com distribuição normal)
        for col in ['clicks', 'impressions', 'leads', 'conversions']:
            daily_sample[col] = (
                daily_sample[col].astype(str).str.replace('$', '').str.replace(',', '')
            )
            daily_sample[col] = pd.to_numeric(daily_sample[col], errors='coerce')
            
        daily_sample['impressions'] = daily_sample['impressions'].apply(
            lambda x: int(max(0, x * random.gauss(1, 0.25))) if pd.notnull(x) else 0)  # ±25% de variação
        
        # Dependem de impressions para existirem
        daily_sample['clicks'] = daily_sample.apply(
            lambda row: int(max(0, row['clicks'] * random.gauss(1, 0.20))) if pd.notnull(row['clicks']) and row['clicks'] <= row['impressions'] else int(row['impressions'] * random.gauss(0.1, 0.1)) if row['impressions'] > 0 else 0, axis=1)
        daily_sample['leads'] = daily_sample.apply(
            lambda row: int(max(0, row['leads'] * random.gauss(1, 0.30))) if pd.notnull(row['leads']) and row['leads'] <= row['clicks'] else int(row['clicks'] * random.gauss(0.1, 0.1)) if row['clicks'] > 0 else 0, axis=1)
        daily_sample['conversions'] = daily_sample.apply(
            lambda row: int(max(0, row['conversions'] * random.gauss(1, 0.35))) if pd.notnull(row['conversions']) and row['conversions'] <= row['leads'] else int(row['leads'] * random.gauss(0.1, 0.1)) if row['leads'] > 0 else 0, axis=1)
        
        daily_sample['cost'] = (
            daily_sample['cost'].astype(str).str.replace('$', '').str.replace(',', ''))

        daily_sample['cost'] = pd.to_numeric(daily_sample['cost'], errors='coerce')
        daily_sample['cost'] = daily_sample['cost'].apply(
            lambda x: round(max(0, x * random.gauss(1, 0.15)), 2) if pd.notnull(x) else 0)  # ±15% de variação
        
        # Cálculo do conversion rate
        daily_sample['conversion_rate'] = daily_sample.apply(
            lambda row: round(row['conversions'] / row['clicks'], 2) if row['clicks'] > 0 else 0,
            axis=1)
        
        for _, row in daily_sample.iterrows(): # Adicionamos os Ad_IDs sequencialmente
            ad_id += 1
            row['ad_ID'] = ad_id
            metrics_data.append(row.to_dict())


    return pd.DataFrame(metrics_data)


if __name__ == "__main__":

    # Base de dados original e a necessária para a foreign key
    product_metrics_base_df = pd.read_csv("src/data/base_products_metrics.csv", sep=',', encoding='UTF-8')
    products_df = pd.read_csv("src/data/Products.csv", sep=',', encoding='UTF-8')

    products_metrics_df = generate_products_metrics_data(product_metrics_base_df, products_df, num_days=1000)

    products_metrics_df.to_csv("src/data/Products_Metrics.csv", index=False)
    
    print("Geração do DataFrame Products_Metrics concluída.")
    # print(f"Total de registros gerados: {len(products_metrics_df)}")
    # print(f"Data mínima: {products_metrics_df['ad_date'].min()}")
    # print(f"Data máxima: {products_metrics_df['ad_date'].max()}")
    # print("Colunas:", products_metrics_df.columns.tolist())
