#!/bin/bash

log_info "Instalando plugins de DuxShell"
local plugins=(
    quickCapture
    dankKDEConnect
)
for plugin in "${plugins[@]}"; do
    log_info "Instalando $plugin...."
    dms plugins install "$plugin"
done