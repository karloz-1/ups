#!/bin/bash
# utils/common.sh - Funciones auxiliares para los módulos

# Directorio del proyecto (raíz)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funciones de logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si un paquete está instalado
is_installed() {
    if dpkg -l "$1" &>/dev/null; then
        return 0
    fi
    return 1
}

# Verificar si un flatpak está instalado
is_flatpak_installed() {
    if flatpak list --app | grep -qi "$1"; then
        return 0
    fi
    return 1
}

# Verificar si un comando existe
command_exists() {
    command -v "$1" &>/dev/null
}

# Carga un script de forma más sencilla
source_script() {
    source "$PROJECT_ROOT"/modules/"$1"
}

# Detecta la shell que se está utilizando en el momento.
# Si detecta que tienes zsh instalado, el script asumirá que usas zsh como shell de terminal.
shell_detector() {
    log_info "SHELL Actual = $SHELL"
    if command_exists zsh && [ -f "$HOME"/.zshrc ]; then
        if ! echo "$SHELL" | grep "zsh" &>/dev/null; then
            log_warn "El sistema asumirá que usas zsh, porque ya que tienes instalado zsh y tienes el .zshrc creado"
            log_warn "Cambiando a zsh"
            export SHELL="$(which zsh)"
            log_info "SHELL Temporal = $SHELL"
            segundos=10
            for ((i=segundos; i>0; i--)); do
                log_info "Continuando en $i segundos..."
            sleep 1
            done
        fi
    else
        log_warn "Si deseas que la SHELL sea zsh y los comandos ejecutados a continuación la reconozcan;"
        log_warn "debes de instalar zsh y crear el archivo .zshrc en $HOME".
        log_warn "Opcionalmente puedes hacerla tu shell por defecto pero no es necesario si ya seguiste el paso anterior."
        segundos=10
        for ((i=segundos; i>0; i--)); do
            log_info "Continuando en $i segundos..."
        sleep 1
        done
    fi
}