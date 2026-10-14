#!/bin/bash

if ! command_exists dotnet; then
    log_info "Instalando .NET + C#..."

    sudo apt update || die "No se pudieron actualizar los repositorios de APT."
    sudo apt install -y dotnet-sdk-10.0 || die "No se pudo instalar el paquete dotnet-sdk-10.0"

    log_success ".NET instalado correctamente"
else
    log_warn ".NET ya está instalado"
fi