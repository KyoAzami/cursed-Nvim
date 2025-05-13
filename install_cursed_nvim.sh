#!/bin/bash

# ==============================================
# CONFIGURACIÓN INICIAL
# ==============================================

set -euo pipefail
trap 'catch_error $? $LINENO' ERR

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Variables globales
DISTRO=""
NVIM_VERSION="0.9.5"
LOG_FILE="nvim_install.log"
NPM_PREFIX="$HOME/.npm-global"

# ==============================================
# FUNCIONES BÁSICAS
# ==============================================

catch_error() {
    echo -e "${RED}[ERROR] Error $1 en línea $2${NC}" | tee -a "$LOG_FILE"
    exit 1
}

log() {
    local level=$1
    local message=$2
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    case $level in
        "INFO") color=$GREEN ;;
        "WARN") color=$YELLOW ;;
        "ERROR") color=$RED ;;
        *) color=$NC ;;
    esac
    
    echo -e "${color}[$level] ${timestamp} - ${message}${NC}" | tee -a "$LOG_FILE"
}

# ==============================================
# DETECCIÓN DEL SISTEMA
# ==============================================

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        log "INFO" "Distribución detectada: $DISTRO"
    else
        log "ERROR" "No se pudo detectar la distribución Linux"
        exit 1
    fi
}

# ==============================================
# INSTALACIÓN DE DEPENDENCIAS BÁSICAS
# ==============================================

install_basic_deps() {
    log "INFO" "Instalando dependencias básicas..."
    
    case $DISTRO in
        "ubuntu"|"debian"|"pop"|"linuxmint")
            sudo apt update && sudo apt install -y \
                git curl wget build-essential \
                python3 python3-pip python3-venv \
                npm nodejs libssl-dev \
                fd-find ripgrep unzip tar || {
                log "ERROR" "Falló la instalación de dependencias básicas"
                exit 1
            }
            ;;
        "arch"|"manjaro")
            sudo pacman -Sy --noconfirm \
                git curl wget base-devel \
                python python-pip python-pipx \
                npm nodejs openssl \
                fd ripgrep unzip tar || {
                log "ERROR" "Falló la instalación de dependencias básicas"
                exit 1
            }
            python -m pipx ensurepath
            export PATH="$PATH:$HOME/.local/bin"
            ;;
        "fedora"|"centos"|"rhel")
            sudo dnf install -y \
                git curl wget gcc-c++ make \
                python3 python3-pip \
                nodejs npm openssl-devel \
                fd-find ripgrep unzip tar || {
                log "ERROR" "Falló la instalación de dependencias básicas"
                exit 1
            }
            ;;
        *)
            log "ERROR" "Distribución no soportada: $DISTRO"
            exit 1
            ;;
    esac
    
    # Verificar instalaciones básicas
    verify_installation "git" "git --version"
    verify_installation "node" "node --version"
    verify_installation "npm" "npm --version"
    verify_installation "python3" "python3 --version"
}

# ==============================================
# CONFIGURACIÓN DE NPM SEGURA
# ==============================================

configure_npm() {
    log "INFO" "Configurando NPM para evitar problemas de permisos..."
    
    mkdir -p "$NPM_PREFIX"
    npm config set prefix "$NPM_PREFIX"
    
    if ! grep -q "$NPM_PREFIX/bin" "$HOME/.bashrc"; then
        echo "export PATH=\"$NPM_PREFIX/bin:\$PATH\"" >> "$HOME/.bashrc"
    fi
    
    export PATH="$NPM_PREFIX/bin:$PATH"
    log "INFO" "NPM configurado para instalar en $NPM_PREFIX"
}

# ==============================================
# INSTALACIÓN DE DEPENDENCIAS PARA COMPILACIÓN
# ==============================================

