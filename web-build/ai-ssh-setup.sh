#!/bin/bash
KEY_DIR="/var/www/html/.ddev/.agent-ssh-keys"
KEY="$KEY_DIR/id_ed25519.pub"
# Generate keys if missing (fresh clone without reinstalling add-ons)
if [ ! -f "$KEY_DIR/id_ed25519" ]; then
    mkdir -p "$KEY_DIR"
    ssh-keygen -t ed25519 -f "$KEY_DIR/id_ed25519" -N "" -C "ddev-agent" 2>/dev/null
    chmod 600 "$KEY_DIR/id_ed25519"
    chmod 644 "$KEY_DIR/id_ed25519.pub"
fi
# Set up authorized_keys for the current user
mkdir -p ~/.ssh
if [ -f "$KEY" ]; then
    cp "$KEY" ~/.ssh/authorized_keys
    chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
fi
# Write username so AI containers know which user to SSH as
echo "$(whoami)" > "$KEY_DIR/web-user"
# Unlock user account (sshd rejects locked accounts even with key auth)
sudo passwd -d "$(whoami)" 2>/dev/null
# Fix /run/sshd ownership (sshd requires root ownership)
sudo chown root:root /run/sshd 2>/dev/null
sudo chmod 755 /run/sshd 2>/dev/null
# Save env vars for SSH sessions
printenv | grep -E "^(DDEV_|IS_DDEV_PROJECT|PATH=)" | sed "s/^/export /" | sudo tee /etc/ddev-env > /dev/null
sudo chmod 644 /etc/ddev-env
# Start sshd (needs root)
exec sudo /usr/sbin/sshd -D -e
