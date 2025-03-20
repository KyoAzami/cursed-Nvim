--██      ███████ ██████         ██████  ██████  ███    ██ ███████ ██  ██████  
--██      ██      ██   ██       ██      ██    ██ ████   ██ ██      ██ ██       
--██      ███████ ██████  █████ ██      ██    ██ ██ ██  ██ █████   ██ ██   ███ 
--██           ██ ██            ██      ██    ██ ██  ██ ██ ██      ██ ██    ██ 
--███████ ███████ ██             ██████  ██████  ██   ████ ██      ██  ██████  
                                                                            
-- Archivo: lua/config/lsp.lua
local lspconfig = require('lspconfig')
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Habilitar soporte de snippets en las capacidades del LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Configuración de autocompletado (nvim-cmp)
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- Usar LuaSnip para snippets
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Desplazar hacia arriba en la documentación
    ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- Desplazar hacia abajo en la documentación
    ['<C-e>'] = cmp.mapping.abort(),         -- Cerrar el menú de autocompletado
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirmar selección
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item() -- Seleccionar la siguiente sugerencia
      else
        fallback() -- Usar el comportamiento normal de <Tab>
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item() -- Seleccionar la sugerencia anterior
      else
        fallback() -- Usar el comportamiento normal de <S-Tab>
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- Autocompletado desde LSP
    { name = 'luasnip' },  -- Snippets desde LuaSnip
    { name = 'buffer' },   -- Autocompletado desde el buffer actual
    { name = 'path' },     -- Autocompletado para rutas de archivos
  }),
  -- Habilitar autocompletado automático
  completion = {
    autocomplete = {
      cmp.TriggerEvent.TextChanged, -- Activar autocompletado al cambiar el texto
    },
  },
})

-- Configuración de los servidores LSP
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
    capabilities = capabilities, -- Asegurar que los servidores LSP usen las capacidades de autocompletado
  }
end

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
