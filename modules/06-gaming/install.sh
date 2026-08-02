#!/bin/bash
# modules/06-gaming/install.sh - Gaming

source "$(dirname "$0")/../../utils/common.sh"

module_gaming() {
    log_info "Configurando gaming..."
    
    # Añadir software de gaming aquí

    # Steam
    source_script "06-gaming/steam-install.sh"
    
    log_success "Gaming configurado"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_gaming
fi
