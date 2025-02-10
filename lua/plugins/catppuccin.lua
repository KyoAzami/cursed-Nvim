-- ██████  █████  ████████ ██████  ██████  ██    ██  ██████  ██████ ██ ███    ██ 
--██      ██   ██    ██    ██   ██ ██   ██ ██    ██ ██      ██      ██ ████   ██ 
--██      ███████    ██    ██████  ██████  ██    ██ ██      ██      ██ ██ ██  ██ 
--██      ██   ██    ██    ██      ██      ██    ██ ██      ██      ██ ██  ██ ██ 
-- ██████ ██   ██    ██    ██      ██       ██████   ██████  ██████ ██ ██   ████ 
                                                                               
                                                                               

return{
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
        local ok, catppuccin = pcall(require, "catppuccin")
        if not ok then
            vim.notify("Error al cargar Catppuccin", vim.log.levels.ERROR)
            return
        end
        catppuccin.setup({
            transparent_background = true,
        })
        vim.cmd.colorscheme "catppuccin"
    end
}

