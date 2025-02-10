--███    ██ ███████  ██████         ██████  ██ ████████ 
--████   ██ ██      ██    ██       ██       ██    ██    
--██ ██  ██ █████   ██    ██ █████ ██   ███ ██    ██    
--██  ██ ██ ██      ██    ██       ██    ██ ██    ██    
--██   ████ ███████  ██████         ██████  ██    ██    
                                                      
                                                      

return{
    "NeogitOrg/neogit",
    dependecies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
        require("neogit").setup()
    end
}
