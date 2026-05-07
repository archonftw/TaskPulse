#!/bin/bash

set -e

SERVICE_NAME="autodown"
INSTALL_DIR="/opt/autodown"
PORT="51234"

echo "[1/6] Creating install directory..."
sudo mkdir -p $INSTALL_DIR

echo "[2/6] Creating package.json..."
cat <<EOF | sudo tee $INSTALL_DIR/package.json
{
  "name": "autodown",
  "version": "1.0.0",
  "type": "module",
  "dependencies": {
    "express": "^5.1.0"
  }
}
EOF

echo "[3/6] Creating service.js..."
cat <<EOF | sudo tee $INSTALL_DIR/service.js
import express from 'express'
import { exec } from 'child_process'

const app = express()

app.listen($PORT, () => {
    console.log("autoDown Online")
})

app.get('/shutdown', (req, res) => {

    res.send("Shutting down in 3 seconds")

    setTimeout(() => {
        exec("systemctl poweroff", (error) => {
            if (error) {
                console.log(error)
            }
        })
    }, 3000)

})
EOF

echo "[4/6] Installing dependencies..."
cd $INSTALL_DIR
sudo npm install

echo "[5/6] Creating systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=TaskPulse AutoDown Service
After=network.target

[Service]
ExecStart=/usr/bin/node $INSTALL_DIR/service.js
WorkingDirectory=$INSTALL_DIR
Restart=always
RestartSec=5
User=root
Environment=NODE_ENV=production

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

echo "[6/6] Enabling and starting service..."
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

echo ""
echo "======================================="
echo "TaskPulse AutoDown Installed!"
echo "Running on port: $PORT"
echo ""
echo "Shutdown endpoint:"
echo "http://<YOUR-IP>:$PORT/shutdown"
echo "======================================="