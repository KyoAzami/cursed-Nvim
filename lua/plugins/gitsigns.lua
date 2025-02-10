-- ██████  ██ ████████    ███████ ██  ██████  ███    ██ ███████ 
--██       ██    ██       ██      ██ ██       ████   ██ ██      
--██   ███ ██    ██ █████ ███████ ██ ██   ███ ██ ██  ██ ███████ 
--██    ██ ██    ██            ██ ██ ██    ██ ██  ██ ██      ██ 
-- ██████  ██    ██       ███████ ██  ██████  ██   ████ ███████ 
                                                              



return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }, -- Dependencia obligatoria
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      numhl = false, -- Habilita números resaltados en el margen
      linehl = false, -- Resalta las líneas cambiadas (opcional)
      current_line_blame = true, -- Muestra el autor y fecha de cada línea (tipo `git blame`)
    })
  end
}

