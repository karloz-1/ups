#!/bin/bash

if ! command_exists node; then
    log_info "Instalando NodeJs..."

    # https://nodejs.org/en/download
    # Download and install nvm:
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
    \. "$HOME/.nvm/nvm.sh"
    nvm install --lts || die "No se pudo instalar la ultima versión lts de node.js"
    nvm use --lts || die "No se pudo usar ultima version lts de node.js"

    log_success "NodeJs instalado correctamente"
else
    log_warn "NodeJS ya está instalado"
fi

