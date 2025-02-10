--████████  ██████   ██████   ██████  ██      ███████ ████████ ███████ ██████  ███    ███ 
--   ██    ██    ██ ██       ██       ██      ██         ██    ██      ██   ██ ████  ████ 
--   ██    ██    ██ ██   ███ ██   ███ ██      █████      ██    █████   ██████  ██ ████ ██ 
--   ██    ██    ██ ██    ██ ██    ██ ██      ██         ██    ██      ██   ██ ██  ██  ██ 
--   ██     ██████   ██████   ██████  ███████ ███████    ██    ███████ ██   ██ ██      ██ 
                                                                                        
                                                                                        

return {
  "akinsho/toggleterm.nvim",
  version = "*", -- Siempre usa la última versión estable
  config = function()
        require("toggleterm").setup({
            size = function(term)
                if term.direction == "horizontal" then
                          return 15 -- Altura de la terminal    
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4 -- Ancho de la terminal
                end
            end,
            open_mapping = [[<C-\>]], -- Atajo para abrir/cerrar terminal
            shading_factor = 2,
            direction = "horizontal",
            persist_size = true,
            close_on_exit = true,
            shell = vim.o.shell,
        })
        function _G.toggle_term_based_on_focus()
            local neotree_open = vim.fn.bufname():match("NvimTree") -- Verifica si Neo-tree está abierto
            if neotree_open then
                vim.cmd("wincmd l") -- Mueve el foco al buffer de código antes de abrir la terminal
            end
            vim.cmd("ToggleTerm direction=horizontal") -- Abre terminal horizontal
        end
    end
}

