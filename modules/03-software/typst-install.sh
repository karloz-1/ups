#!/bin/bash

if ! command_exists typst; then
    tmpfile="/tmp/typst-aarch64-unknown-linux-musl.tar.xz"

    if ! command_exists curl; then
        log_info "Instalando dependencia: curl"
        sudo DEBIAN_FRONTEND=noninteractive apt install -y curl
    fi

    log_info "Descargando paquete de Typst desde github.com"
    curl -fsSL -o "$tmpfile" \
        "https://github.com/typst/typst/releases/download/v0.15.1/typst-aarch64-unknown-linux-musl.tar.xz"

    log_info "Instalando Typst"

    tar -xf "$tmpfile"
    # mkdir -p ~/.local/bin
    # if ! command_exists fish; then
    #     sudo apt install -y fish
    # else
    #     fish -c 'fish_add_path ~/.local/bin'
    # fi

    # log_info "Removiendo descarga temporal"
    # rm -f "$tmpfile"
fi