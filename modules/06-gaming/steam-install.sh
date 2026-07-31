#!/bin/bash

if ! command_exists steam; then
    tmpfile="/tmp/steam.deb"

    if ! command_exists curl; then
        log_info "Instalando dependencia: curl"
        sudo DEBIAN_FRONTEND=noninteractive apt install -y curl
    fi

    log_info "Descargando paquete de steam desde steampowered.com"
    curl -fsSL -o "$tmpfile" \
        "https://cdn.akamai.steamstatic.com/client/installer/steam.deb"

    log_info "Instalando Steam"
    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq "$tmpfile"

    log_info "Removiendo descarga temporal"
    rm -f "$tmpfile"
fi