install_build_deps() {
    log "INFO" "Instalando dependencias para compilación..."

    case $DISTRO in
        "ubuntu"|"debian"|"pop"|"linuxmint")
            sudo apt update && sudo apt install -y \
                git ninja-build gettext cmake unzip curl \
                build-essential autoconf automake libtool \
                pkg-config g++ libssl-dev || {
                log "ERROR" "Falló la instalación de dependencias de compilación"
                exit 1
            }
            ;;
        "arch"|"manjaro")
            sudo pacman -Sy --noconfirm \
                git ninja gettext cmake unzip curl \
                base-devel autoconf automake libtool \
                pkgconf openssl || {
                log "ERROR" "Falló la instalación de dependencias de compilación"
                exit 1
            }
            ;;
        "fedora"|"centos"|"rhel")
            sudo dnf install -y \
                git ninja-build gettext cmake unzip curl \
                gcc-c++ make autoconf automake libtool \
                pkgconfig openssl-devel || {
                log "ERROR" "Falló la instalación de dependencias de compilación"
                exit 1
            }
            ;;
        *)
            log "ERROR" "Distribución no soportada para compilación automática"
            exit 1
            ;;
    esac
}

# ==============================================
# INSTALACIÓN DE NEOVIM 0.10+
# ==============================================

install_neovim() {
    # Verificar si ya está instalada una versión compatible
    if command -v nvim &> /dev/null && [ "$(nvim --version | head -n1 | awk '{print $2}' | cut -d'-' -f1)" != "$NVIM_VERSION" ]; then
        log "INFO" "Neovim ya está instalado en una versión compatible"
        return
    fi

    log "INFO" "Instalando Neovim 0.10+..."

    case $DISTRO in
        "ubuntu"|"debian"|"pop"|"linuxmint")
            # Usar PPA oficial para versiones recientes
            sudo add-apt-repository -y ppa:neovim-ppa/unstable
            sudo apt update
            sudo apt install -y neovim || {
                log "WARN" "Falló instalación desde PPA, intentando compilación"
                compile_neovim_from_source
            }
            ;;
        "arch"|"manjaro")
            # Usar AUR para versión más reciente
            if command -v yay &> /dev/null; then
                yay -S --noconfirm neovim-git
            elif command -v paru &> /dev/null; then
                paru -S --noconfirm neovim-git
            else
                log "WARN" "No se encontró yay/paru, instalando desde repositorio oficial"
                sudo pacman -S --noconfirm neovim || compile_neovim_from_source
            fi
            ;;
        "fedora")
            sudo dnf install -y neovim || compile_neovim_from_source
            ;;
        *)
            compile_neovim_from_source
            ;;
    esac

    # Verificar instalación
    if ! command -v nvim &> /dev/null; then
        log "ERROR" "Falló la instalación de Neovim"
        exit 1
    fi

    log "INFO" "Neovim $(nvim --version | head -n1) instalado correctamente"
}

compile_neovim_from_source() {
    log "INFO" "Compilando Neovim desde código fuente..."

    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    git clone https://github.com/neovim/neovim.git
    cd neovim

    # Usar la última versión estable
    git checkout stable

    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install

    cd -
    rm -rf "$temp_dir"
}

# ==============================================
# INSTALACIÓN DE SERVIDORES LSP (ROBUSTA)
# ==============================================

install_lsp_servers() {
    log "INFO" "Instalando servidores LSP con métodos robustos..."
    
    configure_npm
    
    declare -A LSP_SERVERS=(
        ["typescript-language-server"]="install_typescript_lsp"
        ["vim-language-server"]="install_vim_lsp"
        ["bash-language-server"]="install_bash_lsp"
        ["pyright"]="install_pyright"
        ["rust-analyzer"]="install_rust_analyzer"
        ["lua-language-server"]="install_lua_lsp"
        ["clangd"]="install_clangd"
        ["dockerfile-language-server-nodejs"]="install_docker_lsp"
        ["yaml-language-server"]="install_yaml_lsp"
    )
    
    for lsp in "${!LSP_SERVERS[@]}"; do
        if ! command -v "$lsp" &> /dev/null; then
            log "INFO" "Instalando $lsp..."
            if ! eval "${LSP_SERVERS[$lsp]}"; then
                log "WARN" "No se pudo instalar $lsp con ningún método disponible"
            fi
        else
            log "INFO" "$lsp ya está instalado"
        fi
    done
}

# Métodos de instalación específicos para cada LSP

install_typescript_lsp() {
    # Método 1: NPM local
    if npm install -g typescript typescript-language-server; then
        return 0
    fi
    
    # Método 2: Paquete del sistema
    case $DISTRO in
        "ubuntu"|"debian")
            sudo apt install -y node-typescript || return 1
            ;;
        "arch"|"manjaro")
            sudo pacman -S --noconfirm typescript-language-server || return 1
            ;;
        *)
            return 1
            ;;
    esac
}

