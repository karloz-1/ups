#!/bin/bash
# modules/01-repo/install.sh - Configurar repositorios

source "$(dirname "$0")/../../utils/common.sh"

module_repo() {
    log_info "Configurando repositorios..."
    
    source_script "01-repo/griffo.sh"

    sudo apt update

    log_success "Repositorios configurados"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_repo
fi
