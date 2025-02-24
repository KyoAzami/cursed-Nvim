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
        },
        config = function()
            local cmp = require("cmp")
            
            -- Configuración de nvim-cmp
            cmp.setup({
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },      -- Fuente para sugerencias LSP
                    { name = "buffer" },        -- Fuente para sugerencias desde el buffer actual
                    { name = "path" },          -- Fuente para autocompletado de rutas de archivos
                }),
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),  -- Seleccionar siguiente ítem
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Seleccionar ítem anterior
                    ["<C-Space>"] = cmp.mapping.complete(),  -- Invocar el autocompletado
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Confirmar selección
                }),
            })
        end,
    },

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

