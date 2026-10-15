#!/bin/bash

if ! command_exists opencode; then
    log_info "Instalando opencode"

    install_dependencies "curl"
    curl -fsSL https://opencode.ai/install | bash

    log_success "Opencode correctamente instalado"
else
    log_warn "Opencode ya está instalado"
fi