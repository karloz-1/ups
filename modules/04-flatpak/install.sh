#!/bin/bash
# modules/04-flatpak/install.sh - Aplicaciones Flatpak

source "$(dirname "$0")/../../utils/common.sh"

module_flatpak() {
    log_info "Instalando aplicaciones Flatpak..."
    
    # Verificar si flatpak está instalado
    if ! command_exists flatpak; then
        log_info "Instalando Flatpak..."
        sudo env DEBIAN_FRONTEND=noninteractive apt install -y flatpak gnome-software-plugin-flatpak && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    fi
    
    # Añadir flatpaks aquí
    local flatpaks=(
        org.vinegarhq.Sober
        com.discordapp.Discord
        org.onlyoffice.desktopeditors
    )
    
    for app in "${flatpaks[@]}"; do
        if is_flatpak_installed "$app"; then
            log_warn "$app ya está instalado"
        else
            log_info "Instalando $app..."
            flatpak install -y flathub "$app"
            log_success "$app instalado"
        fi
    done
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_flatpak
fi
