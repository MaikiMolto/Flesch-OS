#!/bin/bash
# Flesch-OS build script
# Hardware: AMD Ryzen 9 5950X + Nvidia RTX 4090
# Desktop: KDE Plasma (Bazzite KDE)

set -ouex pipefail

# ── VS Code Repo ──────────────────────────────────────────────────────────────
rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat <<EOF > /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# ── WezTerm COPR ──────────────────────────────────────────────────────────────
dnf5 -y copr enable wezfurlong/wezterm-nightly

# ── RPM Packages ──────────────────────────────────────────────────────────────
dnf5 install -y \
    wezterm \
    krusader \
    vlc \
    corectrl \
    kde-connect \
    git \
    nodejs \
    npm \
    htop \
    code

# ── COPRs wieder deaktivieren ─────────────────────────────────────────────────
dnf5 -y copr disable wezfurlong/wezterm-nightly

# ── OpenClaw CLI ──────────────────────────────────────────────────────────────
mkdir -p /opt/openclaw
npm install --prefix /opt/openclaw openclaw
ln -sf /opt/openclaw/node_modules/.bin/openclaw /usr/bin/openclaw

# ── Deutsche Lokalisierung ────────────────────────────────────────────────────
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo "LANG=de_DE.UTF-8" > /etc/locale.conf
echo "KEYMAP=de-latin1" > /etc/vconsole.conf
cat <<EOF > /etc/X11/xorg.conf.d/00-keyboard.conf
Section "InputClass"
    Identifier "keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "de"
    Option "XkbVariant" "nodeadkeys"
EndSection
EOF

# ── SSH Server aktivieren ─────────────────────────────────────────────────────
systemctl enable sshd

# ── Flatpak-Liste kopieren ────────────────────────────────────────────────────
mkdir -p /usr/share/flesch-os
cp /ctx/flatpaks.txt /usr/share/flesch-os/flatpaks.txt
