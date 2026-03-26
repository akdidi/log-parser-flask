# Image de base
FROM python:3.11-slim

# Dossier de travail
WORKDIR /app

# Copier les fichiers
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Port exposé
EXPOSE 5000

# Variables d’environnement
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Commande de lancement
CMD ["flask", "run"]