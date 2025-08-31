from faker import Faker
import random
import pandas as pd
import uuid

def generate_fake_client_data():
    """
    Geração de dados fictícios como Id único, cpf, Primeiro Nome, Sobrenome, Idade, e País.

    Returns:
        dict: Dicionário com os dados fictícios gerados. Chaves: client_id, cpf, first_name, last_name, email, age e country
    """
    client_id = str(uuid.uuid4())
    fake = Faker("pt_BR")
    cpf = fake.cpf()
    name = fake.name()
    age = random.randint(18,70)
    countries = [
        'United Kingdom', 'France', 'Australia', 'Netherlands', 'Germany', 'Norway',
        'EIRE', 'Switzerland', 'Spain', 'Poland', 'Portugal', 'Italy', 'Belgium',
        'Lithuania', 'Japan', 'Iceland', 'Channel Islands', 'Denmark', 'Cyprus',
        'Sweden', 'Austria', 'Israel', 'Finland', 'Bahrain', 'Greece', 'Hong Kong',
        'Singapore', 'Lebanon', 'United Arab Emirates', 'Saudi Arabia',
        'Czech Republic', 'Canada', 'Unspecified', 'Brazil', 'USA',
        'European Community', 'Malta', 'RSA'
    ]
    country = random.choice(countries)
    fake_data = {
        "client_id": client_id,
        "first_name": name.split(" ")[0],
        "last_name": " ".join(name.split(" ")[1:]),
        "cpf": cpf,
        "email": name.split(" ")[1] + "@" + fake.free_email_domain(),
        "age": age,
        "country": country
    }
    return fake_data

if __name__ == "__main__":
    client_data = []
    num_clients = 50000 # Geramos 50.000 clientes para nossa tabela.
    for i in range(1, num_clients + 1):
        fake_user = generate_fake_client_data()
        client_data.append(fake_user)
    
    client_df = pd.DataFrame(client_data)
    client_df.to_csv('src/data/Clients.csv', index=False)

    print("Dados salvos com sucesso.")
    #Log para dizer o tempo de execução