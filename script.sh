apt update && apt upgrade -y
apt install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub io.github.kolunmi.Bazaar
flatpak install -y flathub org.vinegarhq.Sober 
flatpak install -y flathub dev.vencord.Vesktop 
flatpak install -y flathub com.valvesoftware.Steam 
flatpak install -y flathub com.visualstudio.code 
flatpak install -y flathub com.obsproject.Studio 
flatpak install -y flathub org.videolan.VLC 
flatpak install -y flathub org.localsend.localsend_app
flatpak install -y flathub org.chromium.Chromium
flatpak install -y flathub org.vinegarhq.Vinegar
flatpak install -y flathub io.mrarm.mcpelauncher
flatpak install -y flathub org.prismlauncher.PrismLauncher
flatpak install -y flathub com.github.IsmaelMartinez.teams_for_linux
