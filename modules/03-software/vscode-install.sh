#!/bin/bash

if ! command_exists code; then
    tmpfile="/tmp/vscode.deb"

    install_dependencies "curl"

    log_info "Descargando archivo de vscode desde microsoft.com"
    curl -fL -o "$tmpfile" \
        "https://go.microsoft.com/fwlink/?LinkID=760868" || \
        die "No se pudo descargar el archivo de vscode desde microsoft.com"

    log_info "Instalando Vscode"
    sudo DEBIAN_FRONTEND=noninteractive apt install -y "$tmpfile" || die "No se pudo instalar el archivo [$tmpfile]"

    log_info "Removiendo descarga temporal"
    rm -f "$tmpfile" || die "No se pudo eliminar el archivo [$tmpfile]"
else
    log_warn "Visual Studio Code ya está instalado"
fi