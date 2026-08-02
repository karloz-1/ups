# Ubuntu Personal Setup - Instalador de Configuración

Script automatizado para replicar la configuración de mi máquina Ubuntu.

## Uso

```bash
# Hacer ejecutable
chmod +x install.sh

# Ejecutar todo
./install.sh

# Saltarse un módulo
./install.sh --no-flatpak

# Ejecutar solo un módulo
./install.sh --only-dev

# Combinar opciones
./install.sh --no-gaming --no-dots

# Ejecutar solo repo y packages
./install.sh --no-software --no-flatpak --no-dev --no-ai --no-gaming --no-dots --no-setup
```

## Módulos

| Módulo | Descripción |
|--------|-------------|
| `repo` | Configurar repositorios (griffo, etc.) |
| `packages` | Paquetes del sistema (fastfetch, fish, git, etc.) |
| `software` | Software manual (no en repos oficiales) |
| `flatpak` | Aplicaciones Flatpak |
| `dev` | Herramientas de desarrollo (node, vscode, etc.) |
| `ai` | Herramientas de IA (opencode, claude, aider, etc.) |
| `gaming` | Software de gaming (steam, lutris, etc.) |
| `dots` | Configuraciones (kitty, zsh, dms, etc.) |
| `setup` | Configuración final (shell, alias, etc.) |

## Estructura

```
.
├── install.sh              # Script principal
├── README.md
├── modules/
│   ├── 01-repo/
│   ├── 02-packages/
│   ├── 03-software/
│   ├── 04-flatpak/
│   ├── 05-dev/
│   ├── 09-ai/
│   ├── 06-gaming/
│   ├── 07-dots/
│   └── 08-setup/
└── utils/
    └── common.sh           # Funciones auxiliares
```

## Añadir nuevos módulos

Para añadir un nuevo módulo, sigue estos pasos:

### 1. Crear la carpeta del módulo

```bash
mkdir -p modules/XX-nombre
```

Donde `XX` es el número de orden y `nombre` es el nombre del módulo.

### 2. Crear el archivo install.sh

```bash
cat > modules/XX-nombre/install.sh << 'EOF'
#!/bin/bash
# modules/XX-nombre/install.sh - Descripción del módulo

source "$(dirname "$0")/../../utils/common.sh"

module_nombre() {
    log_info "Ejecutando módulo nombre..."
    
    # TODO: Tu código aquí
    
    log_success "Módulo nombre completado"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_nombre
fi
EOF

chmod +x modules/XX-nombre/install.sh
```

### 3. Registrar el módulo en install.sh

Añade las siguientes líneas en `install.sh`:

**En el array MODULES:**
```bash
declare -A MODULES=(
    # ... otros módulos ...
    [nombre]="XX-nombre"
)
```

**En el array MODULE_ORDER:**
```bash
MODULE_ORDER=(repo packages software flatpak dev ai gaming dots setup nombre)
```

**En la función show_help:**
```bash
Módulos disponibles:
  # ... otros módulos ...
  nombre     Descripción del módulo
```

### 4. Ejemplo completo

```bash
# Crear módulo "docker"
mkdir -p modules/10-docker

cat > modules/10-docker/install.sh << 'EOF'
#!/bin/bash
source "$(dirname "$0")/../../utils/common.sh"

module_docker() {
    log_info "Instalando Docker..."
    
    if command_exists docker; then
        log_warn "Docker ya está instalado"
        return 0
    fi
    
    # Instalar Docker
    curl -fsSL https://get.docker.com | sh
    
    # Añadir usuario al grupo docker
    sudo usermod -aG docker "$USER"
    
    log_success "Docker instalado. Cierra sesión para usar docker sin sudo."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_docker
fi
EOF

chmod +x modules/10-docker/install.sh
```

Luego en `install.sh`:
```bash
declare -A MODULES=(
    # ... otros módulos ...
    [docker]="10-docker"
)

MODULE_ORDER=(repo packages software flatpak dev ai gaming dots setup docker)
```

## Personalización

1. Edita el archivo del módulo que quieras modificar
2. Añade tus propios paquetes, flatpaks, configuraciones, etc.

### Funciones disponibles (utils/common.sh)

- `log_info "mensaje"` - Log informativo (azul)
- `log_success "mensaje"` - Log de éxito (verde)
- `log_warn "mensaje"` - Log de advertencia (amarillo)
- `log_error "mensaje"` - Log de error (rojo)
- `is_installed "paquete"` - Verifica si un paquete está instalado
- `is_flatpak_installed "app"` - Verifica si un flatpak está instalado
- `command_exists "comando"` - Verifica si un comando existe
- `confirm "mensaje"` - Pide confirmación al usuario
