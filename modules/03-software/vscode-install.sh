#!/bin/bash

if ! command_exists code; then
    tmpfile="/tmp/vscode.deb"

    if ! command_exists curl; then
        log_info "Instalando dependencia: curl"
        sudo DEBIAN_FRONTEND=noninteractive apt install -y curl
    fi

    log_info "Descargando paquete de Vscode desde microsoft.com"
    curl -fsSL -o "$tmpfile" \
        "https://go.microsoft.com/fwlink/?LinkID=760868"

    log_info "Instalando Vscode"
    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq "$tmpfile"

    log_info "Removiendo descarga temporal"
    rm -f "$tmpfile"
fi