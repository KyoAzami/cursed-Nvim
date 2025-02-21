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
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {"lua_ls", "clangd", "cssls", "html", "bashls", "pyright", "jdtls", "rust_analyzer", "gopls", "texlab"},
                automatic_installation = true,  -- Esto asegura que los servidores se instalen automáticamente
            })

            -- Esto asegura que los servidores LSP se configuren al abrir archivos del tipo adecuado
            local lspconfig = require('lspconfig')
            local servers = { "lua_ls", "bashls", "clangd", "html", "cssls", "pyright", "jdtls", "rust_analyzer", "gopls", "texlab" }

            for _, server in ipairs(servers) do
                -- Llama al servidor LSP correspondiente y configura sus capacidades
                lspconfig[server].setup({
                    capabilities = require('cmp_nvim_lsp').default_capabilities(),
                    on_attach = function(client, bufnr)
                    end,
                })
            end
        end
    },
    {
        "neovim/nvim-lspconfig",  --la integración con mason-lspconfig se puede hacer aquí
        config = function()
        end
    }
}

