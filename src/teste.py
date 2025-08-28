import pandas as pd

google_ads = pd.read_csv('src/data/Products_Metrics.csv') #2600
clients_data = pd.read_csv('src/data/Sales_Data.csv', encoding='latin-1') #541909

#print(clients_data.head())
print(len(clients_data['Description'].unique()))
#print(google_ads.head())
#print(google_ads['Campaign_Name'].unique())