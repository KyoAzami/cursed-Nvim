--██      ███████ ██████
--██      ██      ██   ██
--██      ███████ ██████  
--██           ██ ██
--███████ ███████ ██     
                                                                             
                                                                             




return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      -- Configuración de LSP y autocompletado
      require("config.lsp")
    end,
  },
}
