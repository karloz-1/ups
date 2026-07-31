#!/bin/bash
# install.sh - Orquestador principal
# Uso: ./install.sh [--no-<modulo>] [--only-<modulo>] [--help]

set -euo pipefail

sudo -v || exit 1
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null' EXIT

clear

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/common.sh"

shell_detector

# ============================================================
# Definición de módulos (orden de ejecución)
# ============================================================
declare -A MODULES=(
    [repo]="01-repo"
    [packages]="02-packages"
    [software]="03-software"
    [flatpak]="04-flatpak"
    [dev]="05-dev"
    [ai]="09-ai"
    [gaming]="06-gaming"
    [dots]="07-dots"
    [setup]="08-setup"
)

# Orden de ejecución
MODULE_ORDER=(repo packages software flatpak dev ai gaming dots setup)

# Estado de cada módulo (true = ejecutar)
declare -A ENABLED=()
for mod in "${MODULE_ORDER[@]}"; do
    ENABLED[$mod]=true
done

# ============================================================
# Funciones
# ============================================================

show_help() {
    cat <<EOF
Uso: $(basename "$0") [OPCIONES]

Opciones:
  --no-<modulo>     Saltarse un módulo específico
  --only-<modulo>   Ejecutar SOLO un módulo específico
  --list            Listar todos los módulos disponibles
  --help            Mostrar esta ayuda

Módulos disponibles:
  repo       Configurar repositorios
  packages   Paquetes del sistema
  software   Software manual (no repos)
  flatpak    Aplicaciones Flatpak
  dev        Herramientas de desarrollo
  ai         Herramientas de IA (opencode, etc.)
  gaming     Gaming
  dots       Configuraciones (dotfiles)
  setup      Configuración final

Ejemplos:
  $(basename "$0")                        # Ejecutar todo
  $(basename "$0") --no-flatpak           # Todo excepto flatpak
  $(basename "$0") --only-dev             # Solo herramientas de desarrollo
  $(basename "$0") --no-gaming --no-dots  # Todo excepto gaming y dots
EOF
}

list_modules() {
    log_info "Módulos disponibles (en orden de ejecución):"
    for mod in "${MODULE_ORDER[@]}"; do
        local status="ON"
        [[ "${ENABLED[$mod]}" == "false" ]] && status="OFF"
        printf "  %-12s [%s] %s\n" "$mod" "$status" "${MODULES[$mod]}"
    done
}

parse_args() {
    local only_mode=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_help
                exit 0
                ;;
            --list)
                list_modules
                exit 0
                ;;
            --no-*)
                local mod="${1#--no-}"
                if [[ -z "${MODULES[$mod]+x}" ]]; then
                    log_error "Módulo desconocido: $mod"
                    log_info "Usa --list para ver los módulos disponibles"
                    exit 1
                fi
                ENABLED[$mod]=false
                shift
                ;;
            --only-*)
                local mod="${1#--only-}"
                if [[ -z "${MODULES[$mod]+x}" ]]; then
                    log_error "Módulo desconocido: $mod"
                    log_info "Usa --list para ver los módulos disponibles"
                    exit 1
                fi
                # Deshabilitar todos excepto este
                for m in "${MODULE_ORDER[@]}"; do
                    ENABLED[$m]=false
                done
                ENABLED[$mod]=true
                only_mode=true
                shift
                ;;
            *)
                log_error "Opción desconocida: $1"
                log_info "Usa --help para ver las opciones disponibles"
                exit 1
                ;;
        esac
    done
}

run_module() {
    local mod="$1"
    local module_dir="$SCRIPT_DIR/modules/${MODULES[$mod]}"
    local module_script="$module_dir/install.sh"
    
    if [[ ! -f "$module_script" ]]; then
        log_warn "Script no encontrado: $module_script"
        return 0
    fi
    
    log_info "═══════════════════════════════════════════"
    log_info "Ejecutando módulo: $mod"
    log_info "═══════════════════════════════════════════"
    
    chmod +x "$module_script"
    bash "$module_script"
    
    log_success "Módulo $mod completado"
}

# ============================================================
# Main
# ============================================================

main() {
    parse_args "$@"
    
    echo
    log_info "╔══════════════════════════════════════════╗"
    log_info "║   Instalador de configuración            ║"
    log_info "╚══════════════════════════════════════════╝"
    echo
    
    list_modules
    echo
    
    for mod in "${MODULE_ORDER[@]}"; do
        if [[ "${ENABLED[$mod]}" == "true" ]]; then
            run_module "$mod"
        else
            log_warn "Saltándose módulo: $mod"
        fi
    done
    
    echo
    log_success "╔══════════════════════════════════════════╗"
    log_success "║   ¡Instalación completada!               ║"
    log_success "╚══════════════════════════════════════════╝"
}

main "$@"
