#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
   echo "Run this script as your normal user, not as root. It will elevate privileges when needed."
   exit 1
fi

# --- 0. Ensure Current User Has Sudo Privileges ---
ensure_sudo() {
    local current_user
    current_user=$(whoami)

    if id -nG "$current_user" | grep -qw "sudo"; then
        return 0
    fi

    echo ">>> User '$current_user' is not in the sudo group."
    echo ">>> Enter the ROOT password to install sudo and add '$current_user' to the sudo group:"
    su -c "apt-get update && apt-get install -y sudo && usermod -aG sudo '$current_user'"

    echo ">>> Sudo configured! Restarting script with active sudo group..."
    exec sg sudo "$0 $*"
}

ensure_sudo "$@"

LOG_FILE="$HOME/post_install_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

source /etc/os-release
echo ">>> Starting post-install setup for $PRETTY_NAME..."
sudo -v

# --- 1. System Update & Core CLI Tools ---
setup_base_system() {
    echo ">>> Updating APT and installing core utilities..."
    sudo apt update && sudo apt full-upgrade -y
    
    local cli_tools=(
        curl wget git build-essential ca-certificates gnupg
        htop btop tmux unzip zip p7zip-full tree jq ripgrep fzf
        net-tools ufw gufw
    )
    sudo apt install -y "${cli_tools[@]}"
    sudo apt autoremove -y
}

# --- 2. Gaming & Hardware Dependencies ---
setup_gaming_deps() {
    echo ">>> Enabling 32-bit architecture and installing gaming libraries..."
    sudo dpkg --add-architecture i386
    sudo apt update

    local gaming_pkgs=(
        gamemode
        mangohud
        vulkan-tools
        mesa-vulkan-drivers
        mesa-vulkan-drivers:i386
        libgl1-mesa-dri:i386
        steam-devices
    )
    sudo apt install -y "${gaming_pkgs[@]}"
}

# --- 3. Media Codecs & Hardware Video Acceleration ---
setup_codecs() {
    echo ">>> Installing multimedia codecs..."
    if [[ "$ID" == "ubuntu" || "${ID_LIKE:-}" == *"ubuntu"* ]]; then
        echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
        sudo apt install -y ubuntu-restricted-extras
    else
        sudo apt install -y libavcodec-extra va-driver-all
    fi
}

# --- 4. Flatpak & Your App Suite ---
setup_flatpaks() {
    echo ">>> Setting up Flatpak and Flathub..."
    sudo apt install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org

    if command -v gnome-software &> /dev/null; then
        sudo apt install -y gnome-software-plugin-flatpak
    elif command -v plasma-discover &> /dev/null; then
        sudo apt install -y plasma-discover-backend-flatpak
    fi

    echo ">>> Installing your Flatpak applications..."
    local flatpak_apps=(
        io.github.kolunmi.Bazaar
        org.localsend.localsend_app
        org.chromium.Chromium
        com.github.IsmaelMartinez.teams_for_linux
        com.obsproject.Studio
        org.videolan.VLC
        com.visualstudio.code
        dev.vencord.Vesktop
        com.valvesoftware.Steam
        org.prismlauncher.PrismLauncher
        io.mrarm.mcpelauncher
        org.vinegarhq.Sober
        org.vinegarhq.Vinegar
    )
    sudo flatpak install -y flathub "${flatpak_apps[@]}"
}

# --- 5. Flatpak Permissions & Gaming Tweaks ---
configure_tweaks() {
    echo ">>> Applying gaming & Flatpak permission tweaks..."
    sudo flatpak override --filesystem=/mnt com.valvesoftware.Steam
    sudo flatpak override --filesystem=/media com.valvesoftware.Steam

    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw --force enable

    if ! grep -q "vm.max_map_count" /etc/sysctl.conf; then
        echo "vm.max_map_count=2147483642" | sudo tee -a /etc/sysctl.conf
    fi
}

# --- 6. Shell Quality-of-Life Aliases ---
setup_aliases() {
    echo ">>> Adding convenience aliases to ~/.bashrc..."
    if ! grep -q "# Post-Install Aliases" "$HOME/.bashrc"; then
        cat << 'EOF' >> "$HOME/.bashrc"

# Post-Install Aliases
alias update-all='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && flatpak update -y'
alias ll='ls -alF'
EOF
    fi
}

# --- Run Modules ---
setup_base_system
setup_gaming_deps
setup_codecs
setup_flatpaks
configure_tweaks
setup_aliases

echo ">>> All done! Log saved to $LOG_FILE."
echo ">>> Please reboot your system so group permissions, Flatpak paths, and kernel tweaks take effect."
