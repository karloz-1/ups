#!/bin/bash

# Esta función AHORA SOLO hace las carpetas y los backups (ya no ejecuta stow)
prepare_and_backup() {
    local path="$1" # .config/Code/User || vacio ""
    local file_name="$2" # settings.json
    
    # Si el path está vacío, el archivo va directo al HOME
    if [[ "$path" == "" ]]; then
        local file_path="$file_name"
        local target_dir="$HOME"
        local backup_target_dir="$BACKUP_DIR"
    else
        local file_path="$path/$file_name"
        local target_dir="$HOME/$path"
        local backup_target_dir="$BACKUP_DIR/$path"
    fi

    # Crear la carpeta de destino si no existe
    mkdir -p "$target_dir" || die "No se pudo crear la carpeta $target_dir"

    if [ -f "$HOME/$file_path" ]; then
        log_warn "El archivo ubicado en: [$HOME/$file_path] existe. Moviéndolo al backup..."
        
        if [ -L "$HOME/$file_path" ]; then
            log_warn "El archivo: [$HOME/$file_path] fue detectado como un enlace simbólico. Eliminando SIN GUARDAR BACKUP..."
            rm -f "$HOME/$file_path" || die "No se pudo eliminar el archivo $HOME/$file_path"
            log_success "[$HOME/$file_path] Eliminado correctamente"
        else
            mkdir -p "$backup_target_dir" || die "No se pudo crear la carpeta de respaldo [$backup_target_dir]"
            rm -f "$BACKUP_DIR/$file_path" || die "No se pudo eliminar el antiguo backup [$BACKUP_DIR/$file_path]"
            mv "$HOME/$file_path" "$backup_target_dir" || die "No se pudo mover el archivo al backup"
            log_success "El archivo ha sido correctamente respaldado en: [$BACKUP_DIR/$file_path]"
        fi
    fi
}

# ==========================================
# 1. Zshrc
# ==========================================
prepare_and_backup "" ".zshrc"
log_info "Enlazando paquete: [zsh]"
stow --target="$HOME" "zsh" || die "Fallo al enlazar zsh"
log_success "[.zshrc] correctamente enlazado"

# ==========================================
# 2. Vscode settings file
# ==========================================
prepare_and_backup ".config/Code/User" "settings.json"
log_info "Enlazando paquete: [vscode]"
stow --target="$HOME/.config/Code/User" "vscode" || die "Fallo al enlazar vscode"
log_success "[settings.json] de vscode correctamente enlazado"

# ==========================================
# 3. DuxShell
# ==========================================
duxshell_config_files=(
    firefox.css
    plugin_settings.json
    plugins.lock.json
    settings.json
)

# preparar y limpiar todos los archivos individuales
for file in "${duxshell_config_files[@]}"; do
    prepare_and_backup ".config/dms" "$file"
done

log_info "Enlazando paquete: [duxshell]"
stow --target="$HOME/.config/dms" "duxshell" || die "Fallo al enlazar duxshell"
log_success "Todos los archivos de [duxshell] fueron correctamente enlazados en [$HOME/.config/dms]"

# ==========================================
# 4. Kitty
# ==========================================
prepare_and_backup ".config/kitty" "kitty.conf"
log_info "Enlazando paquete: [kitty]"
stow --target="$HOME/.config/kitty" "kitty" || die "Fallo al enlazar kitty"
log_success "[kitty.conf] correctamente enlazado"

# ==========================================
# 5. Niri
# ==========================================
prepare_and_backup ".config/niri" "config.kdl"
prepare_and_backup ".config/niri/dms" "binds.kdl"
log_info "Enlazando paquete: [niri]"
stow --target="$HOME/.config/niri" "niri" || die "Fallo al enlazar niri"
log_success "Todos los archivos de [niri] fueron correctamente enlazados en [$HOME/.config/niri]"