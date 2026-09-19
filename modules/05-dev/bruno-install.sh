#!/bin/bash

# Agregar el repositorio de bruno
if grep -r "bruno" /etc/apt/sources.list.d/ &>/dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    sudo apt update && sudo apt install gpg curl
    curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9FA6017ECABE0266" \
    | gpg --dearmor \
    | sudo tee /etc/apt/keyrings/bruno.gpg > /dev/null
    sudo chmod 644 /etc/apt/keyrings/bruno.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/bruno.gpg] http://debian.usebruno.com/ bruno stable" \
    | sudo tee /etc/apt/sources.list.d/bruno.list
fi

# Instalar bruno
if is_installed "bruno"; then
    log_warn "bruno ya está instalado"
else
    log_info "Instalando bruno..."
    sudo apt update && sudo apt install bruno
    log_success "bruno instalado"
fi