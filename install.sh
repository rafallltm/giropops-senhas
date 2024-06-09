#!/bin/bash

# Função para exibir mensagens de log
log() {
    echo "[$(date +"%Y-%m-%d %T")] $1"
}

# Clone do repositório
log "Clonando o repositório..."
git clone -b rtm https://github.com/rafallltm/giropops-senhas.git
if [ $? -ne 0 ]; then
    log "Falha ao clonar o repositório."
    exit 1
fi

cd giropops-senhas || { log "Falha ao entrar no diretório do repositório."; exit 1; }

# Verificar se o Python3 e pip estão instalados
log "Verificando se o Python3 e pip estão instalados..."
if ! command -v python3 &> /dev/null; then
    log "Python3 não encontrado. Instalando Python3..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install python3 -y
    if [ $? -ne 0 ]; then
        log "Falha na instalação do Python3."
        exit 1
    fi
else
    log "Python3 já está instalado. Versão: $(python3 --version)"
fi

if ! command -v pip3 &> /dev/null; then
    log "pip3 não encontrado. Instalando pip3..."
    sudo apt install python3-pip -y
    if [ $? -ne 0 ]; then
        log "Falha na instalação do pip3."
        exit 1
    fi
else
    log "pip3 já está instalado. Versão: $(pip3 --version)"
fi

# Instalar o ambiente virtual
log "Instalando o ambiente virtual Python..."
sudo apt install python3-venv -y
if [ $? -ne 0 ]; then
    log "Falha na instalação do módulo python3-venv."
    exit 1
fi

# Criar e ativar o ambiente virtual
log "Criando e ativando o ambiente virtual..."
python3 -m venv my-env
if [ $? -ne 0 ]; then
    log "Falha na criação do ambiente virtual."
    exit 1
fi
source my-env/bin/activate

# Instalar as dependências da aplicação
log "Instalando as dependências da aplicação..."
pip install --no-cache-dir -r requirements.txt
if [ $? -ne 0 ]; then
    log "Falha na instalação das dependências."
    exit 1
fi

# Instalar o Redis
log "Instalando o Redis..."
sudo apt install redis -y
if [ $? -ne 0 ]; then
    log "Falha na instalação do Redis."
    exit 1
fi

# Iniciar o Redis
log "Iniciando o Redis..."
sudo systemctl start redis
if [ $? -ne 0 ]; then
    log "Falha ao iniciar o Redis."
    exit 1
fi

# Configurar a variável de ambiente para o Redis
log "Configurando a variável de ambiente para o Redis..."
export REDIS_HOST=localhost

# Iniciar a aplicação
log "Iniciando a aplicação..."
flask run --host=0.0.0.0
