--████████ ██   ██ ███████ ███    ███ ███████ 
--   ██    ██   ██ ██      ████  ████ ██      
--   ██    ███████ █████   ██ ████ ██ █████   
--   ██    ██   ██ ██      ██  ██  ██ ██      
--   ██    ██   ██ ███████ ██      ██ ███████ 
                                            
                                            

local M = {}

-- Lista de temas disponibles
M.themes = {
    "catppuccin",
    "tokyonight",
    "gruvbox",
    "everforest",
    "kanagawa",
    "nightfox",
    "nord",
    "onedark",
    "oxocarbon",
    "solarized"
}

-- Función para cambiar de tema

M.set_theme = function(theme)
    -- Intenta cargar el esquema de colores
    local ok, err = pcall(vim.cmd, "colorscheme " .. theme)
    if not ok then
        vim.notify("Error al aplicar el tema: " .. theme .. "\n" .. err, vim.log.levels.ERROR)
    else
        vim.notify("Tema aplicado correctamente: " .. theme, vim.log.levels.INFO)
    end
end


-- Selector de temas con Telescope
M.select_theme = function()
    local themes = M.themes
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers.new({}, {
        prompt_title = "Selecciona un Tema",
        finder = finders.new_table({ results = themes }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map)
            map("i", "<CR>", function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    M.set_theme(selection[1])
                end
                actions.close(prompt_bufnr)
            end)
            return true
        end
    }):find()
end

return M