install_vim_lsp() {
    # Método 1: NPM local
    if npm install -g vim-language-server; then
        return 0
    fi
    
    # Método 2: Descarga directa
    local latest_url=$(curl -s https://api.github.com/repos/iamcco/vim-language-server/releases/latest | grep "browser_download_url.*linux-x64" | cut -d'"' -f4)
    local temp_dir=$(mktemp -d)
    
    curl -L "$latest_url" -o "$temp_dir/vim-lsp.tar.gz"
    tar -xzf "$temp_dir/vim-lsp.tar.gz" -C "$temp_dir"
    mv "$temp_dir/vim-language-server" "$NPM_PREFIX/bin/"
    rm -rf "$temp_dir"
}

install_bash_lsp() {
    # Método 1: NPM local
    if npm install -g bash-language-server; then
        return 0
    fi
    
    # Método 2: Paquete del sistema
    case $DISTRO in
        "ubuntu"|"debian")
            sudo apt install -y bash-language-server || return 1
            ;;
        "arch"|"manjaro")
            sudo pacman -S --noconfirm bash-language-server || return 1
            ;;
        "fedora")
            sudo dnf install -y nodejs-bash-language-server || return 1
            ;;
        *)
            return 1
            ;;
    esac
}

install_pyright() {
    # Método 1: pipx
    if command -v pipx &> /dev/null; then
        pipx install pyright && return 0
    fi
    
    # Método 2: pip --user
    python3 -m pip install --user pyright && return 0
    
    # Método 3: Descarga directa
    local latest_url=$(curl -s https://api.github.com/repos/microsoft/pyright/releases/latest | grep "browser_download_url.*linux-x64" | cut -d'"' -f4)
    local temp_dir=$(mktemp -d)
    
    curl -L "$latest_url" -o "$temp_dir/pyright.tar.gz"
    tar -xzf "$temp_dir/pyright.tar.gz" -C "$temp_dir"
    mv "$temp_dir/pyright" "$HOME/.local/bin/"
    rm -rf "$temp_dir"
}

install_rust_analyzer() {
    if command -v rustup &> /dev/null; then
        rustup component add rust-analyzer && return 0
    fi
    
    # Instalación manual
    local latest_url=$(curl -s https://api.github.com/repos/rust-lang/rust-analyzer/releases/latest | grep "browser_download_url.*linux-x64" | cut -d'"' -f4)
    curl -L "$latest_url" -o "$HOME/.local/bin/rust-analyzer"
    chmod +x "$HOME/.local/bin/rust-analyzer"
}

install_lua_lsp() {
    case $DISTRO in
        "ubuntu"|"debian")
            sudo apt install -y lua-language-server || return 1
            ;;
        "arch"|"manjaro")
            sudo pacman -S --noconfirm lua-language-server || return 1
            ;;
        *)
            local version="3.6.9"
            local install_dir="$HOME/.local/share/lua-language-server"
            
            mkdir -p "$install_dir"
            curl -L "https://github.com/LuaLS/lua-language-server/releases/download/$version/lua-language-server-$version-linux-x64.tar.gz" | \
                tar xzf - -C "$install_dir"
            
            ln -s "$install_dir/bin/lua-language-server" "$HOME/.local/bin/" 2>/dev/null || true
            ;;
    esac
}

install_clangd() {
    case $DISTRO in
        "ubuntu"|"debian")
            sudo apt install -y clangd-12 && \
            sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
            ;;
        "arch"|"manjaro")
            sudo pacman -S --noconfirm clang
            ;;
        "fedora")
            sudo dnf install -y clang-tools-extra
            ;;
        *)
            local latest_url=$(curl -s https://api.github.com/repos/clangd/clangd/releases/latest | grep "browser_download_url.*linux-x64" | cut -d'"' -f4)
            curl -L "$latest_url" -o "$HOME/.local/bin/clangd.tar.gz"
            tar -xzf "$HOME/.local/bin/clangd.tar.gz" -C "$HOME/.local/bin/"
            rm "$HOME/.local/bin/clangd.tar.gz"
            ;;
    esac
}

