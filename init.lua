-- ██████  ██████  ███    ██ ███████ ██  ██████  ██    ██ ██████   █████   ██████ ██  ██████  ███    ██ 
--██      ██    ██ ████   ██ ██      ██ ██       ██    ██ ██   ██ ██   ██ ██      ██ ██    ██ ████   ██ 
--██      ██    ██ ██ ██  ██ █████   ██ ██   ███ ██    ██ ██████  ███████ ██      ██ ██    ██ ██ ██  ██ 
--██      ██    ██ ██  ██ ██ ██      ██ ██    ██ ██    ██ ██   ██ ██   ██ ██      ██ ██    ██ ██  ██ ██ 
-- ██████  ██████  ██   ████ ██      ██  ██████   ██████  ██   ██ ██   ██  ██████ ██  ██████  ██   ████ 
                                                                                                      
                                                                                                      

--                          __               __         
--   ____ ___  ____ _____  / /__  ____ _____/ /__  _____
--  / __ `__ \/ __ `/ __ \/ / _ \/ __ `/ __  / _ \/ ___/
-- / / / / / / /_/ / /_/ / /  __/ /_/ / /_/ /  __/ /    
--/_/ /_/ /_/\__,_/ .___/_/\___/\__,_/\__,_/\___/_/     
--               /_/                                    


vim.g.mapleader = " "
vim.g.maplocalleader = ",,"




--    ____                          __             __                        __    _                 
--   / / /___ _____ ___  ____ _____/ /___     ____/ /__     ____ ___________/ /_  (_)   ______  _____
--  / / / __ `/ __ `__ \/ __ `/ __  / __ \   / __  / _ \   / __ `/ ___/ ___/ __ \/ / | / / __ \/ ___/
-- / / / /_/ / / / / / / /_/ / /_/ / /_/ /  / /_/ /  __/  / /_/ / /  / /__/ / / / /| |/ / /_/ (__  ) 
--/_/_/\__,_/_/ /_/ /_/\__,_/\__,_/\____/   \__,_/\___/   \__,_/_/   \___/_/ /_/_/ |___/\____/____/  



--Llmado al archivo de opciones
require("vim-options")


--Llmado al archivo de configuracion de lazy
require("config.lazy")


--Cargar el selector de temas
local theme = require("config.theme")
theme.set_theme("everforest")  --Cambia "everforest" por el tema que mas te agrade para cargar como el predeterminado


--Llamado al archivo de keymaps
require("keymaps")



--                         ____            __             __        ___                      
--   ________  _________ _/ / /_____ _____/ /___     ____/ /__     / (_)___  ___  ____ ______
--  / ___/ _ \/ ___/ __ `/ / __/ __ `/ __  / __ \   / __  / _ \   / / / __ \/ _ \/ __ `/ ___/
-- / /  /  __(__  ) /_/ / / /_/ /_/ / /_/ / /_/ /  / /_/ /  __/  / / / / / /  __/ /_/ (__  ) 
--/_/   \___/____/\__,_/_/\__/\__,_/\__,_/\____/   \__,_/\___/  /_/_/_/ /_/\___/\__,_/____/  



vim.o.cursorline = true  -- Activa el resaltado de la línea activa
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    vim.o.cursorline = true  -- Asegura que se habilite también en el modo insertar
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    vim.o.cursorline = true  -- Asegura que siga habilitado cuando regreses al modo normal
  end,
})


