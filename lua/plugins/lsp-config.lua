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
                    ["<C-Space>"] = cmp.mapping.complete(),  -- Invocar el autocompletado
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })  -- Confirmar selección si el menú está abierto
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()  -- Expandir snippet si es aplicable
                        else
                            fallback()  -- Si nada está disponible, simplemente inserta un salto de línea
                        end
                    end, { "i", "s" }),  -- Activo en modo insert y select
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
    { "rafamadriz/friendly-snippets" },

    -- Configuración de servidores LSP
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()  -- Obtener capacidades para autocompletado

            local on_attach = function(client, bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)  -- Mostrar información de símbolo
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)  -- Ir a la definición
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)  -- Ir a la implementación
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)  -- Renombrar variable/símbolo
            end

            -- Configuración automática de servidores LSP instalados con Mason
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,
            })
        end,
    },

    -- Instalador de servidores LSP
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
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
        end,
    },
}

