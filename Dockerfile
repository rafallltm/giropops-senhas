FROM cgr.dev/chainguard/python:latest-dev as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt


FROM cgr.dev/chainguard/python:latest
WORKDIR /app

COPY --from=builder /home/nonroot/.local /home/nonroot/.local
ENV PATH=$PATH:/home/nonroot/.local/bin
ENV FLASK_APP=app.py


COPY tailwind.config.js LICENSE ./
COPY static/ static/
COPY templates/ templates/
COPY app.py .

EXPOSE 5000

ENTRYPOINT ["flask", "run", "--host=0.0.0.0"]
