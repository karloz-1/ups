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
