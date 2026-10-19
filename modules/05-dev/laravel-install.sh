#!/bin/bash

# ========== Descargar e instalar lampp (xampp) ==========
lamppDir="/opt/lampp"
if [ ! -d "$lamppDir" ]; then
    log_info "Descargando e instalando lampp"
    fileName="xampp-linux-x64-8.2.12-0-installer.run"
    tmpFile="/tmp/$fileName"
    downloadUrl="https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.12/xampp-linux-x64-8.2.12-0-installer.run"

    # Descargar el instalador de xampp
    if [ ! -f "$tmpFile" ]; then
        log_info "Descargando el archivo [$fileName] desde [$downloadUrl]..."
        install_dependencies "curl"
        curl -fL -o "$tmpFile" "$downloadUrl" || die "Falló la descarga del archivo [$fileName] desde [$downloadUrl]"
        log_success "Descarga completada en [$tmpFile]"
    else
        log_warn "El archivo temporal existe [$tmpFile]. Omitiendo descarga"
    fi

    # Dar permisos de ejecución e iniciar el instalador
    cd /tmp || die "No se pudo hacer cd"
    chmod 755 "$fileName" || die "No se pudo dar permisos al archivo [$tmpFile]"
    log_info "Instalando lampp..."
    sudo ./"$fileName" --mode unattended --unattendedmodeui minimal
    log_success "Lampp instalado en [/opt/lampp]"

    log_info "Removiendo descarga temporal..."
    rm -f "$tmpFile" || die "No se pudo eliminar el archivo temporal [$tmpfile]"
    log_success "Descarga temporal eliminada"

    # Añadir el path de lampp al archivo rc de bash o zsh
    add_bin_path(){
        lampp_export_bin_path='export PATH="/opt/lampp/bin:$PATH"'
        local rc_file="$HOME/$1"
        if ! grep -qxF "$lampp_export_bin_path" "$rc_file"; then
            log_info "Agregando la ruta de lampp en [$rc_file]"
            echo "$lampp_export_bin_path" >> "$rc_file"
            log_success "Ruta de lampp añadida a [$rc_file]"
        else
            log_info "Ya tienes la ruta de lampp agregada en [$rc_file]"
        fi
    }

    current_shell=$(basename "$SHELL")
    case "$current_shell" in
        zsh)
            add_bin_path .zshrc
            ;;
        bash)
            add_bin_path .bashrc
            ;;
    esac

    export PATH="/opt/lampp/bin:$PATH"

    log_success "Lampp correctamente instalado"
else
    log_warn "Lampp ya está instalado"
fi

# ========== Descargar e instalar composer ==========

install_composer() {
    # El siguiente bloque de codigo viene de: https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md

    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
    then
        >&2 echo 'ERROR: Invalid installer checksum'
        rm composer-setup.php
        exit 1
    fi

    php composer-setup.php --quiet
    RESULT=$?
    rm composer-setup.php
    # exit $RESULT
    sudo mv composer.phar /usr/local/bin/composer
}

if ! command_exists composer; then
    log_info "Instalando composer..."
    cd "$HOME" || die "No se pudo hacer cd"

    if ! install_composer; then
        die "Hubo un error inesperado"
    fi

    log_success "Composer instalado correctamente"
else
    log_warn "Composer ya está instalado"
fi