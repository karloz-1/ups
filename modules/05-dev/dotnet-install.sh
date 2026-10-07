#!/bin/bash

if ! command_exists dotnet; then
    log_info "Instalando .NET + C#..."

    sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-10.0

    log_success ".NET instalado correctamente"
else
    log_warn ".NET ya está instalado"
fi