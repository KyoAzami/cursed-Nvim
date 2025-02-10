--███    ██ ██  ██████  ██   ██ ████████ ███████  ██████  ██   ██ 
--████   ██ ██ ██       ██   ██    ██    ██      ██    ██  ██ ██  
--██ ██  ██ ██ ██   ███ ███████    ██    █████   ██    ██   ███   
--██  ██ ██ ██ ██    ██ ██   ██    ██    ██      ██    ██  ██ ██  
--██   ████ ██  ██████  ██   ██    ██    ██       ██████  ██   ██ 
                                                                
                                                                

return {
    "EdenEast/nightfox.nvim",
    lazy = false,
    name = "nightfox",
    priority = 1000,
    config = function()
        require("nightfox").setup({})
        vim.cmd.colorscheme "nightfox"
    end
}

