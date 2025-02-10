--███████ ██    ██ ███████ ██████  ███████  ██████  ██████  ███████ ███████ ████████ 
--██      ██    ██ ██      ██   ██ ██      ██    ██ ██   ██ ██      ██         ██    
--█████   ██    ██ █████   ██████  █████   ██    ██ ██████  █████   ███████    ██    
--██       ██  ██  ██      ██   ██ ██      ██    ██ ██   ██ ██           ██    ██    
--███████   ████   ███████ ██   ██ ██       ██████  ██   ██ ███████ ███████    ██    


return {
    "sainnhe/everforest",
    lazy = false,
    name = "everforest",
    priority = 1000,
    config = function()
        vim.g.everforest_background = "soft" -- "hard", "medium", "soft"
        vim.g.everforest_transparent_background = 1
        vim.cmd.colorscheme "everforest"
    end
}

