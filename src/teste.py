import pandas as pd

google_ads = pd.read_csv('src/data/GoogleADS.csv')
clients_data = pd.read_csv('src/data/clients_data.csv', encoding='latin-1')

print(len(clients_data))
print(len(google_ads))