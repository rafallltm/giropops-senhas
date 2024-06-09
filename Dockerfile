FROM cgr.dev/chainguard/python:latest-dev@sha256:5727408976bf17a1f034ead1bb6f9c145b392e3ffb4246c7e557680dc345f6ff AS build

WORKDIR /app

COPY . /app

# Instalar dependências usando o usuário padrão (não-root) sem cache
RUN pip install --user --no-cache-dir -r requirements.txt




FROM cgr.dev/chainguard/python:latest@sha256:a66be254adc25216a93a381b868d8ca68c0b56f489cd9c0d50d9707b49a8a0a4

WORKDIR /app

# Copiar dependências do estágio de construção
COPY --from=build /home/nonroot/.local /home/nonroot/.local

# Copiar código-fonte do estágio de construção
COPY --from=build /app /app

# Definir o PATH para incluir pacotes instalados no diretório local do usuário
ENV PATH=/home/nonroot/.local/bin:$PATH

# Definir um usuário não-root
USER nonroot

# Iniciar o aplicativo Flask
ENTRYPOINT ["python", "-m", "flask", "run", "--host=0.0.0.0"]
