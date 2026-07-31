#!/bin/bash
# modules/03-software/install.sh - Software manual (no repos oficiales)

source "$(dirname "$0")/../../utils/common.sh"
shell_detector

module_software() {
    log_info "Instalando software manual..."
    
    # Añadir software que no está en repos oficiales
    
    # VS Code
    source_script "03-software/vscode-install.sh"

    # Typst
    source_script "03-software/typst-install.sh"
    
    log_success "Software manual instalado"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_software
fi
