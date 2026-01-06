#!/bin/bash
set -e

echo "[INFO] Starting Node.js server..."
node /app/server.js &

# SSH keys
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
  ssh-keygen -A
fi

echo "[INFO] Starting SSH on port 2222..."
exec /usr/sbin/sshd -D -e
