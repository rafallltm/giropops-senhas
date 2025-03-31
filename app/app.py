from flask import Flask, render_template, request, jsonify, Response
import redis
import string
import random
import os
from prometheus_client import Counter, start_http_server, generate_latest
from dotenv import load_dotenv
load_dotenv()  # Carrega variáveis do .env
import jinja2
print(f"[SEGURANÇA] Versão do Jinja2: {jinja2.__version__}")  # Deve mostrar 3.1.6+

app = Flask(__name__)

import os
import redis

# Configuração do Redis mais robusta
redis_host = os.environ.get('REDIS_HOST', 'localhost')
redis_port = int(os.environ.get('REDIS_PORT', 6379))
redis_password = os.environ.get('', None)  # None evita passar string vazia

r = redis.Redis(
    host=redis_host, 
    port=redis_port, 
    password=redis_password,  # Se não houver senha, None é seguro
    decode_responses=True
)


# Configuração do Flask
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'dev-secret')

senha_gerada_counter = Counter('senha_gerada', 'Contador de senhas geradas')


def criar_senha(tamanho, incluir_numeros, incluir_caracteres_especiais):
    caracteres = string.ascii_letters

    if incluir_numeros:
        caracteres += string.digits

    if incluir_caracteres_especiais:
        caracteres += string.punctuation

    senha = ''.join(random.choices(caracteres, k=tamanho))

    return senha

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        tamanho = int(request.form.get('tamanho', 8))
        incluir_numeros = request.form.get('incluir_numeros') == 'on'
        incluir_caracteres_especiais = request.form.get('incluir_caracteres_especiais') == 'on'
        senha = criar_senha(tamanho, incluir_numeros, incluir_caracteres_especiais)

        r.lpush("senhas", senha)
        senha_gerada_counter.inc()
    senhas = r.lrange("senhas", 0, 9)
    if senhas:
        senhas_geradas = [{"id": index + 1, "senha": senha} for index, senha in enumerate(senhas)]
        return render_template('index.html', senhas_geradas=senhas_geradas, senha=senhas_geradas[0]['senha'] or '' )
    return render_template('index.html')


@app.route('/api/gerar-senha', methods=['POST'])
def gerar_senha_api():
    dados = request.get_json()

    tamanho = int(dados.get('tamanho', 8))
    incluir_numeros = dados.get('incluir_numeros', False)
    incluir_caracteres_especiais = dados.get('incluir_caracteres_especiais', False)

    senha = criar_senha(tamanho, incluir_numeros, incluir_caracteres_especiais)
    r.lpush("senhas", senha)
    senha_gerada_counter.inc()

    return jsonify({"senha": senha})

@app.route('/api/senhas', methods=['GET'])
def listar_senhas():
    senhas = r.lrange("senhas", 0, 9)

    resposta = [{"id": index + 1, "senha": senha} for index, senha in enumerate(senhas)]
    return jsonify(resposta)

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), content_type='text/plain')

@app.route('/healthz')
def health_check():
    try:
        # Verifica conexão com Redis
        r.ping()
        return jsonify({
            "status": "healthy",
            "redis": "connected",
            "version": "1.0.0"
        }), 200
    except Exception as e:
        return jsonify({
            "status": "unhealthy",
            "error": str(e)
        }), 500

if __name__ == '__main__':
    if os.environ.get('FLASK_ENV') == 'production':
        from waitress import serve
        serve(app, host="0.0.0.0", port=5000)
    else:
        app.run(
            host='0.0.0.0',
            port=5000,
            debug=True,
            use_reloader=True
        )
