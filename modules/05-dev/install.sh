#!/bin/bash
# modules/05-dev/install.sh - Herramientas de desarrollo

source "$(dirname "$0")/../../utils/common.sh"
shell_detector

module_dev() {
    log_info "Configurando herramientas de desarrollo..."
    
    # Node.js (usando nvm)
    source_script "05-dev/nodejs-install.sh"
        
    # Extensiones de VS Code
    source_script "05-dev/vscode-extensions-install.sh"
    
    log_success "Herramientas de desarrollo configuradas"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_dev
fi
