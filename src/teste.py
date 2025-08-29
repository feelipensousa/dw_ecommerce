import pandas as pd

google_ads = pd.read_csv('src/data/Products_Metrics.csv') #2600
clients_data = pd.read_csv('src/data/Sales_Data.csv', encoding='latin-1') #541909
clients = pd.read_csv('src/data/Clients.csv') #2600

#print(clients_data.head())
#print(clients_data['Description'].unique())
#print(google_ads.head())
#print(google_ads['Location'].unique())
#print(len(clients))

# Primeira base de dados
produtos_1 = pd.read_csv("src/data/teste_data/products_1.csv") #size 240 lines
# #print(produtos_1.head())
# print(len(produtos_1['Product Category'].unique()))
# print("**********************")
# print(produtos_1['Product Category'].unique())
# print("**********************")
# print(len(produtos_1))
# print("**********************")
print(len(produtos_1['Product Name'].unique()))



# Segunda base de dados
produtos_amazon_1 = pd.read_csv("src/data/amazon_sales/produtos_amazon_1.csv") # size 9600 lines televisão 1085
produtos_amazon_2 = pd.read_csv("src/data/amazon_sales/produtos_amazon_2.csv") # size 1296 lines Sports 1216
produtos_amazon_3 = pd.read_csv("src/data/amazon_sales/produtos_amazon_3.csv") # size 9600 lines Headphones 8432
produtos_amazon_4 = pd.read_csv("src/data/amazon_sales/produtos_amazon_4.csv") # size 1104 lines Health care 1087



print(produtos_amazon_1.columns)