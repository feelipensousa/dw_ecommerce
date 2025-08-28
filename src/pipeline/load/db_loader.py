import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.exc import SQLAlchemyError
from dotenv import load_dotenv

class PostgresLoader:
    def __init__(self, user: str, password: str, host: str, port: int, database: str):
        """
        Inicializa a conexão com o banco Postgres.
        """
        self.user = user
        self.password = password
        self.host = host
        self.port = port
        self.database = database
        self.engine = self._create_engine()

    def _create_engine(self):
        try:
            engine = create_engine(
                f"postgresql+psycopg2://{self.user}:{self.password}@{self.host}:{self.port}/{self.database}"
            )
            return engine
        except SQLAlchemyError as e:
            raise ConnectionError(f"Erro ao criar engine Postgres: {e}")

    def load_csv_to_db(self, csv_path: str, table_name: str, if_exists: str = "replace"):
        """
        Carrega um CSV no Postgres.
        
        Args:
            csv_path (str): caminho do arquivo CSV.
            table_name (str): nome da tabela no Postgres.
            if_exists (str): comportamento se a tabela já existir. ('replace', 'append', 'fail')
        """
        try:
            df = pd.read_csv(csv_path)
            df.to_sql(table_name, self.engine, index=False, if_exists=if_exists)
            print(f"Arquivo '{csv_path}' carregado na tabela '{table_name}' com sucesso!")
        except FileNotFoundError:
            print(f"Arquivo CSV não encontrado: {csv_path}")
        except SQLAlchemyError as e:
            print(f"Erro ao carregar CSV no Postgres: {e}")


if __name__ == "__main__":
    load_dotenv()

    loader = PostgresLoader(
        user="seu_usuario",
        password="sua_senha",
        host="localhost",
        port=5432,
        database="seu_db"
    )

    #loader.load_csv("data/gold/clients_sales_gold.csv", "clients_sales_gold")
    #loader.load_csv("data/gold/google_ads_gold.csv", "google_ads_gold")
