#!/usr/bin/env bash
set -euo pipefail

### =========================
### Funktionen
### =========================
ask() {
  local var_name="$1"
  local prompt="$2"
  local result=""

  while [[ -z "$result" ]]; do
    read -rp "$prompt " result
  done
  eval "$var_name='$result'"
}

### =========================
### Eingaben abfragen
### =========================
echo "🚀 n8n Self-Hosting Setup"
echo "----------------------------------"

ask DOMAIN_NAME "🌐 Domain (z. B. example.com):"
ask SUBDOMAIN "🔗 Subdomain (z. B. n8n):"
ask SSL_EMAIL "📧 E-Mail für Let's Encrypt:"

### =========================
### Vorbereitung
### =========================
COMPOSE_DIR="$HOME/n8n-compose"

echo "📁 Erstelle Verzeichnis: $COMPOSE_DIR"
mkdir -p "$COMPOSE_DIR"
cd "$COMPOSE_DIR"

### =========================
### .env Datei
### =========================
echo "✏️ Schreibe .env Datei"

cat > .env <<EOF
DOMAIN_NAME=$DOMAIN_NAME
SUBDOMAIN=$SUBDOMAIN
SSL_EMAIL=$SSL_EMAIL
GENERIC_TIMEZONE=Europe/Berlin
EOF

### =========================
### Docker Compose Datei
### =========================
echo "📦 Erstelle docker-compose.yml"

cat > docker-compose.yml <<EOF
services:
  traefik:
    image: traefik
    restart: always
    command:
      - "--api=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.web.http.redirections.entryPoint.to=websecure"
      - "--entrypoints.web.http.redirections.entrypoint.scheme=https"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.mytlschallenge.acme.tlschallenge=true"
      - "--certificatesresolvers.mytlschallenge.acme.email=\${SSL_EMAIL}"
      - "--certificatesresolvers.mytlschallenge.acme.storage=/letsencrypt/acme.json"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - traefik_data:/letsencrypt
      - /var/run/docker.sock:/var/run/docker.sock:ro

  n8n:
    image: docker.n8n.io/n8nio/n8n
    restart: always
    ports:
      - "5678:5678"
    labels:
      - traefik.enable=true
      - traefik.http.routers.n8n.rule=Host("\${SUBDOMAIN}.\${DOMAIN_NAME}")
      - traefik.http.routers.n8n.entrypoints=websecure
      - traefik.http.routers.n8n.tls=true
      - traefik.http.routers.n8n.tls.certresolver=mytlschallenge
    environment:
      - N8N_HOST=\${SUBDOMAIN}.\${DOMAIN_NAME}
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=https://\${SUBDOMAIN}.\${DOMAIN_NAME}/
      - GENERIC_TIMEZONE=\${GENERIC_TIMEZONE}
    volumes:
      - n8n_data:/home/node/.n8n

volumes:
  n8n_data:
  traefik_data:
EOF

### =========================
### Docker starten
### =========================
echo "🚀 Starte Docker Container"
sudo docker compose up -d

### =========================
### systemd Autostart-Service
### =========================
echo "🔁 Richte Autostart bei Reboot ein"

DOCKER_PATH="$(which docker)"

sudo tee /etc/systemd/system/n8n.service > /dev/null <<EOF
[Unit]
Description=n8n Docker Compose
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$COMPOSE_DIR
ExecStart=$DOCKER_PATH compose up -d
ExecStop=$DOCKER_PATH compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable n8n.service
sudo systemctl start n8n.service

### =========================
### Abschluss
### =========================
echo "✅ Installation abgeschlossen!"
echo "🌍 n8n erreichbar unter: https://$SUBDOMAIN.$DOMAIN_NAME"
echo "🔁 Autostart bei Reboot ist aktiviert"
