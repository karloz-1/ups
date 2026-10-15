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

separator() {
    # Usa el carácter que le pases como argumento, o '=' por defecto
    local char="${1:-=}"
    local cols
    
    # Obtiene el ancho actual de la terminal
    cols=$(tput cols)
    
    # Imprime el carácter repetido hasta completar el ancho
    printf '%*s\n' "$cols" '' | tr ' ' "$char"
}

# Detecta la shell que se está utilizando en el momento.
# Si detecta que tienes zsh instalado, el script asumirá que usas zsh como shell de terminal.
shell_detector() {
    log_info "SHELL Actual = $SHELL"
    if command_exists zsh && [ -f "$HOME"/.zshrc ]; then
        if ! echo "$SHELL" | grep "zsh" &>/dev/null; then
            # Mensajes de advertencia
            log_warn "Se ha detectado que ya tienes zsh instalado y tienes el archivo $HOME/.zshrc creado, pero no es tu shell predeterminada"
            log_warn "El script asumirá que usarás zsh, por consecuente; se reemplazará el contenido de la variable SHELL ($SHELL) por ($(which zsh))"
            log_warn "Esto con el fin de que todos los comandos que necesiten saber que SHELL se está usando piensen que usas zsh y modifiquen el archivo .zshrc en vez del archivo .bashrc"
            separator

            echo ""
            segundos=15
            log_warn "${RED}SI NO ESTAS DE ACUERDO${NC} CON LO ANTERIOR Y QUIERES SEGUIR USANDO BASH; ${RED}CANCELA LA EJECUCIÓN DE SCRIPT AHORA MISMO (CTRL + C)${NC} Y ELIMINA EL PAQUETE ZSH O EL ARCHIVO .zshrc"
            echo ""
            log_info "Si quieres tomarte el tiempo de leer; cancela la ejecución del script (Ctrl + C)"
            for ((i=segundos; i>0; i--)); do
                echo -ne "\r${YELLOW}[WARN]${NC} Cambiando SHELL de ($SHELL) a ($(which zsh)) en $i segundos... \033[K"
                sleep 1
            done
            echo ""

            log_warn "Cambiando a zsh..."
            export SHELL="$(which zsh)"
            log_success "SHELL temporal = $SHELL"

            for ((i=5; i>0; i--)); do
                echo -ne "\r${BLUE}[INFO]${NC} Continuando en $i segundos... \033[K"
                sleep 1
            done
            echo ""
        else
            log_info "La shell por defecto ya es zsh. No hay acciones que realizar"
            for ((i=5; i>0; i--)); do
                echo -ne "\r${BLUE}[INFO]${NC} Continuando en $i segundos... \033[K"
                sleep 1
            done
            echo ""
        fi
    else
        log_warn "La shell por defecto es bash"
        log_warn "Si deseas que la SHELL sea zsh y los comandos ejecutados a continuación la reconozcan;"
        log_warn "debes de instalar zsh y crear el archivo .zshrc en $HOME".
        log_warn "Opcionalmente puedes hacerla tu shell por defecto pero no es necesario si ya seguiste el paso anterior."
        separator
        segundos=10
        for ((i=segundos; i>0; i--)); do
            echo -ne "\r${BLUE}[INFO]${NC} Continuando en $i segundos... \033[K"
            sleep 1
        done
        echo ""
    fi
}