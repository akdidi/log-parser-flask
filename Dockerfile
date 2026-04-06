FROM python:3.11-slim

# Installer dépendances et outils nécessaires
RUN apt-get update && apt-get install -y wget gnupg2 supervisor \
    && rm -rf /var/lib/apt/lists/*

# Installer Grafana
RUN wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - \
    && echo "deb https://packages.grafana.com/oss/deb stable main" > /etc/apt/sources.list.d/grafana.list \
    && apt-get update && apt-get install -y grafana \
    && rm -rf /var/lib/apt/lists/*

# Installer Prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.42.0/prometheus-2.42.0.linux-amd64.tar.gz \
    && tar xvf prometheus-2.42.0.linux-amd64.tar.gz \
    && mv prometheus-2.42.0.linux-amd64/prometheus /usr/local/bin/ \
    && mv prometheus-2.42.0.linux-amd64/promtool /usr/local/bin/ \
    && rm -rf prometheus-2.42.0.linux-amd64*

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de projet
COPY requirements.txt .
COPY app.py .
COPY parser.py .
COPY templates ./templates
COPY logs ./logs
COPY prometheus.yml .
COPY supervisord.conf .

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Exposer les ports
EXPOSE 5000 9090 3000

# Lancer supervisord pour démarrer Flask + Prometheus + Grafana
CMD ["/usr/bin/supervisord", "-c", "/app/supervisord.conf"]