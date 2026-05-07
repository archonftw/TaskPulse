#!/bin/bash

SERVICE_NAME="autodown"
PROJECT_DIR="/home/archon/Desktop/Github-Projects/TaskPulse/autoDown"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

echo "[+] Creating systemd service..."

sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=TaskPulse AutoDown Service
After=network.target

[Service]
ExecStart=/usr/bin/node $PROJECT_DIR/service.js
WorkingDirectory=$PROJECT_DIR
Restart=always
RestartSec=5
User=archon
Environment=NODE_ENV=production

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

echo "[+] Reloading systemd..."
sudo systemctl daemon-reload

echo "[+] Enabling service..."
sudo systemctl enable $SERVICE_NAME

echo "[+] Starting service..."
sudo systemctl start $SERVICE_NAME

echo "[+] Service status:"
sudo systemctl status $SERVICE_NAME --no-pager

echo ""
echo "[✓] Installation complete."
echo "[✓] Live logs:"
echo "journalctl -u $SERVICE_NAME -f"