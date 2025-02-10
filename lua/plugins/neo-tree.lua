--███    ██ ███████  ██████     ████████ ██████  ███████ ███████ 
--████   ██ ██      ██    ██       ██    ██   ██ ██      ██      
--██ ██  ██ █████   ██    ██ █████ ██    ██████  █████   █████   
--██  ██ ██ ██      ██    ██       ██    ██   ██ ██      ██      
--██   ████ ███████  ██████        ██    ██   ██ ███████ ███████ 
                                                               
                                                               

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    hide_dotfiles = true,  -- Ajusta según tu preferencia
                },
                use_libuv_file_watcher = true, -- Refresca automáticamente los cambios
            },
            window = {
                width = 30,  -- Tamaño de la ventana de Neo-tree
            },
            show_line_numbers = false,
      
            git_status = {
                symbols = {
                    added     = "✚", -- Archivos añadidos
                    modified  = "", -- Archivos modificados
                    deleted   = "✖", -- Archivos eliminados
                    renamed   = "➜", -- Archivos renombrados
                    untracked = "★", -- Archivos nuevos sin seguimiento
                    ignored   = "◌", -- Archivos ignorados
                    unstaged  = "✗", -- Cambios sin "staging"
                    staged    = "✓", -- Cambios preparados para commit
                    conflict  = "", -- Conflictos de Git
                },
            },


                  
            default_component_configs = {
                git_status = {
                    symbols = {
                        added     = "✚",
                        modified  = "",
                        deleted   = "✖",
                        renamed   = "➜",
                        untracked = "★",
                    },
                },
            },


        })
    end
}

