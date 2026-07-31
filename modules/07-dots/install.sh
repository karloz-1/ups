#!/bin/bash
# modules/07-dots/install.sh - Configuraciones (dotfiles)

source "$(dirname "$0")/../../utils/common.sh"
shell_detector

module_dots() {
    log_info "Aplicando configuraciones..."
    
    local dots_dir="$PROJECT_ROOT/configs"
    
    pwd
    local casa="$HOME/Documents"
    echo "$casa"

    # Añadir configuraciones aquí
    if [[ -L "$casa" && -e "$casa" ]]; then
        echo "Esto es un enlace"
    else
        echo "Esto no es un enlace"
    fi

#     comandos utilies:
#     Claro. Si yo fuera a empezar desde cero con tu proyecto `ups`, haría esto.

# ---

# # Objetivo

# Tener un repositorio con tus dotfiles donde:

# * ✅ Puedes editar normalmente desde `~/.config`.
# * ✅ Git detecta los cambios automáticamente.
# * ✅ Si formateas el PC, solo clonas el repo y ejecutas el instalador.
# * ✅ No existen dos copias de los mismos archivos.

# La idea más importante es esta:

# > **El repositorio será la única copia real de tus configuraciones.**
# >
# > `~/.config` contendrá enlaces simbólicos que apuntan a esa copia.

# ---

# # Tu proyecto

# Actualmente tienes algo parecido a:

# ```text
# ups/
# ├── configs/
# ├── modules/
# ├── install.sh
# └── ...
# ```

# La carpeta `configs/` será donde vivan todos tus dotfiles.

# ---

# # Cómo organizar `configs`

# Por ejemplo:

# ```text
# configs/
# ├── niri/
# │   └── .config/
# │       └── niri/
# │           ├── config.kdl
# │           └── dms/
# ├── kitty/
# │   └── .config/
# │       └── kitty/
# ├── nvim/
# │   └── .config/
# │       └── nvim/
# ├── git/
# │   └── .gitconfig
# └── zsh/
#     └── .zshrc
# ```

# Cada carpeta (`niri`, `kitty`, `nvim`, etc.) es un **paquete** de Stow.

# ---

# # Cómo migrar un paquete

# Supongamos que quieres empezar por Niri.

# Actualmente tienes:

# ```text
# ~/.config/niri
# ```

# Lo moverías al repositorio:

# ```bash
# mkdir -p ~/ups/configs/niri/.config

# mv ~/.config/niri ~/ups/configs/niri/.config/
# ```

# Ahora el repositorio contiene la configuración.

# ---

# # Crear los enlaces

# Después:

# ```bash
# cd ~/ups/configs

# stow --target="$HOME" niri
# ```

# Stow crea los enlaces necesarios.

# Desde ese momento vuelve a existir:

# ```text
# ~/.config/niri
# ```

# pero ya no es una carpeta independiente.

# Apunta a

# ```text
# ~/ups/configs/niri/.config/niri
# ```

# ---

# # ¿Qué pasa al editar?

# Si haces:

# ```bash
# nvim ~/.config/niri/config.kdl
# ```

# realmente modificas

# ```text
# ~/ups/configs/niri/.config/niri/config.kdl
# ```

# Git verá el cambio inmediatamente.

# No necesitas sincronizar nada.

# ---

# # ¿Y si Niri crea nuevos archivos?

# Por ejemplo:

# ```text
# ~/.config/niri/dms/animations.kdl
# ```

# Ese archivo aparecerá directamente dentro del repositorio.

# Solo tendrás que hacer:

# ```bash
# git add .
# git commit
# git push
# ```

# No necesitas volver a ejecutar Stow.

# ---

# # ¿Y si reorganizo mi configuración?

# Supongamos que mañana decides crear:

# ```text
# scripts/
# themes/
# modules/
# ```

# dentro de `~/.config/niri`.

# No pasa nada.

# Como estás trabajando sobre el directorio enlazado, esas carpetas nuevas también forman parte del repositorio.

# ---

# # ¿Cuándo ejecuto Stow?

# Normalmente solo:

# * cuando instalas una máquina nueva;
# * cuando agregas un paquete nuevo (por ejemplo `waybar`);
# * cuando eliminas un paquete (`stow -D`).

# No hace falta ejecutarlo cada vez que cambias un archivo.

# ---

# # ¿Puedo ejecutar Stow muchas veces?

# Sí.

# Es seguro hacerlo varias veces.

# Solo dará un error si encuentra un conflicto, por ejemplo si ya existe un archivo real donde quiere crear un enlace.

# ---

# # ¿Qué hará tu módulo `07-dots`?

# Algo tan simple como:

# ```bash
# cd "$ROOT/configs"

# stow --target="$HOME" *
# ```

# Cada carpeta dentro de `configs/` se enlazará automáticamente.

# Si mañana agregas:

# ```text
# configs/
# ├── waybar/
# ├── foot/
# ├── starship/
# ```

# el script no necesita cambiar.

# ---

# # El flujo diario

# Tu día a día sería:

# ```text
# Editar ~/.config/niri/config.kdl
#             │
#             ▼
# Git detecta el cambio
#             │
#             ▼
# git add .
# git commit
# git push
# ```

# No hay pasos de sincronización.

# No hay que copiar archivos.

# No hay que ejecutar scripts después de editar.

# ---

# # El flujo al formatear el PC

# 1. Clonas tu repositorio.

# ```bash
# git clone ...
# ```

# 2. Ejecutas tu instalador.

# ```bash
# ./install.sh
# ```

# 3. El módulo `07-dots` ejecuta Stow.

# 4. Todas las configuraciones aparecen otra vez en:

# ```text
# ~/.config
# ```

# listas para usar.

# ---

# ## Mi recomendación

# No migres todas las configuraciones de golpe. Empieza solo con `niri`:

# 1. Mueve `~/.config/niri` a `configs/niri/.config/`.
# 2. Ejecuta `stow --target="$HOME" niri`.
# 3. Comprueba que `~/.config/niri` funciona con normalidad.
# 4. Haz un cambio en `config.kdl` y verifica que `git status` lo detecta.
# 5. Crea un archivo nuevo dentro de `~/.config/niri` y confirma que aparece también en el repositorio.

# Cuando veas ese flujo funcionando, podrás migrar `kitty`, `nvim`, `waybar`, `hypr`, `zsh` y el resto con el mismo patrón. Es más fácil validar el proceso con un solo paquete antes de extenderlo a toda tu configuración.

    
    log_success "Configuraciones aplicadas"
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    module_dots
fi
