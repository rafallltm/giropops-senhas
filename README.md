# Giropops-Senhas

## Dockerfile

1. **Clone o repositório:**
    ```sh
    git clone -b rtm https://github.com/rafallltm/giropops-senhas.git
    ```

2. **Entre no diretório:**
    ```sh
    cd giropops-senhas
    ```

3. **Construa a imagem Docker:**
    ```sh
    docker build -t nome-da-sua-imagem:tag .
    ```

4. **Inicie um container Redis:**
    ```sh
    docker container run -d -p 6000:6379 --name seu-container-redis redis:alpine3.19
    ```

5. **Inicie um container com a imagem construída:**
    ```sh
    docker run -d --name seu-container-app -p 5000:5000 --env REDIS_HOST=ip-do-redis nome-da-imagem:tag
    ```

6. **Acesse a aplicação em:**
    ```
    http://localhost:5000
    ```

## Docker-compose

1. **Inicie os serviços usando Docker Compose:**
    ```sh
    docker compose up -d
    ```

2. **Acesse a aplicação em:**
    ```
    http://localhost:5000
    ```

## Local Ubuntu

1. **Torne o script instalável e execute-o:**
    ```sh
    chmod +x install.sh
    ./install.sh
    ```
OU

1. **Clone o repositório:**
    ```sh
    git clone -b dev https://github.com/rafallltm/giropops-senhas.git
    ```

2. **Entre no diretório:**
    ```sh
    cd giropops-senhas
    ```

3. **Verifique se Python3 e pip estão instalados:**
    ```sh
    python3 --version && pip --version
    ```

4. **Para instalar Python3 e pip, caso não estejam instalados:**
    ```sh
    sudo apt update && sudo apt upgrade -y && sudo apt install python3 python3-pip
    ```

5. **Instale o Python venv:**
    ```sh
    sudo apt install python3-venv
    ```

6. **Crie um ambiente virtual Python:**
    ```sh
    python3 -m venv my-env
    ```

7. **Ative o ambiente virtual:**
    ```sh
    source my-env/bin/activate
    ```

8. **Instale todas as dependências da aplicação:**
    ```sh
    pip install --no-cache-dir -r requirements.txt
    ```

9. **Instale o Redis utilizado na aplicação:**
    ```sh
    sudo apt-get install redis -y
    ```

10. **Inicie o Redis:**
    ```sh
    sudo systemctl start redis
    ```

11. **Crie a variável de ambiente para o Redis:**
    ```sh
    export REDIS_HOST=localhost
    ```

12. **Inicie a aplicação:**
    ```sh
    flask run --host=0.0.0.0
    ```

## K8S-Minikube

1. **Aplique a configuração do Kubernetes:**
    ```sh
    kubectl apply -f deployment.yaml
    ```

2. **Obtenha o IP do Minikube:**
    ```sh
    minikube ip
    ```

3. **Acesse a aplicação:**
    ```
    http://<minikube-ip>:30080
    ```

