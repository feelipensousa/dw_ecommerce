import pandas as pd

# google_ads = pd.read_csv('src/data/Products_Metrics.csv') #2600
# clients_data = pd.read_csv('src/data/Sales_Data.csv', encoding='latin-1') #541909
# clients = pd.read_csv('src/data/Clients.csv') #2600

#print(clients_data.head())
#print(clients_data['Description'].unique())
#print(google_ads.head())
#print(google_ads['Location'].unique())
#print(len(clients))

# Primeira base de dados
#produtos_1 = pd.read_csv("src/data/teste_data/products_1.csv") #size 240 lines
# #print(produtos_1.head())
# print(len(produtos_1['Product Category'].unique()))
# print("**********************")
# print(produtos_1['Product Category'].unique())
# print("**********************")
# print(len(produtos_1))
# print("**********************")
#print(len(produtos_1['Product Name'].unique()))



# Segunda base de dados
# produtos_amazon_1 = pd.read_csv("src/data/amazon_sales/produtos_amazon_1.csv") # size 9600 lines televisão 1085
# produtos_amazon_2 = pd.read_csv("src/data/amazon_sales/produtos_amazon_2.csv") # size 1296 lines Sports 1216
# produtos_amazon_3 = pd.read_csv("src/data/amazon_sales/produtos_amazon_3.csv") # size 9600 lines Headphones 8432
# produtos_amazon_4 = pd.read_csv("src/data/amazon_sales/produtos_amazon_4.csv") # size 1104 lines Health care 1087



# print(produtos_amazon_1.columns)

Products = pd.read_csv("src/data/Products.csv", sep=',', encoding='utf-8') #232
Clients = pd.read_csv("src/data/Clients.csv", sep=',', encoding='utf-8') #50.000
Sales_data = pd.read_csv("src/data/Sales_data.csv", sep=',', encoding='utf-8') #250.000 - 550.000

# print(len(Products))
# print(len(Clients))
#print(len(Sales_data))

# print(Products.head())
# print("*"*20)
# print(Clients.head())
# print("*"*20)
# print(Sales_data.head())

import random
import pandas as pd

# 1. Defina a lista de plataformas
plataformas = ["Netflix", "Amazon Prime", "HBO Max"]

# 2. Gere pesos aleatórios para cada plataforma
# A função random.random() retorna um número de ponto flutuante entre 0.0 e 1.0.
# A lista de pesos terá a mesma quantidade de itens que a lista de plataformas.
# A soma dos pesos não precisa ser 100, pois o random.choices() usa a proporção entre eles.
pesos_aleatorios = [random.random() for _ in plataformas]

print("Pesos aleatórios gerados:", pesos_aleatorios)

# 3. Crie um DataFrame de exemplo
# Vamos criar um DataFrame com 1000 linhas para simular um conjunto de dados.
num_linhas = 1000
df = pd.DataFrame({'id': range(num_linhas)})

# 4. Use random.choices() para criar a nova coluna
# O parâmetro 'k' deve ser o número de linhas do seu DataFrame.
df['plataforma'] = random.choices(plataformas, weights=pesos_aleatorios, k=num_linhas)

# 5. Verifique a distribuição para provar que a proporção é aleatória
distribuicao = df['plataforma'].value_counts()
print("\nDistribuição das plataformas na nova coluna:")
print(distribuicao)
