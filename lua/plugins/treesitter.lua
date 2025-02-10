--████████ ██████  ███████ ███████ ███████ ██ ████████ ████████ ███████ ██████  
--   ██    ██   ██ ██      ██      ██      ██    ██       ██    ██      ██   ██ 
--   ██    ██████  █████   █████   ███████ ██    ██       ██    █████   ██████  
--   ██    ██   ██ ██      ██           ██ ██    ██       ██    ██      ██   ██ 
--   ██    ██   ██ ███████ ███████ ███████ ██    ██       ██    ███████ ██   ██ 
                                                                              
                                                                              

return {
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = {"lua", "c", "javascript", "php", "rust", "cpp", "luadoc", "printf", "vim", "vimdoc" },
            highlight = { enable = true, use_languagetree = true, },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn", -- Iniciar selección incremental
                    node_incremental = "grn", -- Expandir selección
                    node_decremental = "grm", -- Reducir selección
                    scope_incremental = "grc", -- Expandir a la región más cercana
                    },
            },
        })
    end
}
