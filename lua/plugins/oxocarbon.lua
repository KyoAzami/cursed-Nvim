-- ██████  ██   ██  ██████   ██████  █████  ██████  ██████   ██████  ███    ██ 
--██    ██  ██ ██  ██    ██ ██      ██   ██ ██   ██ ██   ██ ██    ██ ████   ██ 
--██    ██   ███   ██    ██ ██      ███████ ██████  ██████  ██    ██ ██ ██  ██ 
--██    ██  ██ ██  ██    ██ ██      ██   ██ ██   ██ ██   ██ ██    ██ ██  ██ ██ 
-- ██████  ██   ██  ██████   ██████ ██   ██ ██   ██ ██████   ██████  ██   ████ 
                                                                             
                                                                             

return {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    name = "oxocarbon",
    priority = 1000,
    config = function()
        vim.cmd.colorscheme "oxocarbon"
    end
}

