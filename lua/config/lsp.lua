--██      ███████ ██████         ██████  ██████  ███    ██ ███████ ██  ██████  
--██      ██      ██   ██       ██      ██    ██ ████   ██ ██      ██ ██       
--██      ███████ ██████  █████ ██      ██    ██ ██ ██  ██ █████   ██ ██   ███ 
--██           ██ ██            ██      ██    ██ ██  ██ ██ ██      ██ ██    ██ 
--███████ ███████ ██             ██████  ██████  ██   ████ ██      ██  ██████  
                                                                            
-- Archivo: lua/config/lsp.lua
local lspconfig = require('lspconfig')
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Configuración de nvim-cmp para autocompletado
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- Configuración de los servidores LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = {
  'html',       -- HTML
  'cssls',      -- CSS
  'tsserver',   -- JavaScript/TypeScript
  'jdtls',      -- Java
  'rust_analyzer', -- Rust
  'clangd',     -- C/C++
  'asm_lsp',    -- Assembly
  'kotlin_language_server', -- Kotlin
  'gopls',      -- Go
  'intelephense', -- PHP
  'sqlls',      -- SQL
  'pyright',    -- Python
  'cobol_ls',   -- COBOL
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

-- Configuración adicional para Rust (opcional)
lspconfig.rust_analyzer.setup {
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        enable = true,
      },
    },
  },
}

-- Configuración adicional para Java (opcional)
lspconfig.jdtls.setup {
  cmd = { 'jdtls' },
  root_dir = lspconfig.util.root_pattern('pom.xml', 'build.gradle', '.git'),
}

-- Configuración adicional para Python (opcional)
lspconfig.pyright.setup {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}

-- Mapeos de teclas para LSP
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_buf_set_keymap(args.buf, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })
    end
    if client.server_capabilities.codeActionProvider then
      vim.api.nvim_buf_set_keymap(args.buf, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
    end
    if client.server_capabilities.hoverProvider then
      vim.api.nvim_buf_set_keymap(args.buf, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
    end
  end,
})
