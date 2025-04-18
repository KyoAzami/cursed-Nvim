# ███████  ██████ ██████  ██ ██████  ████████     ██████  ███████     ██ ███    ██ ███████ ████████  █████  ██       █████   ██████ ██  ██████  ███    ██ 
# ██      ██      ██   ██ ██ ██   ██    ██        ██   ██ ██          ██ ████   ██ ██         ██    ██   ██ ██      ██   ██ ██      ██ ██    ██ ████   ██ 
# ███████ ██      ██████  ██ ██████     ██        ██   ██ █████       ██ ██ ██  ██ ███████    ██    ███████ ██      ███████ ██      ██ ██    ██ ██ ██  ██ 
#      ██ ██      ██   ██ ██ ██         ██        ██   ██ ██          ██ ██  ██ ██      ██    ██    ██   ██ ██      ██   ██ ██      ██ ██    ██ ██  ██ ██ 
# ███████  ██████ ██   ██ ██ ██         ██        ██████  ███████     ██ ██   ████ ███████    ██    ██   ██ ███████ ██   ██  ██████ ██  ██████  ██   ████ 
                                                                                                                                                        
                                                                                                                                                        



#!/bin/bash

# Función para registrar los mensajes
log() {
    echo "[INFO] $(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a install_log.txt
}

# Comprobamos el sistema operativo
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        log "No se pudo detectar la distribución."
        exit 1
    fi
}

# Función para instalar dependencias
install_deps() {
    log "Comenzando instalación de dependencias..."
    case $DISTRO in
        "arch"|"manjaro")
            log "Distribución Arch/Manjaro detectada."
            sudo pacman -S --noconfirm git curl nodejs npm python python-pip
            ;;
        "debian"|"ubuntu")
            log "Distribución Debian/Ubuntu detectada."
            sudo apt update && sudo apt install -y git curl nodejs npm python3 python3-pip
            ;;
        "fedora")
            log "Distribución Fedora detectada."
            sudo dnf install -y git curl nodejs npm python3 python3-pip
            ;;
        *)
            log "Distribución no soportada por este script."
            exit 1
            ;;
    esac
}

# Instalación de LSPs y otros componentes
install_lsp() {
    log "Instalando servidores de lenguaje..."

    # LSPs en npm
    npm install -g typescript typescript-language-server intelephense sql-language-server

    # Rust Analyzer
    log "Instalando rust-analyzer..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # Instalaciones específicas que pueden necesitar interacción (JDTLS, Kotlin)
    log "Por favor, instala Eclipse JDTLS manualmente desde https://download.eclipse.org/jdtls/snapshots/?d"
    log "Por favor, instala Kotlin Language Server manualmente desde https://github.com/fwcd/kotlin-language-server"

    # Instalaciones Python
    log "Instalando pyright con pipx..."
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    pipx install pyright
}

# Clonando la configuración de Neovim
clone_nvim_config() {
    log "Clonando configuración de Neovim desde GitHub..."
    git clone git@github.com:KyoAzami/cursed-Nvim.git ~/.config/nvim
    log "Tema aplicado correctamente: everforest."
}

# Función principal
main() {
    log "Iniciando instalación..."

    # Detectar la distribución
    detect_distro

    # Instalar dependencias
    install_deps

    # Instalar LSPs
    install_lsp

    # Clonar configuración de Neovim
    clone_nvim_config

    log "Instalación completada con éxito."
}

# Ejecutar el script principal
main

