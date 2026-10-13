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

# Función para detener la ejecución y reportar errores detallados
# Ejemplo: die "Mensaje descriptivo" 127 <- exit code
die() {
    local message="$1"
    local exit_code="${2:-1}" # Código de salida por defecto: 1
    local line="${BASH_LINENO[0]}"
    local script="${BASH_SOURCE[1]}"

    echo -e "${RED}[ERROR CRÍTICO]${NC} ${BLUE}Script:${NC} $script | ${BLUE}Línea:${NC} $line" >&2
    echo -e "${YELLOW}Motivo:${NC} $message" >&2
    
    exit "$exit_code"
}

# Instalar múltiples dependencias mediante apt
# Ejemplo: install_dependencies "stow" "curl" "wget"
install_dependencies() {
    local missing_pkgs=()

    # Filtrar cuáles dependencias no están instaladas
    for pkg in "$@"; do
        if ! command_exists "$pkg"; then
            missing_pkgs+=("$pkg")
        fi
    done

    # Si todas ya están instaladas, no se hace nada
    if [ ${#missing_pkgs[@]} -eq 0 ]; then
        log_info "Todas las dependencias solicitadas ya están instaladas."
        return 0
    fi

    log_warn "Dependencias faltantes detectadas: ${missing_pkgs[*]}"
    log_info "Actualizando repositorios de APT..."
    
    sudo apt update || die "No se pudieron actualizar los repositorios de APT."

    log_info "Instalando dependencias faltantes..."
    
    # Instalar todas las dependencias
    if sudo apt install -y "${missing_pkgs[@]}"; then
        for pkg in "${missing_pkgs[@]}"; do
            log_success "Dependencia '$pkg' instalada correctamente."
        done
    else
        die "Ocurrió un error crítico al intentar instalar las dependencias: ${missing_pkgs[*]}"
    fi
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