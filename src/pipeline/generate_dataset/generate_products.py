import pandas as pd

def generate_products(file_path: str) -> pd.DataFrame:
    """
    Geramos a lista de produtos únicos separados por categorias.

    Args:
        file_path (str): Caminho base do arquivo.

    Returns:
        Dataframe: Dataframe com os produtos. Colunas: product_id, product_name, category, unit_price.
    """
    df_product = pd.read_csv(file_path)
    df_product = df_product.drop_duplicates(subset=["Product Name"])

    product = {
        "product_id": [i for i in range(1, len(df_product) + 1)],
        "product_name": df_product["Product Name"].tolist(),
        "category": df_product["Product Category"].tolist(),
        "unit_price": df_product["Unit Price"].tolist(),
        }


    return pd.DataFrame(product)


if __name__ == "__main__":
    produtos = generate_products(file_path="src/data/base_products.csv")
    produtos.to_csv('src/data/Products.csv', index=False)
    print("Dados salvo com sucesso.")