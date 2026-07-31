#!/bin/bash
# modules/01-repo/install.sh - Configurar repositorios

source "$(dirname "$0")/../../utils/common.sh"
shell_detector

module_repo() {
    log_info "Configurando repositorios..."
    
    if grep -r "deb.griffo.io" /etc/apt/sources.list.d/ &>/dev/null; then
        sudo install -d -m 0755 /etc/apt/keyrings
        curl -fsSL https://deb.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/deb.griffo.io.gpg

        echo "deb [signed-by=/etc/apt/keyrings/deb.griffo.io.gpg] https://deb.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/deb.griffo.io.list > /dev/null

    fi

    sudo apt update

    log_success "Repositorios configurados"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_repo
fi
