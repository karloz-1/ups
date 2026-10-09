#!/bin/bash

if ! grep -r "deb-free.griffo.io" /etc/apt/sources.list.d/ &>/dev/null; then
    log_info "Instalando el repositorio deb-free.griffo.io"

    sudo install -d -m 0755 /etc/apt/keyrings
    curl -fsSL https://deb-free.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/deb-free.griffo.io.gpg

    echo "deb [signed-by=/etc/apt/keyrings/deb-free.griffo.io.gpg] https://deb-free.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/deb-free.griffo.io.list > /dev/null

    log_success "Repositorio deb-free.griffo.io instalado"
fi