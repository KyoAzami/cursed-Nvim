--██      ███████ ██████         ██████  ██████  ███    ██ ███████ ██  ██████  
--██      ██      ██   ██       ██      ██    ██ ████   ██ ██      ██ ██       
--██      ███████ ██████  █████ ██      ██    ██ ██ ██  ██ █████   ██ ██   ███ 
--██           ██ ██            ██      ██    ██ ██  ██ ██ ██      ██ ██    ██ 
--███████ ███████ ██             ██████  ██████  ██   ████ ██      ██  ██████  
                                                                             
                                                                             


return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp"
        },
        config = function()
            local lspconfig = require'lspconfig'
            local cmp = require'cmp'
            local cmp_nvim_lsp = require'cmp_nvim_lsp'

            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- Servidores LSP para diferentes lenguajes
            local servers = {
                'html', 'cssls', 'eslint', 'jsonls', 'vuels', 'svelte', 'tailwindcss', -- Desarrollo web
                'gopls', 'rust_analyzer', 'jdtls', 'clangd', 'csharp_ls', 'asm_lsp', 'cobol_ls', -- Lenguajes específicos
                'phpactor', 'pyright', 'lua_ls', 'bashls' -- Otros lenguajes comunes
            }

            for _, server in ipairs(servers) do
                lspconfig[server].setup {
                    capabilities = capabilities
                }
            end
        end
    }
}


