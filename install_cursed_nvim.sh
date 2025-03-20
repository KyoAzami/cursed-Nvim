# ███████  ██████ ██████  ██ ██████  ████████     ██████  ███████     ██ ███    ██ ███████ ████████  █████  ██       █████   ██████ ██  ██████  ███    ██ 
# ██      ██      ██   ██ ██ ██   ██    ██        ██   ██ ██          ██ ████   ██ ██         ██    ██   ██ ██      ██   ██ ██      ██ ██    ██ ████   ██ 
# ███████ ██      ██████  ██ ██████     ██        ██   ██ █████       ██ ██ ██  ██ ███████    ██    ███████ ██      ███████ ██      ██ ██    ██ ██ ██  ██ 
#      ██ ██      ██   ██ ██ ██         ██        ██   ██ ██          ██ ██  ██ ██      ██    ██    ██   ██ ██      ██   ██ ██      ██ ██    ██ ██  ██ ██ 
# ███████  ██████ ██   ██ ██ ██         ██        ██████  ███████     ██ ██   ████ ███████    ██    ██   ██ ███████ ██   ██  ██████ ██  ██████  ██   ████ 
                                                                                                                                                        
                                                                                                                                                        



#!/bin/bash

# Función para mostrar mensajes de error y salir
function error_exit {
    echo "Error: $1" >&2
    exit 1
}

# Función para detectar la distribución
function detect_distro {
    if [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/fedora-release ]; then
        echo "fedora"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    else
        error_exit "Distribución no soportada. Este script solo funciona en Debian, Fedora y Arch."
    fi
}

# Verificar si Git está instalado
if ! command -v git &> /dev/null; then
    error_exit "Git no está instalado. Por favor, instálalo e intenta nuevamente."
fi

# Verificar si Neovim está instalado
if ! command -v nvim &> /dev/null; then
    error_exit "Neovim no está instalado. Por favor, instálalo e intenta nuevamente."
fi

# Verificar si npm está instalado
if ! command -v npm &> /dev/null; then
    echo "npm no está instalado. Instalando npm..."
    DISTRO=$(detect_distro)
    case $DISTRO in
        debian)
            sudo apt update && sudo apt install -y npm || error_exit "No se pudo instalar npm."
            ;;
        fedora)
            sudo dnf install -y npm || error_exit "No se pudo instalar npm."
            ;;
        arch)
            sudo pacman -S nodejs npm --noconfirm || error_exit "No se pudo instalar npm."
            ;;
    esac
fi

# Instalar servidores de lenguaje
echo "Instalando servidores de lenguaje..."

# HTML/CSS
npm install -g vscode-langservers-extracted || error_exit "No se pudo instalar vscode-langservers-extracted (HTML/CSS)."

# JavaScript/TypeScript
npm install -g typescript typescript-language-server || error_exit "No se pudo instalar typescript/typescript-language-server."

# Java (Eclipse JDTLS)
if ! command -v jdtls &> /dev/null; then
    echo "Java (Eclipse JDTLS) no está instalado. Por favor, instálalo manualmente desde https://download.eclipse.org/jdtls/snapshots/?d."
fi

# Rust
if ! command -v rustup &> /dev/null; then
    echo "Instalando rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || error_exit "No se pudo instalar rustup."
    source "$HOME/.cargo/env"
fi
rustup component add rust-analyzer || error_exit "No se pudo instalar rust-analyzer."

# C/C++
if ! command -v clangd &> /dev/null; then
    echo "Instalando clangd..."
    DISTRO=$(detect_distro)
    case $DISTRO in
        debian)
            sudo apt install -y clangd || error_exit "No se pudo instalar clangd."
            ;;
        fedora)
            sudo dnf install -y clang-tools-extra || error_exit "No se pudo instalar clangd."
            ;;
        arch)
            sudo pacman -S clang --noconfirm || error_exit "No se pudo instalar clangd."
            ;;
    esac
fi

# Assembly
npm install -g asm-lsp || error_exit "No se pudo instalar asm-lsp."

# Kotlin
if ! command -v kotlin-language-server &> /dev/null; then
    echo "Kotlin Language Server no está instalado. Por favor, instálalo manualmente desde https://github.com/fwcd/kotlin-language-server."
fi

# Go
if ! command -v go &> /dev/null; then
    echo "Instalando Go..."
    DISTRO=$(detect_distro)
    case $DISTRO in
        debian)
            sudo apt install -y golang || error_exit "No se pudo instalar Go."
            ;;
        fedora)
            sudo dnf install -y golang || error_exit "No se pudo instalar Go."
            ;;
        arch)
            sudo pacman -S go --noconfirm || error_exit "No se pudo instalar Go."
            ;;
    esac
fi
go install golang.org/x/tools/gopls@latest || error_exit "No se pudo instalar gopls."

# PHP
npm install -g intelephense || error_exit "No se pudo instalar intelephense."

# SQL
npm install -g sql-language-server || error_exit "No se pudo instalar sql-language-server."

# Python
if ! command -v pip &> /dev/null; then
    echo "Instalando pip..."
    DISTRO=$(detect_distro)
    case $DISTRO in
        debian)
            sudo apt install -y python3-pip || error_exit "No se pudo instalar pip."
            ;;
        fedora)
            sudo dnf install -y python3-pip || error_exit "No se pudo instalar pip."
            ;;
        arch)
            sudo pacman -S python-pip --noconfirm || error_exit "No se pudo instalar pip."
            ;;
    esac
fi
pip install pyright || error_exit "No se pudo instalar pyright."

# COBOL
npm install -g cobol-language-support || error_exit "No se pudo instalar cobol-language-support."

# Directorio de configuración de Neovim
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Crear el directorio de configuración si no existe
mkdir -p "$NVIM_CONFIG_DIR"

# Clonar el repositorio en el directorio de configuración de Neovim
git clone https://github.com/KyoAzami/cursed-Nvim.git "$NVIM_CONFIG_DIR" || error_exit "No se pudo clonar el repositorio."

# Cambiar al directorio de configuración de Neovim
cd "$NVIM_CONFIG_DIR" || error_exit "No se pudo acceder al directorio $NVIM_CONFIG_DIR."

# Instalar 'lazy.nvim' si no está instalado
if [ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
    echo "Instalando 'lazy.nvim'..."
    git clone https://github.com/folke/lazy.nvim.git "$HOME/.local/share/nvim/lazy/lazy.nvim" || error_exit "No se pudo clonar 'lazy.nvim'."
fi

# Instalar los plugins
nvim --headless +Lazy! sync +qa || error_exit "No se pudieron instalar los plugins."

echo "Instalación completada con éxito."
