#!/bin/bash
# modules/07-dots/install.sh - Configuraciones (dotfiles)

source "$(dirname "$0")/../../utils/common.sh"

module_dots() {
    log_info "Aplicando configuraciones (dotfiles)..."

    # Instalar dependencias
    install_dependencies "stow"
    
    # Definir variables locales para las rutas
    local BACKUP_DIR="$HOME/.backups/dotfiles"
    local DOTS_DIR="$PROJECT_ROOT/configs"
    local HOME_CONFIG="$HOME/.config"

    mkdir -p "$BACKUP_DIR" || die "No se pudo crear la carpeta $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR/.config" || die "No se pudo crear la carpeta $BACKUP_DIR/.config"
    mkdir -p "$HOME_CONFIG" || die "No se pudo crear la carpeta $HOME_CONFIG"

    # ========================== Proceso de backup y enlace ================================

    cd "$DOTS_DIR" || die "No se pudo hacer cd a la carpeta $DOTS_DIR"

    link_single_file() {
        local stow_pkg="$1" # vscode
        local path="$2" # config/Code/User || $HOME (si se pasa el argumento vacio)
        local file_name="$3" # settings.json
        local file_path="$path/$file_name" # .config/Code/User/settings.json

        # Crear la carpeta de destino si por si no existe
        mkdir -p "$HOME/$path" || die "No se pudo crear la carpeta $HOME/$path"

        if [ -f "$HOME/$file_path" ]; then
            log_warn "El archivo ubicado en: [$HOME/$file_path] existe. Moviéndolo al backup..."
            
            # Si es un enlace simbolico; lo elimina sin guardar en un backup, si no lo mueve al backup
            if [ -L "$HOME/$file_path" ]; then
                log_warn "El archivo: [$HOME/$file_path] fue detectado como un enlace simbólico. Eliminando SIN GUARDAR BACKUP..."
                rm -f "$HOME/$file_path" || die "No se pudo eliminar el archivo $HOME/$file_path"
                log_success "[$HOME/$file_path] Eliminado correctamente"
            else
                mkdir -p "$BACKUP_DIR/$path" || die "No se pudo crear la carpeta de respaldo [$BACKUP_DIR/$path]"
                rm -f "$BACKUP_DIR/$file_path" || die "No se pudo eliminar el antiguo backup [$BACKUP_DIR/$file_path]"
                mv "$HOME/$file_path" "$BACKUP_DIR/$path" || die "No se pudo mover el archivo [$HOME/$file_path] al backup ubicado en [$BACKUP_DIR/$path]"
                log_success "El archivo: [$HOME/$file_path] ha sido correctamente respaldado en: [$BACKUP_DIR/$file_path]"
            fi
        fi

        log_info "Enlazando: [$DOTS_DIR/$file_name]"
        if [[ "$path" == "" ]]; then
            stow --target="$HOME" "$stow_pkg" || die "No se pudo hacer el enlace de [$DOTS_DIR/$file_name] a [$HOME/$file_name]"
            log_success "[$DOTS_DIR/$file_name] correctamente enlazado en [$HOME/$file_name]"
        else
            stow --target="$HOME/$path" "$stow_pkg" || die "No se pudo hacer el enlace de [$DOTS_DIR/$file_name] a [$HOME/$file_path]"
            log_success "[$DOTS_DIR/$file_name] correctamente enlazado en [$HOME/$file_path]"
        fi

    }

    # Zshrc
    link_single_file "zsh" "" ".zshrc"

    # Vscode settings file
    link_single_file "vscode" ".config/Code/User" "settings.json"

    # ========= $HOME/.config files ============
    local config_packages=(
        DankMaterialShell
        kitty
        niri
    )

    for config_pkg in "${config_packages[@]}"; do

        if [[ -d "$HOME_CONFIG/$config_pkg" || -L "$HOME_CONFIG/$config_pkg" ]]; then
            log_warn "La carpeta ubicada en: [$HOME_CONFIG/$config_pkg] existe. Moviéndola al backup..."

            # Eliminar la carpeta respaldada y crearla nueva mente vacia
            rm -rf "$BACKUP_DIR/.config/$config_pkg" || die "No se pudo eliminar el antiguo backup [$BACKUP_DIR/.config/$config_pkg]"
            mkdir $BACKUP_DIR/.config/$config_pkg || die "No se pudo crear la carpeta [$BACKUP_DIR/.config/$config_pkg]"

            # Copiar todo el contenido de la carpeta original al backup para posteriormente eliminar la carpeta original y se pueda hacer el enlace correctamente
            cp -r "$HOME_CONFIG/$config_pkg/" "$BACKUP_DIR/.config/" || die "No se pudo copiar el contenido de [$HOME_CONFIG/$config_pkg/] en [$BACKUP_DIR/.config/]"
            rm -rf "$HOME_CONFIG/$config_pkg" || die "No se pudo eliminar la carpeta [$HOME_CONFIG/$config_pkg]"
            log_success "La carpeta: [$HOME_CONFIG/$config_pkg] ha sido correctamente respaldada en: [$BACKUP_DIR/.config/$config_pkg]"

            # Enlazar el contenido del paquete stow en $HOME/.config/
            log_info "Enlazando: [$DOTS_DIR/$config_pkg]"
            stow --target="$HOME_CONFIG" "$config_pkg" || die "No se pudo hacer el enlace de [$DOTS_DIR/$config_pkg] a [$HOME_CONFIG]"
            log_success "[$DOTS_DIR/$config_pkg] correctamente enlazado en [$HOME_CONFIG/$config_pkg]"
        else
            log_info "Enlazando: [$DOTS_DIR/$config_pkg]"
            stow --target="$HOME_CONFIG" "$config_pkg" || die "No se pudo hacer el enlace de [$DOTS_DIR/$config_pkg] a [$HOME_CONFIG]"
            log_success "[$DOTS_DIR/$config_pkg] correctamente enlazado en [$HOME_CONFIG/$config_pkg]"
        fi
    done

    log_success "Configuraciones (dotfiles) aplicadas"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_dots
fi
