from locust import HttpUser, task, between
import random

class GiropopsLoadTest(HttpUser):
    wait_time = between(1, 3)  

    @task(3)
    def gerar_senha(self):
        """Envia requisição POST para gerar senha"""
        tamanho = random.randint(8, 16)  
        incluir_numeros = random.choice([True, False])
        incluir_caracteres_especiais = random.choice([True, False])

        payload = {
            "tamanho": tamanho,
            "incluir_numeros": incluir_numeros,
            "incluir_caracteres_especiais": incluir_caracteres_especiais
        }

        response = self.client.post("/api/gerar-senha", json=payload)

        if response.status_code == 200:
            senha = response.json().get("senha")
            print(f"Senha gerada: {senha}")
        else:
            print(f"Erro ao gerar senha: {response.status_code}")

    @task(1)
    def listar_senhas(self):
        """Requisição GET para obter senhas armazenadas no Redis"""
        response = self.client.get("/api/senhas")

        if response.status_code == 200:
            senhas = response.json()
            print(f"Últimas senhas armazenadas: {senhas}")
        else:
            print(f"Erro ao listar senhas: {response.status_code}")
