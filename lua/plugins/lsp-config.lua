--██      ███████ ██████         ██████  ██████  ███    ██ ███████ ██  ██████  
--██      ██      ██   ██       ██      ██    ██ ████   ██ ██      ██ ██       
--██      ███████ ██████  █████ ██      ██    ██ ██ ██  ██ █████   ██ ██   ███ 
--██           ██ ██            ██      ██    ██ ██  ██ ██ ██      ██ ██    ██ 
--███████ ███████ ██             ██████  ██████  ██   ████ ██      ██  ██████  
                                                                             
                                                                             


return {
    -- Autocompletado principal
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",  -- Integración con LSP
            "hrsh7th/cmp-buffer",    -- Autocompletado desde el buffer
            "hrsh7th/cmp-path",      -- Autocompletado de rutas
            "hrsh7th/cmp-cmdline",   -- Autocompletado en la línea de comandos
            "saadparwaiz1/cmp_luasnip", -- Soporte para snippets
            "L3MON4D3/LuaSnip",      -- Motor de snippets
            "rafamadriz/friendly-snippets", -- Snippets preconfigurados
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- Cargar snippets de VSCode (si usas los snippets de VSCode)
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Configuración de nvim-cmp
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)  -- Usar luasnip para expandir snippets
                    end,
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },      -- Fuente para sugerencias LSP
                    { name = "luasnip" },       -- Fuente para snippets
                    { name = "buffer" },        -- Fuente para sugerencias desde el buffer actual
                    { name = "path" },          -- Fuente para autocompletado de rutas de archivos
                }),
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),  -- Seleccionar siguiente ítem
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Seleccionar ítem anterior
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Confirmar selección
                    ["<C-Space>"] = cmp.mapping.complete(),  -- Invocar el autocompletado
                }),
            })
        end,
    },

    -- Snippets con LuaSnip
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp", -- Asegurarse de que se instalen las dependencias de JS RegExp para LuaSnip
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()  -- Cargar snippets de VSCode
        end,
    },

    -- Colección de snippets para HTML, CSS, JavaScript, etc.
    {
        "rafamadriz/friendly-snippets",
    },

    -- Configuración de servidores LSP, incluyendo Emmet para HTML/CSS/JS
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()  -- Obtener capacidades para autocompletado

            -- Configuración de servidores LSP (asegurarse de que todos los servidores estén configurados)
            local servers = {
                "lua_ls", "bashls", "clangd", "html", "cssls", "pyright", 
                "jdtls", "rust_analyzer", "gopls", "texlab", "emmet_ls"
            }

            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = capabilities,  -- Integrar capacidades de autocompletado
                })
            end

            -- Configuración específica de Emmet para HTML y CSS
            lspconfig.emmet_ls.setup({
                filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
                init_options = {
                    html = {
                        options = {
                            ["bem.enabled"] = true,  -- Activar soporte BEM para Emmet
                        },
                    },
                },
            })
        end,
    },

    -- Instalar servidores LSP a través de Mason (asegurando que estén instalados automáticamente)
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },

    -- Integración con mason-lspconfig para configurar automáticamente los servidores LSP
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls", "clangd", "cssls", "html", "bashls", "pyright", 
                    "jdtls", "rust_analyzer", "gopls", "texlab", "emmet_ls"
                },
                automatic_installation = true,  -- Instalar automáticamente los servidores que no están instalados
            })
        end
    },
}

