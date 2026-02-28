#!/bin/bash
# Flesch-OS build script
# Hardware: AMD Ryzen 9 5950X + Nvidia RTX 4090
# Desktop: KDE Plasma (Bazzite KDE)

set -ouex pipefail

# ── RPM Packages (System-Level) ──────────────────────────────────────────────

dnf5 install -y \
    # Terminal
    wezterm \
    # Dateimanager
    krusader \
    # Media
    vlc \
    # Razer Hardware Support
    openrazer-daemon \
    polychromatic \
    # Nvidia GPU Tools
    corectrl \
    # KDE Connect (Handy ↔ PC)
    kdeconnect \
    # Dev Tools
    git \
    nodejs \
    # SSH Server
    openssh-server \
    # Gaming
    lutris \
    # System Tools
    htop \
    btop

# ── Razer udev Rules ─────────────────────────────────────────────────────────
gpasswd -a $USER plugdev 2>/dev/null || true

# ── SSH Server aktivieren ────────────────────────────────────────────────────
systemctl enable sshd

# ── VS Code (Microsoft Repo) ─────────────────────────────────────────────────
rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat <<EOF > /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
dnf5 install -y code

# ── OpenClaw CLI ─────────────────────────────────────────────────────────────
npm install -g openclaw

# ── Flatpaks werden über flatpaks.txt installiert (post-install) ─────────────
# Siehe: /usr/share/flesch-os/flatpaks.txt
mkdir -p /usr/share/flesch-os
cp /ctx/flatpaks.txt /usr/share/flesch-os/flatpaks.txt
