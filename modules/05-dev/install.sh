#!/bin/bash
# modules/05-dev/install.sh - Herramientas de desarrollo

# IMPORTANTE: Si vas a probar este script en docker, DEBES de comentar el source_script que instala las extensiones de VSCode.
# Debido a que el contenedor de docker se ejecuta como root, no nos permite ejecutar el comando "code" por seguridad.
# Pero este modulo es completamente funcional en entornos reales.

source "$(dirname "$0")/../../utils/common.sh"

module_dev() {
    log_info "Configurando herramientas de desarrollo..."

    install_dependencies "curl"
    
    # Docker
    source_script "05-dev/docker-install.sh"

    # Node.js (usando nvm)
    source_script "05-dev/nodejs-install.sh"
        
    # Cliente de APIs: Bruno
    source_script "05-dev/bruno-install.sh"

    # .NET + C#
    source_script "05-dev/dotnet-install.sh"

    # Laravel + PHP + Lampp (Xampp) + composer
    source_script "05-dev/laravel-install.sh"

    # Extensiones de VS Code
    source_script "05-dev/vscode-extensions-install.sh"
    
    log_success "Herramientas de desarrollo configuradas"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_dev
fi
