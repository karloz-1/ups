#!/bin/bash

if ! command_exists opencode; then
    if ! command_exists curl; then
        log_info "Instalando dependencia: curl"
        sudo DEBIAN_FRONTEND=noninteractive apt install -y curl
    fi

    curl -fsSL https://opencode.ai/install | bash
fi