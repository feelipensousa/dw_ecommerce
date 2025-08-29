import pandas as pd

google_ads = pd.read_csv('src/data/Products_Metrics.csv') #2600
clients_data = pd.read_csv('src/data/Sales_Data.csv', encoding='latin-1') #541909
clients = pd.read_csv('src/data/Clients.csv') #2600

#print(clients_data.head())
#print(clients_data['Country'].unique())
#print(google_ads.head())
#print(google_ads['Location'].unique())
print(len(clients))