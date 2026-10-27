#!/bin/bash
# modules/07-dots/install.sh - Configuraciones (dotfiles)

source "$(dirname "$0")/../../utils/common.sh"

module_dots() {
    local MODULE_FOLDER_NAME="07-dots"
    log_info "Aplicando configuraciones (dotfiles)..."

    if ! command_exists dms && ! command_exists qs; then
        die "No tienes DuxShell instalado. Debes de instalarlo desde [https://duxlabs.dev/]"
    fi

    # Instalar dependencias
    install_dependencies "stow"

    # Definir variables locales para las rutas
    local BACKUP_DIR="$HOME/.backups/dotfiles"
    local DOTS_DIR="$PROJECT_ROOT/configs"
    local HOME_CONFIG="$HOME/.config"

    mkdir -p "$BACKUP_DIR" || die "No se pudo crear la carpeta $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR/.config" || die "No se pudo crear la carpeta $BACKUP_DIR/.config"
    mkdir -p "$HOME_CONFIG" || die "No se pudo crear la carpeta $HOME_CONFIG"

    # ========== Instalar plugins ==========
    source_script "$MODULE_FOLDER_NAME/duxshell-plugins-install.sh"


    # ========================== Proceso de backup y enlace ================================

    cd "$DOTS_DIR" || die "No se pudo hacer cd a la carpeta $DOTS_DIR"

    # ========= $HOME/.config files ============
    source_script "$MODULE_FOLDER_NAME/link-single-files.sh"
    # source_script "$MODULE_FOLDER_NAME/link-folders.sh"
    
    log_success "Configuraciones (dotfiles) aplicadas"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_dots
fi
