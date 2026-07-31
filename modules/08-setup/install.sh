#!/bin/bash
# modules/08-setup/install.sh - Configuración final

source "$(dirname "$0")/../../utils/common.sh"
shell_detector

module_setup() {
    log_info "Configuración final..."
    
    # TODO: Añadir configuraciones finales aquí
    
    # Cambiar shell por defecto a zsh
    if command_exists zsh; then
        local current_shell=$(basename "$SHELL")
        if [[ "$current_shell" != "zsh" ]]; then
            log_info "Cambiando shell por defecto a zsh..."
            chsh -s "$(which zsh)"
            log_success "Shell cambiado a zsh"
        else
            log_warn "Zsh ya es la shell por defecto"
        fi
    fi
    
    # Crear alias en fish
    # mkdir -p ~/.config/fish/completions
    # cat >> ~/.config/fish/config.fish << 'EOF'
    # # Aliases
    # alias ls "eza --icons"
    # alias ll "eza -la --icons"
    # alias la "eza -a --icons"
    # alias cat "bat"
    # EOF
    
    # Configurar git
    # TODO: Preguntar al usuario por su nombre y email
    # git config --global user.name "Tu Nombre"
    # git config --global user.email "tu@email.com"

    sudo fc-cache -f -v
    
    log_success "Configuración final completada"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_setup
fi
