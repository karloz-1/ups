#!/bin/bash

if ! command_exists steam; then
    tmpfile="/tmp/steam.deb"

    install_dependencies "curl"

    log_info "Descargando archivo de steam desde steampowered.com"
    curl -fL -o "$tmpfile" \
        "https://cdn.akamai.steamstatic.com/client/installer/steam.deb" || \
        die "No se pudo descargar el archivo de steam desde steampowered.com"

    log_info "Instalando Steam"
    sudo DEBIAN_FRONTEND=noninteractive apt install -y "$tmpfile" || die "No se pudo instalar el archivo $tmpfile"

    log_info "Removiendo descarga temporal"
    rm -f "$tmpfile" || die "No se pudo eliminar el archivo temporal $tmpfile"

    log_success "Steam instalado"
else
    log_warn "Steam ya está instalado"
fi