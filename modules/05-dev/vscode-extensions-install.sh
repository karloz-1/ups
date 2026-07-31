#!/bin/bash

if command_exists code; then
    # Añadir extensiones aquí
    local vscode_extensions=(
        vscodevim.vim
        teabyii.ayu
        ritwickdey.LiveServer
        esbenp.prettier-vscode
        PKief.material-icon-theme
        miguelsolorio.fluent-icons
        formulahendry.auto-rename-tag
        formulahendry.auto-close-tag
        formulahendry.auto-complete-tag
        xabikos.JavaScriptSnippets
        DavidAnson.vscode-markdownlint
        yzhang.markdown-all-in-one
        dsznajder.es7-react-js-snippets
        dbaeumer.vscode-eslint
        eamodio.gitlens
        streetsidesoftware.code-spell-checker
        streetsidesoftware.code-spell-checker-spanish
        myriad-dreamin.tinymist
        icrawl.discord-vscode
    )

    for ext in "${vscode_extensions[@]}"; do
        if code --list-extensions | grep -q "$ext"; then
            log_warn "Extensión $ext ya instalada"
        else
            log_info "Instalando extensión $ext..."
            code --install-extension "$ext"
        fi
    done
else
    log_error "Vscode no está instalado"
    log_warn "Omitiendo extensiones"
fi
