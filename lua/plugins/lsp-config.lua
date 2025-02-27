--██      ███████ ██████         ██████  ██████  ███    ██ ███████ ██  ██████  
--██      ██      ██   ██       ██      ██    ██ ████   ██ ██      ██ ██       
--██      ███████ ██████  █████ ██      ██    ██ ██ ██  ██ █████   ██ ██   ███ 
--██           ██ ██            ██      ██    ██ ██  ██ ██ ██      ██ ██    ██ 
--███████ ███████ ██             ██████  ██████  ██   ████ ██      ██  ██████  
                                                                             
                                                                             




return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",       -- Plugin para autocompletado
            "hrsh7th/cmp-nvim-lsp",   -- Integración de LSP con nvim-cmp
            "L3MON4D3/LuaSnip",       -- Plugin de snippets
        },
        config = function()
            local lspconfig = require('lspconfig')
            local cmp = require('cmp')
            local cmp_nvim_lsp = require('cmp_nvim_lsp')
            local mason_lspconfig = require('mason-lspconfig')

            -- Configuración de capacidades de autocompletado
            local capabilities = cmp_nvim_lsp.default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            -- Lista de servidores LSP
            local servers = {
                'html', 'cssls', 'eslint', 'jsonls', 'vuels', 'svelte', 'tailwindcss',
                'gopls', 'rust_analyzer', 'jdtls', 'clangd', 'cobol_ls',
                'phpactor', 'pyright', 'lua_ls', 'bashls'
            }

            -- Instalar servidores LSP automáticamente con Mason
            mason_lspconfig.setup({
                ensure_installed = servers,
                automatic_installation = true,  -- Instalar servidores automáticamente
            })

            -- Configuración de cada servidor LSP
            for _, server in ipairs(servers) do
                local server_opts = {
                    capabilities = capabilities
                }

                -- Configuraciones especiales según el servidor
                if server == 'html' then
                    server_opts.cmd = { "~/.local/share/nvim/mason/bin/vscode-html-language-server", "--stdio" }
                elseif server == 'tailwindcss' then
                    server_opts.cmd = { "~/.local/share/nvim/mason/bin/tailwindcss-language-server", "--stdio" }
                end

                lspconfig[server].setup(server_opts)
            end

            -- Configuración de nvim-cmp
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)  -- Usar LuaSnip para snippets
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),  -- Completado con Ctrl+Espacio
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Confirmar selección con Enter
                    ['<C-e>'] = cmp.mapping.abort(),  -- Cancelar completado
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },  -- Fuente de completado de LSP
                }, {
                    { name = 'luasnip' },  -- Fuente de snippets
                }),
            })

            -- Habilitar autocompletado al abrir archivos
            vim.cmd([[autocmd FileType * lua require('cmp').setup.buffer({})]])
        end
    }
}

