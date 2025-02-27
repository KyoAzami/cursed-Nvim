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
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp"
        },
        config = function()
            local lspconfig = require'lspconfig'
            local cmp = require'cmp'
            local cmp_nvim_lsp = require'cmp_nvim_lsp'
            local mason_lspconfig = require'mason-lspconfig'

            local capabilities = cmp_nvim_lsp.default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            -- Lista de servidores LSP
            local servers = {
                'html', 'cssls', 'eslint', 'jsonls', 'vuels', 'svelte', 'tailwindcss', -- Desarrollo web
                'gopls', 'rust_analyzer', 'jdtls', 'clangd', 'csharp_ls', 'asm_lsp', 'cobol_ls', -- Lenguajes específicos
                'phpactor', 'pyright', 'lua_ls', 'bashls' -- Otros lenguajes comunes
            }

            -- Instalar servidores LSP automáticamente con Mason
            mason_lspconfig.setup {
                ensure_installed = servers
            }

            -- Configuración de cada servidor LSP
            for _, server in ipairs(servers) do
                lspconfig[server].setup {
                    capabilities = capabilities
                }
            end
        end
    }
}


