#!/bin/bash

fontsDir="$HOME/.local/share/fonts"
fontFile="$fontsDir/JetBrainsMonoNerdFont-Regular.ttf"

if [ ! -d "$fontsDir" ]; then
    mkdir -p "$fontsDir" || die "No se pudo crear el directorio $fontsDir"
fi

if [ ! -f "$fontFile" ]; then
    tmpfile="/tmp/JetBrainsMono.zip"

    install_dependencies "curl" "unzip"

    log_info "Descargando fuentes JetBrainsMono-NerdFont desde github.com"
    curl -fL -o "$tmpfile" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip" || \
        die "No se pudo descargar la fuente de JetBrainsMono-NerdFont desde github.com"

    log_info "Instalando JetBrainsMono-NerdFont"
    unzip "$tmpfile" -d "$fontsDir" || die "No se pudo descomprimir el archivo [$tmpfile] en [$fontsDir]"

    log_info "Removiendo descarga temporal"
    rm -f "$tmpfile" || die "No se pudo eliminar el archivo temporal [$tmpfile]"
    sudo fc-cache -f -v || die "No se pudo reiniciar la cache de las fuentes"
else
    log_warn "JetBrainsMono-NerdFont ya está instalado"
fi

