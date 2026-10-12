#!/bin/bash
# modules/07-dots/install.sh - Configuraciones (dotfiles)

source "$(dirname "$0")/../../utils/common.sh"

module_dots() {
    log_info "Aplicando configuraciones (dotfiles)..."

    # Instalar dependencias
    if ! command_exists "stow"; then
        log_warn "Dependencias faltantes: stow"
        log_info "Instalando la dependencia: stow"

        sudo apt install -y stow

        log_success "Dependencia stow instalada"
    fi
    
    # Definir variables locales para las rutas
    local BACKUP_DIR="$HOME/.backups/dotfiles"
    local DOTS_DIR="$PROJECT_ROOT/configs"
    local HOME_CONFIG="$HOME/.config"

    mkdir -p "$BACKUP_DIR"
    mkdir -p "$BACKUP_DIR/.config"
    mkdir -p "$HOME_CONFIG"

    # ========================== Proceso de backup y enlace ================================

    cd "$DOTS_DIR" || exit 1

    # args:
    # $1 = ruta del archivo
    # $2 = nombre del paquete de stow
    # $3 = ruta donde va el archivo (carpeta)

    # Ejemplo: link_single_file "$HOME/.config/niri/config.kdl" "niri" "$HOME/.config/niri"
    link_single_file() {
        if [ -f "$1" ]; then
            log_warn "El archivo ubicado en: [$1] existe. Moviéndolo al backup..."
            
            # Si es un enlace simbolico; lo elimina sin guardar en un backup, si no lo mueve al backup
            if [ -L "$1" ]; then
                log_warn "El archivo: [$1] fue detectado como un enlace simbólico. Eliminando SIN GUARDAR BACKUP..."
                rm -f "$1" || exit 1
                log_success "[$1] Eliminado correctamente"
            else
                rm -f "$BACKUP_DIR"/$1 || exit 1
                mv "$1" "$BACKUP_DIR" || exit 1
                log_success "El archivo: [$1] ha sido correctamente respaldado en: [$BACKUP_DIR/$1]"
            fi
            
            log_info "Enlazando: [$DOTS_DIR/$2]"
            stow --target="$3" "$2" || exit 1
            log_success "[$DOTS_DIR/$2] correctamente enlazado en [$1]"
        else
            log_info "Enlazando: [$DOTS_DIR/$2]"
            stow --target="$3" "$2" || exit 1
            log_success "[$DOTS_DIR/$2] correctamente enlazado en [$1]"
        fi
    }

    # Zshrc
    link_single_file "$HOME/.zshrc" "zsh" "$HOME"

    # Vscode settings file
    link_single_file "$HOME/.config/Code/User/settings.json" "vscode" "$HOME_CONFIG"

    #========= $HOME/.config files
    local config_packages=(
        DankMaterialShell
        kitty
        niri
    )

    for config_pkg in "${config_packages[@]}"; do

        if [[ -d "$HOME_CONFIG/$config_pkg" || -L "$HOME_CONFIG/$config_pkg" ]]; then
            log_warn "La carpeta ubicada en: [$HOME_CONFIG/$config_pkg] existe. Moviéndola al backup..."

            # Eliminar la carpeta respaldada y crearla nueva mente vacia
            rm -rf "$BACKUP_DIR/.config/$config_pkg" || exit 1
            mkdir $BACKUP_DIR/.config/$config_pkg || exit 1

            # Copiar todo el contenido de la carpeta original al backup para posteriormente eliminar la carpeta original y se pueda hacer el enlace correctamente
            cp -r "$HOME_CONFIG/$config_pkg/" "$BACKUP_DIR/.config/" || exit 1
            rm -rf "$HOME_CONFIG/$config_pkg"
            log_success "La carpeta: [$HOME_CONFIG/$config_pkg] ha sido correctamente respaldada en: [$BACKUP_DIR/.config/$config_pkg]"

            # Enlazar el contenido del paquete stow en $HOME/.config/
            log_info "Enlazando: [$DOTS_DIR/$config_pkg]"
            stow --target="$HOME_CONFIG" "$config_pkg" || exit 1
            log_success "[$DOTS_DIR/$config_pkg] correctamente enlazado en [$HOME_CONFIG/$config_pkg]"
        else
            log_info "Enlazando: [$DOTS_DIR/$config_pkg]"
            stow --target="$HOME_CONFIG" "$config_pkg" || exit 1
            log_success "[$DOTS_DIR/$config_pkg] correctamente enlazado en [$HOME_CONFIG/$config_pkg]"
        fi
    done

    log_success "Configuraciones (dotfiles) aplicadas"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_dots
fi
