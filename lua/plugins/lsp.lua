--██      ███████ ██████
--██      ██      ██   ██
--██      ███████ ██████  
--██           ██ ██
--███████ ███████ ██     
                                                                             
                                                                             

return {
  {
    "neovim/nvim-lspconfig", -- Plugin principal para configurar servidores LSP
    event = "BufReadPre",     -- Cargar el plugin antes de abrir un archivo
    dependencies = {
      -- Autocompletado
      "hrsh7th/nvim-cmp",         -- Plugin principal para autocompletado
      "hrsh7th/cmp-nvim-lsp",     -- Fuente de autocompletado para LSP
      "hrsh7th/cmp-buffer",       -- Fuente de autocompletado desde el buffer actual
      "hrsh7th/cmp-path",         -- Fuente de autocompletado para rutas de archivos
      "saadparwaiz1/cmp_luasnip", -- Integración de snippets con LuaSnip

      -- Snippets
      "L3MON4D3/LuaSnip",         -- Motor de snippets

      -- Otras utilidades
      "williamboman/mason.nvim",  -- Gestor de servidores LSP, formateadores, linters, etc.
      "williamboman/mason-lspconfig.nvim", -- Integración de Mason con lspconfig
    },
    config = function()
      -- Cargar la configuración de LSP y autocompletado
      require("config.lsp")
    end,
  },

  -- Mason: Gestor de servidores LSP, formateadores, linters, etc.
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Integración de Mason con lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "html",       -- HTML
        "cssls",      -- CSS
        "jdtls",      -- Java
        "rust_analyzer", -- Rust
        "clangd",     -- C/C++
        "kotlin_language_server", -- Kotlin
        "gopls",      -- Go
        "intelephense", -- PHP
        "sqlls",      -- SQL
        "pyright",    -- Python
        "cobol_ls",   -- COBOL
      },
    },
  },

  -- LuaSnip: Motor de snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*", -- Usar la versión 2.x de LuaSnip
    build = "make install_jsregexp", -- Compilar dependencias adicionales
    dependencies = {
      "rafamadriz/friendly-snippets", -- Colección de snippets predefinidos
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load() -- Cargar snippets de VSCode
    end,
  },

  -- nvim-cmp: Autocompletado
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- Fuente de autocompletado para LSP
      "hrsh7th/cmp-buffer",       -- Fuente de autocompletado desde el buffer actual
      "hrsh7th/cmp-path",         -- Fuente de autocompletado para rutas de archivos
      "saadparwaiz1/cmp_luasnip", -- Integración de snippets con LuaSnip
    },
  },
}
