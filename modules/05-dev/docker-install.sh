#!/bin/bash

if ! command_exists docker; then
    log_info "Instalando Docker..."

    # Add Docker's official GPG key:
    sudo apt update
    sudo apt install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    sudo apt update || die "No se pudieron actualizar los repositorios de APT."

    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || die "No se pudieron instalar todos los paquetes"

    if [ -d /run/systemd/system ]; then
        if ! sudo systemctl is-active --quiet docker; then
            log_warn "Docker no está activo. Iniciándolo..."
            sudo systemctl start docker || die "No se pudo iniciar docker"
            log_success "Docker activo"
        fi
    else
        log_warn "No se detectó systemd. Omitiendo inicio del servicio (posible entorno de contenedor)."
    fi

    # Para no poner sudo en cada comando de docker
    sudo usermod -aG docker ${USER}

    log_success "Docker instalado correctamente"
else
    log_warn "Docker ya está instalado"
fi