install_docker_lsp() {
    if npm install -g dockerfile-language-server-nodejs; then
        return 0
    fi
    
    local latest_url=$(curl -s https://api.github.com/repos/rcjsuen/dockerfile-language-server-nodejs/releases/latest | grep "browser_download_url.*linux-x64" | cut -d'"' -f4)
    local temp_dir=$(mktemp -d)
    
    curl -L "$latest_url" -o "$temp_dir/docker-lsp.tar.gz"
    tar -xzf "$temp_dir/docker-lsp.tar.gz" -C "$temp_dir"
    mv "$temp_dir/dockerfile-language-server-nodejs" "$NPM_PREFIX/bin/"
    rm -rf "$temp_dir"
}

install_yaml_lsp() {
    if npm install -g yaml-language-server; then
        return 0
    fi
    
    case $DISTRO in
        "arch"|"manjaro")
            sudo pacman -S --noconfirm yaml-language-server || return 1
            ;;
        *)
            return 1
            ;;
    esac
}

# ==============================================
# CONFIGURACIÓN DE NVIM
# ==============================================

setup_nvim_config() {
    log "INFO" "Configurando Neovim..."
    
    local nvim_dir="$HOME/.config/nvim"
    local backup_dir="$HOME/.config/nvim.bak.$(date +%s)"
    
    if [ -d "$nvim_dir" ]; then
        log "WARN" "Ya existe una configuración de Neovim"
        mv "$nvim_dir" "$backup_dir"
        log "INFO" "Se hizo backup en $backup_dir"
    fi
    
    git clone --depth 1 git@github.com:KyoAzami/cursed-Nvim.git "$nvim_dir" || {
        log "ERROR" "Falló al clonar el repositorio de configuración"
        exit 1
    }
    
    log "INFO" "Instalando plugins de Neovim..."
    nvim --headless "+Lazy! sync" +qa || {
        log "WARN" "Falló la instalación automática de plugins, intentando manualmente..."
        nvim +LazyInstall +qa
    }
    
    log "INFO" "Configuración de Neovim completada"
}

verify_installation() {
    local name=$1
    local cmd=$2
    
    if ! eval "$cmd" &> /dev/null; then
        log "ERROR" "$name no se instaló correctamente"
        exit 1
    else
        log "INFO" "$name verificado: $(eval "$cmd" | head -n1)"
    fi
}

# ==============================================
# EJECUCIÓN PRINCIPAL
# ==============================================

