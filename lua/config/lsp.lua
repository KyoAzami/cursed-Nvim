--██      ███████ ██████         ██████  ██████  ███    ██ ███████ ██  ██████  
--██      ██      ██   ██       ██      ██    ██ ████   ██ ██      ██ ██       
--██      ███████ ██████  █████ ██      ██    ██ ██ ██  ██ █████   ██ ██   ███ 
--██           ██ ██            ██      ██    ██ ██  ██ ██ ██      ██ ██    ██ 
--███████ ███████ ██             ██████  ██████  ██   ████ ██      ██  ██████  

local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Configuración de Mason
mason.setup({
  ui = {
    border = 'rounded',
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- Configuración de mason-lspconfig
mason_lspconfig.setup({
  ensure_installed = {
    'lua_ls', 'pyright', 'rust_analyzer', 'typescript-language-server', 'clangd', 'gopls',
    'jdtls', 'kotlin_language_server', 'intelephense', 'cobol_ls',
    'html', 'cssls', 'jsonls', 'yamlls', 'emmet_ls',
    'bashls', 'powershell_es',
    'sqlls', 'sqls',
    'dockerls', 'terraformls', 'tflint', 'vimls'
  },
  automatic_installation = true
})

-- Capacidades mejoradas de autocompletado
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem = {
  snippetSupport = true,
  resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits'
    }
  }
}

-- Configuración de nvim-cmp
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
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- Función común on_attach
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>lf', function()
    vim.lsp.buf.format({ async = true, timeout_ms = 5000 })
  end, opts)

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
    vim.api.nvim_create_autocmd('CursorHold', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references
    })
  end
end

-- Configuración específica para cada servidor LSP
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false }
      }
    }
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true
        }
      }
    }
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" }
      }
    }
  },
  ts_ls = {
    settings = {
      completions = { completeFunctionCalls = true }
    }
  },
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=never"
    }
  },
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true, shadow = true },
        staticcheck = true
      }
    }
  },
  jdtls = {
    cmd = { 'jdtls' },
    root_dir = lspconfig.util.root_pattern('pom.xml', 'build.gradle', '.git')
  },
  kotlin_language_server = {},
  intelephense = {
    settings = {
      intelephense = {
        files = { maxSize = 5000000 }
      }
    }
  },
  cobol_ls = {
    cmd = { "cobol-lsp" },
    filetypes = { "cobol" }
  },
  sqlls = {
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    filetypes = { "sql", "mysql" }
  },
  sqls = {},
  html = {
    filetypes = { 'html', 'htmldjango' }
  },
  cssls = {},
  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true }
      }
    }
  },
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://json.schemastore.org/github-action.json"] = "/.github/action.{yml,yaml}",
          ["https://json.schemastore.org/ansible-playbook.json"] = "playbook.{yml,yaml}"
        }
      }
    }
  },
  emmet_ls = {},
  bashls = {},
  powershell_es = {
    cmd = {
      vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/PowerShellEditorServices/Start-EditorServices.ps1"
    },
    filetypes = { "ps1" },
    settings = {
      powershell = {
        codeFormatting = { Preset = "Allman" }
      }
    }
  },
  dockerls = {},
  terraformls = {},
  tflint = {},
  vimls = {}
}

-- Registrar cada servidor
for server, config in pairs(servers) do
  local final_config = vim.tbl_deep_extend('force', {
    capabilities = capabilities,
    on_attach = on_attach,
  }, config or {})

  lspconfig[server].setup(final_config)
end

-- Configuración de diagnósticos
vim.diagnostic.config({
  virtual_text = { prefix = '●', spacing = 4 },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Tooltip de diagnósticos flotantes
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end
})

