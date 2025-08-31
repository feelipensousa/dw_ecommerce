import pandas as pd
from datetime import datetime, timedelta
from faker import Faker
import random

def generate_fake_order_data(order_id, date, product, product_id, client_id):
    """
    Geração de dados fictícios de vendas como Id do pedido, Quantitdade, Data do pedido, País em que foi pedido, id do produto e id do cliente.

    Returns:
        dict: Dicionário com os dados fictícios gerados. Chaves: order_id, quantity, order_date, order_country, product_id e client_id
    """

    countries = [
            'United Kingdom', 'France', 'Australia', 'Netherlands', 'Germany', 'Norway',
            'EIRE', 'Switzerland', 'Spain', 'Poland', 'Portugal', 'Italy', 'Belgium',
            'Lithuania', 'Japan', 'Iceland', 'Channel Islands', 'Denmark', 'Cyprus',
            'Sweden', 'Austria', 'Israel', 'Finland', 'Bahrain', 'Greece', 'Hong Kong',
            'Singapore', 'Lebanon', 'United Arab Emirates', 'Saudi Arabia',
            'Czech Republic', 'Canada', 'Unspecified', 'Brazil', 'USA',
            'European Community', 'Malta', 'RSA'
            ]
    orders = {
        "order_id": order_id,
        "quantity": random.randint(1,10),
        "order_date": date,
        "order_country": random.choice(countries),
        "product": product,
        "product_id": product_id,
        "client_id": client_id
        }
    
    return orders


if __name__ == "__main__":

    # base de dados para as foreign keys
    products_df = pd.read_csv('src/data/Products.csv', sep=',', encoding='utf-8')
    client_df = pd.read_csv('src/data/Clients.csv', sep=',', encoding='utf-8')

    sales = []

    start_date = datetime(2022, 1, 1) # As vendas começaram a partir do dia 01/01/2022
    num_days = 1000 # Quantidade de dias de pedidos

    order_id = 0


    for day in range(num_days): #
        date = start_date + timedelta(days=day)
        num_orders = random.randint(250, 550) # Quantidade de pedidos no dia

        for i in range(num_orders):
            order_id += 1
            product_id = random.choice(products_df['product_id'].tolist())  # Pega um produto aleatório de todos os produtos
            client_id = random.choice(client_df['client_id'].tolist())  # Pega um client_id aleatório de todos os clientes
            product = products_df[products_df['product_id'] == product_id].iloc[0]['product_name']

            order = generate_fake_order_data(order_id, date, product, product_id, client_id)

            sales.append(order)
    
    sales_df = pd.DataFrame(sales)
    sales_df.to_csv('src/data/Sales_data.csv', index=False)

    print("Dados salvos com sucesso.")
    #Log para dizer o tempo de execução
       