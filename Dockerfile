FROM cgr.dev/chainguard/python:latest-dev as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt


FROM cgr.dev/chainguard/python:latest
WORKDIR /app

COPY --from=builder /home/nonroot/.local/lib/python3.13/site-packages /home/nonroot/.local/lib/python3.13/site-packages
COPY --from=builder /home/nonroot/.local/bin /home/nonroot/.local/bin

COPY tailwind.config.js LICENSE ./
COPY static/ static/
COPY templates/ templates/
COPY app.py .

ENTRYPOINT ["python", "-m", "flask", "run", "--host=0.0.0.0"]
