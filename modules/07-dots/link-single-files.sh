#!/bin/bash

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
