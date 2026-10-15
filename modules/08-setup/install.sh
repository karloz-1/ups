#!/bin/bash
# modules/08-setup/install.sh - Configuración final

source "$(dirname "$0")/../../utils/common.sh"

module_setup() {
    log_info "Configuración final..."
    
    # TODO: Añadir configuraciones finales aquí
    
    # Cambiar shell por defecto a zsh
    log_info "Intentando cambiar la shell predeterminada a zsh"
    if command_exists zsh; then
        if [ -f "$HOME/.zshrc" ]; then
            local current_shell=$(basename "$SHELL")
            if [[ "$current_shell" != "zsh" ]]; then
                log_info "Cambiando shell por defecto a zsh..."
                chsh -s "$(which zsh)" || die "No se pudo cambiar la shell predeterminada a zsh"
                log_success "Shell cambiada a zsh"
            else
                log_warn "zsh ya es la shell por defecto"
            fi
        else
            log_warn "Para que la shell predeterminada sea zsh debes de tener el archivo [.zshrc] creado en [$HOME]"
        fi
    else
        log_warn "Para que la shell predeterminada sea zsh debes de tener zsh instalado"
    fi
    
    log_info "Actualizando caché de fuentes"
    sudo fc-cache -f -v || die "No se pude actualizar la cache de las fuentes"
    log_success "Caché de fuentes actualizada con exito"
    
    log_success "Configuración final completada"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_setup
fi
