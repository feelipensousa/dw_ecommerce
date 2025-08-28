# Extract.py
from abc import ABC, abstractmethod
import pandas as pd
from pathlib import Path
import os

#Adicionar Logs.

class DataExtractor(ABC):
    """
    Classe abstrata como base para classes que irão ler dados locais.
    """


    @abstractmethod
    def extract_data(self) -> pd.DataFrame:
        pass

class CSVExtractor(DataExtractor):
    """
    Classe que irá ler arquivos csv locais.

    Args:
        file_path: str
        encoding: str = 'utf-8'
    """
    def __init__(self, file_path: str, encoding: str ='utf-8'):
        self.file_path = Path(file_path)
        self.encoding = encoding

    def extract_data(self):
        """
        Função que verifica se o caminho passado existe, se sim, retorna o df do arquivo csv lido.
        """
        if not self.file_path.exists():
            raise FileNotFoundError("Caminho não encontrado.")
        return pd.read_csv(filepath_or_buffer=self.file_path, sep=',', encoding=self.encoding)
        