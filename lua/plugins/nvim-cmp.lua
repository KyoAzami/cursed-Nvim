--███    ██ ██    ██ ██ ███    ███        ██████ ███    ███ ██████  
--████   ██ ██    ██ ██ ████  ████       ██      ████  ████ ██   ██ 
--██ ██  ██ ██    ██ ██ ██ ████ ██ █████ ██      ██ ████ ██ ██████  
--██  ██ ██  ██  ██  ██ ██  ██  ██       ██      ██  ██  ██ ██      
--██   ████   ████   ██ ██      ██        ██████ ██      ██ ██      
                                                                  
                                                                  

return{
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        local cmp = require('cmp')

        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#expand"]{args.body}
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = {
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'luasnip' },  -- Si usas snippets
            },
        })
    end
}

