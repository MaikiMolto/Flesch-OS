#!/bin/bash
# Flesch-OS build script
# Hardware: AMD Ryzen 9 5950X + Nvidia RTX 4090
# Desktop: KDE Plasma (Bazzite KDE)

set -ouex pipefail

# ── VS Code Repo hinzufügen ───────────────────────────────────────────────────
rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat <<EOF > /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# ── RPM Packages installieren ────────────────────────────────────────────────
dnf5 install -y \
    wezterm \
    krusader \
    vlc \
    openrazer-daemon \
    polychromatic \
    corectrl \
    kdeconnect \
    git \
    nodejs \
    openssh-server \
    lutris \
    htop \
    btop \
    code

# ── OpenClaw CLI ─────────────────────────────────────────────────────────────
npm install -g openclaw

# ── SSH Server aktivieren ────────────────────────────────────────────────────
systemctl enable sshd

# ── Flatpak-Liste für post-install kopieren ──────────────────────────────────
mkdir -p /usr/share/flesch-os
cp /ctx/flatpaks.txt /usr/share/flesch-os/flatpaks.txt
