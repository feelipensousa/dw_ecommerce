import pandas as pd
import random


"""
Colunas do df original

['Ad_ID', 'Campaign_Name', 'Clicks', 'Impressions', 'Cost', 'Leads',
'Conversions', 'Conversion_Rate', 'Sale_Amount', 'Ad_Date', 'Location',
'Device', 'Keyword']
"""
"""
campaign name, sales amount, location(substiutir por country ou ver se dá pra já pegar pelo id da venda), device (substituir pela plataforma), keyword 
adicionar product_id
"""
def correcting_products_metrics(product_metrics: pd.DataFrame, columns_to_remove: list, products_df) -> pd.DataFrame:
    """
    Função que corrije colunas indesejáveis para nossa análise.

    Returns:
        dict: Dataframe com colunas corrigidas.
    """
    platforms = ["Facebook Ads", "Instagram ads", "Google ads"]

    # Adicionamos pesos para que não fique 33% ou uma definida por mim a chance de aparecer as plataformas na coluna do df.
    choices_platforms_weights = [random.random() for _ in platforms]
    choices_products_weights = [random.random() for _ in range(len(products_df))]
    print("Pesos das plataformas: ", choices_platforms_weights)
    print("Pesos dos produtos: ", choices_products_weights)


    df_PM = product_metrics.drop(columns_to_remove, axis=1)
    df_PM["product_id"] = random.choices(products_df['product_id'].tolist(), weights=choices_products_weights, k=len(df_PM))
    df_PM["platform"] = random.choices(platforms, weights=choices_platforms_weights, k=len(df_PM))

    return df_PM


if __name__ == "__main__":
    columns = ['campaign_name', 'sale_amount', 'keyword', 'location']
    product_metrics = pd.read_csv("src/data/base_products_metrics.csv", sep=',', encoding='UTF-8')
    products_df = pd.read_csv("src/data/Products.csv", sep=',', encoding='UTF-8')

    product_metrics_df = correcting_products_metrics(product_metrics, columns, products_df)
    print(product_metrics_df.columns)
    print("Data mínima:", product_metrics_df['ad_date'].min())
    print("Data máxima:", product_metrics_df['ad_date'].max())
    print("quantidade média de linhas por dia")
    avg_rows_per_day = product_metrics_df.groupby('ad_date').size().mean()
    print(avg_rows_per_day)
