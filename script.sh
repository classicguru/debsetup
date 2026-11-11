apt update && apt upgrade -y
apt install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.github.kolunmi.Bazaar
flatpak install flathub org.vinegarhq.Sober -y
flatpak install flathub dev.vencord.Vesktop -y
flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub org.videolan.VLC -y
flatpak install flathub org.localsend.localsend_app
flatpak install flathub org.chromium.Chromium
flatpak install flathub org.vinegarhq.Vinegar
flatpak install flathub io.mrarm.mcpelauncher
flatpak install flathub org.prismlauncher.PrismLauncher
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
