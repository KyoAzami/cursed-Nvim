-- ██████  ███    ██ ███████ ██████   █████  ██████  ██   ██ 
--██    ██ ████   ██ ██      ██   ██ ██   ██ ██   ██ ██  ██  
--██    ██ ██ ██  ██ █████   ██   ██ ███████ ██████  █████   
--██    ██ ██  ██ ██ ██      ██   ██ ██   ██ ██   ██ ██  ██  
-- ██████  ██   ████ ███████ ██████  ██   ██ ██   ██ ██   ██ 
                                                           
                                                                                                                      

return {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    name = "onedark",
    config = function()
        require("onedark").setup({
            style = "dark", -- "darker", "cool", "deep", "warm", "warmer"
        })
        vim.cmd.colorscheme "onedark"
    end
}

