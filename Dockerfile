FROM python:3.11-slim

# Installer outils nécessaires
RUN apt-get update && apt-get install -y \
    wget tar supervisor gnupg2 curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copier le projet
COPY requirements.txt .
COPY app.py .
COPY parser.py .
COPY templates ./templates
COPY logs ./logs
COPY prometheus.yml .
COPY supervisord.conf .

# Mettre pip à jour et installer dépendances
RUN python -m pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Installer Prometheus binaire
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.42.0/prometheus-2.42.0.linux-amd64.tar.gz \
    && tar xvf prometheus-2.42.0.linux-amd64.tar.gz \
    && mv prometheus-2.42.0.linux-amd64/prometheus /usr/local/bin/ \
    && mv prometheus-2.42.0.linux-amd64/promtool /usr/local/bin/ \
    && rm -rf prometheus-2.42.0.linux-amd64*

# Installer Grafana binaire

RUN wget https://dl.grafana.com/oss/release/grafana-10.2.4.linux-amd64.tar.gz \
    && tar -zxvf grafana-10.2.4.linux-amd64.tar.gz \
    && mv grafana-v10.2.4 grafana \
    && rm grafana-10.2.4.linux-amd64.tar.gz

# Exposer les ports
EXPOSE 5000 9090 3000

# Lancer supervisord
CMD ["/usr/bin/supervisord", "-c", "/app/supervisord.conf"]