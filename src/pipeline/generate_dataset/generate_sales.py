import pandas as pd
from datetime import datetime, timedelta
import random


def generate_fake_order_data(order_id: int , date: datetime, product: str, product_id: int, client_id: str) -> dict:
    """
    Geração de dados fictícios de vendas como Id do pedido, Quantitdade, Data do pedido, País em que foi pedido, id do produto e id do cliente.

    Args:
        order_id (int): Id do pedido.
        date (datetime): Data de referência.
        product (str): Produto da tabela Products.
        product_id (int): Id do produto.
        client_id (int): Id do cliente.

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

    # Base de dados para as foreign keys
    products_df = pd.read_csv('src/data/Products.csv', sep=',', encoding='utf-8')
    client_df = pd.read_csv('src/data/Clients.csv', sep=',', encoding='utf-8')

    sales = []

    start_date = datetime(2024, 11, 30) # Data de referência
    num_days = 1000 # Quantidade de dias de pedidos

    order_id = 0

    choices_weights = [random.random() for _ in range(len(products_df))] # Adicionamos pesos pra aumentar a aleatoriedade dos produtos
    print("Pesos dos produtos: ", len(choices_weights)) 

    for day in range(num_days):
        date = start_date - timedelta(days=day) # Contagem regressiva de dias
        num_orders = random.randint(250, 550) # Quantidade de pedidos no dia

        for i in range(num_orders):
            order_id += 1
            product_id = random.choices(products_df['product_id'].tolist(), weights=choices_weights, k=1)[0] # Pega um produto aleatório com peso.           
            client_id = random.choice(client_df['client_id'].tolist())  # Pega um client_id aleatório de todos os clientes
            product = products_df[products_df['product_id'] == product_id].iloc[0]['product_name']

            order = generate_fake_order_data(order_id, date, product, product_id, client_id)

            sales.append(order)
    
    sales_df = pd.DataFrame(sales)
    sales_df.to_csv('src/data/Sales_data.csv', index=False)

    print("Dados salvos com sucesso.")
    #Log para dizer o tempo de execução
       