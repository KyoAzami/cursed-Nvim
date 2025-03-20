--██      ███████ ██████
--██      ██      ██   ██
--██      ███████ ██████  
--██           ██ ██
--███████ ███████ ██     
                                                                             
                                                                             

-- Archivo: lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "hrsh7th/nvim-cmp",         -- Autocompletado
      "hrsh7th/cmp-nvim-lsp",     -- Fuente de autocompletado para LSP
      "hrsh7th/cmp-buffer",       -- Autocompletado desde el buffer
      "hrsh7th/cmp-path",         -- Autocompletado para rutas
      "saadparwaiz1/cmp_luasnip", -- Integración con LuaSnip
      "L3MON4D3/LuaSnip",         -- Snippets
    },
    config = function()
      require("config.lsp") -- Cargar la configuración de LSP
    end,
  },
}