show_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
    __ __               _   __      _         
   / //_/_  ______     / | / /   __(_)___ ___ 
  / ,< / / / / __ \   /  |/ / | / / / __ `__ \
 / /| / /_/ / /_/ /  / /|  /| |/ / / / / / / /
/_/ |_\__, /\____/  /_/ |_/ |___/_/_/ /_/ /_/ 
     /____/                                    
EOF
    echo -e "${NC}"
}

show_success() {
    echo -e "${GREEN}"
    cat << "EOF"
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⣶⣶⣾⣿⣿⣷⣶⣶⣶⣶⣦⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⡻⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠃⠻⢿⣿⣄⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠿⢛⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⢁⣀⣀⣀⣀⡀⠀⠙⢿⣦⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣥⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣷⣿⣿⣿⣿⣿⣿⣶⣄⠀⠙⢿⣿⣿⣿⣿⣿⣿⠹⣿⣿⠿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⣩⣥⣶⢶⣶⣦⡙⢦⡀⠙⢿⣿⣿⣿⣿⡇⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠈⣉⠁⠶⠀⠀⠉⠻⢦⡑⠄⠈⠻⣿⣿⡟⢡⣿⡇⣼⠏⣽⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⢡⡙⠀⠀⢀⠀⢀⣴⣦⠙⠀⠀⠀⠉⠙⢠⣿⡟⢰⣯⣼⣿⣿⣿⣿⣿⣿⢿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢶⡎⢹⣿⣧⣙⠲⠤⠤⣀⣛⣛⣉⣒⣓⡀⠀⣠⣾⣿⡟⠰⠿⠿⠿⠟⠛⠛⠉⠉⠀⣸⢀⠀⠀⠀
⠀⠀⠀⠀⢰⡿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣵⣤⣾⣿⣦⣼⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢀⣿⣾⣧⠀⠀
⠀⠀⠀⠀⣾⠏⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⢀⣄⣸⠈⣿⣿⣿⣦⠀
⠀⠀⠀⠀⣹⢰⣿⡿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠟⢿⣿⣿⣿⣿⣿⡄⠀⢠⣄⣠⣾⣿⣿⣏⡀⢹⣿⣿⣿⡄
⠀⠀⠀⠀⢹⢸⢹⡇⡇⣿⡟⣿⢸⡟⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢋⣴⣿⣿⢻⣿⣿⣿⣿⣿⡌⣆⡙⣿⣿⣿⡾⢿⡾⢨⣿⣿⣿⡁
⠀⠀⠀⠀⠀⠙⠾⡇⡇⣽⡇⠟⠘⠃⠁⣤⣰⢉⡿⣿⣿⣿⣿⣿⣿⣟⣿⣶⢌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣅⢾⠿⠋⠁⠻⣿⣿⣿⣿⣿⡷⠋⣐⣿⣿⢇⡷⠟⣠⣿⣿⣿⣿⡗
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣿⢸⡁⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡱⢙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣶⣤⣄⣄⢈⠻⠿⠛⣁⣄⣾⣿⡿⠣⡩⢃⡼⣿⡿⡏⡅⣿⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠄⡀⠙⣿⢰⢹⠈⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠙⡰⠆⢻⣿⣿⣿⢃⠍⢰⣿⣧⣧⣷⢗⣡⡿⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠄⢂⠡⠐⠠⠐⡀⠈⢻⣸⠆⣼⢹⣿⣿⣿⣿⣿⣿⣴⣿⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠐⢶⣾⠄⣿⣿⣟⡋⠀⠀⠀⠉⠉⠉⠉⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠄⢂⠐⡈⠄⠂⡁⢂⠡⢀⠡⠀⠘⢱⣏⢸⢸⠛⢿⣿⣿⣿⣿⡇⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣛⣩⣥⣶⣮⣄⣒⣊⡥⢶⣭⠁⠀⠄⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣴⡞⠃⠈⡄⠂⠐⠈⠐⠀⠂⠐⠀⠂⠁⠂⡄⠈⢻⣾⢸⢸⢹⢹⣿⣿⣴⣿⣿⣿⣿⣿⣿⣿⡟⠋⢡⠀⠙⠓⠛⠛⠋⠉⠉⠛⠉⠉⠛⠁⠀⠈⠐⠀⢡⠀⠀⠀⠀⠀⠀
⠀⠀⠀⡼⠋⠋⢀⠐⠠⠈⠄⡁⢂⠡⠈⠄⠡⢈⠐⠠⠐⠠⢀⠈⠺⢼⢸⢸⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣶⠲⣶⣾⣿⣿⣶⣶⡿⠟⠀⠠⠁⢂⠁⢂⠈⠄⠀⠀⠀⠀
⠀⢀⠂⡀⠐⡀⠂⠌⠠⢁⠂⡐⢀⠂⠡⢈⠐⠠⠈⠄⡁⠂⠄⠂⠄⡀⠈⠐⠺⢦⠙⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣥⣶⣶⣾⣿⣶⠀⠀⠄⡁⢂⠈⠄⠂⠌⡐⢀⠀⠀
⠀⠀⠂⠄⠡⢀⠡⢈⠐⡀⢂⠐⠠⢈⠐⠠⠈⠄⡁⠂⠄⠡⢈⠐⠠⢀⠁⠂⠀⠀⠀⠈⠻⡏⠉⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠈⠄⡐⠠⢈⠐⡈⠄⡐⠠⠀⠀
⠀⠀⠁⠌⡐⢀⠂⠄⢂⠐⠠⢈⠐⠠⠈⠄⡁⠂⠄⠡⢈⠐⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠺⠸⡌⣿⢻⣿⣿⣿⣿⣿⣿⣿⣿⠻⠿⠛⠉⠀⠠⢁⠂⠄⡁⢂⠐⡀⠂⠄⠡⠈⠀
⠀⠀⠀⠀⠀⠀⠈⠐⠠⠈⠐⠠⠈⠀⠁⠂⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠂⠂⠈⠐⠀⠂⠐⠀⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                                                                                                          
EOF
    echo -e "${NC}"
    echo -e "${YELLOW}Recomendación: Reinicia tu terminal para aplicar todos los cambios${NC}"
}

main() {
    show_banner
    log "INFO" "Iniciando instalación..."
    
    detect_distro
    install_basic_deps
    install_neovim
    install_lsp_servers
    setup_nvim_config
    
    log "INFO" "¡Instalación completada con éxito!"
    show_success
}

main "$@"

