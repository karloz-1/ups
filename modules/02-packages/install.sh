#!/bin/bash
# modules/02-packages/install.sh - Paquetes del sistema

source "$(dirname "$0")/../../utils/common.sh"

module_packages() {
    log_info "Instalando paquetes del sistema..."
    
    # Añadir paquetes aquí
    local packages=(
        curl
        git
        fastfetch
        wget
        blueman
        vlc
        eza
        zoxide
        lazygit
        zsh
        starship
        tree
        bat
        stow
        obs-studio
        ttf-mscorefonts-installer
    )
    
    for pkg in "${packages[@]}"; do
        if is_installed "$pkg"; then
            log_warn "$pkg ya está instalado"
        else
            log_info "Instalando $pkg..."
            sudo apt install -y -qq "$pkg"
            log_success "$pkg instalado"
        fi
    done

    # Instalar la fuente JetBrainsMono Nerd Font
    source_script "02-packages/jetbrains-mono-nerd-font-install.sh"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_packages
fi
