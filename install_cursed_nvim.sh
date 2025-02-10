#!/bin/bash

# Función para mostrar mensajes de error y salir
function error_exit {
    echo "Error: $1" >&2
    exit 1
}

# Verificar si Git está instalado
if ! command -v git &> /dev/null; then
    error_exit "Git no está instalado. Por favor, instálalo e intenta nuevamente."
fi

# Verificar si Neovim está instalado
if ! command -v nvim &> /dev/null; then
    error_exit "Neovim no está instalado. Por favor, instálalo e intenta nuevamente."
fi

# Directorio de configuración de Neovim
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Crear el directorio de configuración si no existe
mkdir -p "$NVIM_CONFIG_DIR"

# Clonar el repositorio en el directorio de configuración de Neovim
git clone https://github.com/KyoAzami/cursed-Nvim.git "$NVIM_CONFIG_DIR" || error_exit "No se pudo clonar el repositorio."

# Cambiar al directorio de configuración de Neovim
cd "$NVIM_CONFIG_DIR" || error_exit "No se pudo acceder al directorio $NVIM_CONFIG_DIR."

# Instalar los plugins utilizando el gestor de plugins especificado en tu configuración
# Este ejemplo asume que estás usando 'lazy.nvim' como gestor de plugins
# Si usas otro gestor, ajusta el comando en consecuencia

# Verificar si 'lazy.nvim' está instalado
if [ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
    echo "Instalando 'lazy.nvim'..."
    git clone https://github.com/folke/lazy.nvim.git "$HOME/.local/share/nvim/lazy/lazy.nvim" || error_exit "No se pudo clonar 'lazy.nvim'."
fi

# Instalar los plugins
nvim --headless +Lazy! sync +qa || error_exit "No se pudieron instalar los plugins."

echo "Instalación completada con éxito."

