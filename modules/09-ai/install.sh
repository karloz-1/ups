#!/bin/bash
# modules/09-ai/install.sh - Herramientas de inteligencia artificial

source "$(dirname "$0")/../../utils/common.sh"
shell_detector

module_ai() {
    log_info "Instalando herramientas de IA..."
    
    # OpenCode
    source_script "09-ai/opencode-install.sh"
    
    log_success "Herramientas de IA configuradas"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_ai
fi
