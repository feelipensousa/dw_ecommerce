"""
Geramos a lista de produtos separados por categorias.
"""
import pandas as pd

produtos = pd.read_csv("src/data/Products.csv") #size 240 lines
produtos_1 = produtos.drop_duplicates(subset=["Product Name"])

#print(produtos_1.head())


product = {
    "product_id": [i for i in range(1, len(produtos_1) + 1)],
    "product_name": produtos_1["Product Name"].tolist(),
    "category": produtos_1["Product Category"].tolist(),
    "unit_price": produtos_1["Unit Price"].tolist(),
    }


product_df = pd.DataFrame(product)
product_df.to_csv('src/data/Products.csv', index=False)

