#!/bin/bash

fontsDir="$HOME/.local/share/fonts"
fontFile="$fontsDir/JetBrainsMonoNerdFont-Regular.ttf"

if [ ! -d "$fontsDir" ]; then
    mkdir -p "$fontsDir"
fi

if [ ! -f "$fontFile" ]; then
    tmpfile="/tmp/JetBrainsMono.zip"

    if ! command_exists curl; then
        log_info "Instalando dependencia: curl"
        sudo DEBIAN_FRONTEND=noninteractive apt install -y curl
    fi

    log_info "Descargando paquete de JetBrainsMono-NerdFont desde github.com"
    curl -fsSL -o "$tmpfile" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"

    log_info "Instalando JetBrainsMono-NerdFont"
    unzip -q "$tmpfile" -d "$fontsDir"

    log_info "Removiendo descarga temporal"
    rm -f "$tmpfile"
    sudo fc-cache -f -v
    exit 0
else
    log_warn "JetBrainsMono-NerdFont ya está instalado"
fi

