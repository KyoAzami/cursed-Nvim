--██████  ██ ███████ ███████ ██    ██ ██ ███████ ██     ██ 
--██   ██ ██ ██      ██      ██    ██ ██ ██      ██     ██ 
--██   ██ ██ █████   █████   ██    ██ ██ █████   ██  █  ██ 
--██   ██ ██ ██      ██       ██  ██  ██ ██      ██ ███ ██ 
--██████  ██ ██      ██        ████   ██ ███████  ███ ███  
                                                         
                                                         

return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }, -- Plenary es obligatorio
  config = function()
    require("diffview").setup({
      use_icons = true, -- Usa iconos si están disponibles
    })
  end,
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" }, -- Carga bajo demanda
}

