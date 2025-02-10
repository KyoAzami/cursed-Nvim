--██   ██ ███████ ██    ██     ███    ███  █████  ██████  ███████ 
--██  ██  ██       ██  ██      ████  ████ ██   ██ ██   ██ ██      
--█████   █████     ████       ██ ████ ██ ███████ ██████  ███████ 
--██  ██  ██         ██        ██  ██  ██ ██   ██ ██           ██ 
--██   ██ ███████    ██        ██      ██ ██   ██ ██      ███████ 
     


      
--                         _           _            __                              __            ___ __            
--   ____ ___  ____ _   __(_)___ ___  (_)__  ____  / /_____     ___  ____     ___  / /  ___  ____/ (_) /_____  _____
--  / __ `__ \/ __ \ | / / / __ `__ \/ / _ \/ __ \/ __/ __ \   / _ \/ __ \   / _ \/ /  / _ \/ __  / / __/ __ \/ ___/
-- / / / / / / /_/ / |/ / / / / / / / /  __/ / / / /_/ /_/ /  /  __/ / / /  /  __/ /  /  __/ /_/ / / /_/ /_/ / /    
--/_/ /_/ /_/\____/|___/_/_/ /_/ /_/_/\___/_/ /_/\__/\____/   \___/_/ /_/   \___/_/   \___/\__,_/_/\__/\____/_/ 
--
--

vim.keymap.set("i", "<C-h>", "<Left>", { noremap = true, silent = true, desc = "Mover a la izquierda en modo insertar" })
vim.keymap.set("i", "<C-j>", "<Down>", { noremap = true, silent = true, desc = "Mover abajo en modo insertar" })
vim.keymap.set("i", "<C-k>", "<Up>", { noremap = true, silent = true, desc = "Mover arriba en modo insertar" })
vim.keymap.set("i", "<C-l>", "<Right>", { noremap = true, silent = true, desc = "Mover a la derecha en modo insertar" })
vim.keymap.set('n', '<C-h>', '<C-w>h', {})
vim.keymap.set('n', '<C-l>', '<C-w>l',{})
vim.keymap.set("i", "<C-e>", "<End>", { noremap = true, silent = true, desc = "Ir al final de la línea en modo insertar" })
vim.keymap.set("i", "<C-b>", "<Home>", { noremap = true, silent = true, desc = "Ir al inicio de la línea en modo insertar" })
vim.keymap.set("i", "<C-d>", "<Esc>ddi", { noremap = true, silent = true, desc = "Borrar toda la línea en modo insertar" })
vim.keymap.set("i", "<C-w>", "<C-o>daw", { noremap = true, silent = true, desc = "Borrar palabra antes del cursor" })
vim.keymap.set("n", "<leader>f", "/\\b<C-R><C-W>\\b<CR>", { noremap = true, silent = true, desc = "Buscar palabra completa bajo el cursor hacia adelante" })
vim.keymap.set("n", "<leader>b", "?\\b<C-R><C-W>\\b<CR>", { noremap = true, silent = true, desc = "Buscar palabra completa bajo el cursor hacia atrás" })vim.keymap.set("n", "<leader>n", "n", { noremap = true, silent = true, desc = "Buscar siguiente ocurrencia hacia adelante" })
vim.keymap.set("n", "<leader>p", "N", { noremap = true, silent = true, desc = "Buscar ocurrencia anterior hacia atrás" })
vim.keymap.set("n", "<leader>w", "/\\b<C-R><C-W>\\b<CR>", { noremap = true, silent = true, desc = "Buscar palabra completa bajo el cursor" })
vim.keymap.set("n", "<leader>r", "/\\v", { noremap = true, silent = true, desc = "Buscar con expresiones regulares" })
vim.keymap.set("n", "<leader>c", ":noh<CR>", { noremap = true, silent = true, desc = "Cancelar la búsqueda" })

vim.keymap.set("n", "<leader>e", ":e ", { noremap = true, silent = false, desc = "Editar archivo en el mismo buffer" })
vim.keymap.set("n", "<leader>v", ":vsplit | e ", { noremap = true, silent = false, desc = "Abrir archivo en split vertical" })
vim.keymap.set("n", "<leader>s", ":split | e ", { noremap = true, silent = false, desc = "Abrir archivo en split horizontal" })
vim.keymap.set("n", "<leader>t", ":tabedit ", { noremap = true, silent = false, desc = "Abrir archivo en una nueva pestaña" })

vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true, desc = "Siguiente buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Buffer anterior" })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true, desc = "Cerrar buffer actual" })
vim.keymap.set("n", "<leader>ba", ":%bd|e#|bd#<CR>", { noremap = true, silent = true, desc = "Cerrar todos los buffers excepto el actual" })
vim.keymap.set("n", "<leader>bl", ":ls<CR>", { noremap = true, silent = false, desc = "Listar buffers abiertos" })

vim.keymap.set("n", "<leader><leader>", "<C-^>", { noremap = true, silent = true, desc = "Alternar entre buffers" })

vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true, desc = "Abrir lista de buffers con Telescope" })



--         __          _                   __        __                           
--  ____ _/ /_____ _  (_)___  _____   ____/ /__     / /____  ____ ___  ____ ______
-- / __ `/ __/ __ `/ / / __ \/ ___/  / __  / _ \   / __/ _ \/ __ `__ \/ __ `/ ___/
--/ /_/ / /_/ /_/ / / / /_/ (__  )  / /_/ /  __/  / /_/  __/ / / / / / /_/ (__  ) 
--\__,_/\__/\__,_/_/ /\____/____/   \__,_/\___/   \__/\___/_/ /_/ /_/\__,_/____/  
--              /___/                                                            
--
--
    
vim.api.nvim_set_keymap("n", "<leader>tm", ":lua require('config.theme').select_theme()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tt", ":lua require('config.theme').set_theme('tokyonight')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tg", ":lua require('config.theme').set_theme('gruvbox')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tc", ":lua require('config.theme').set_theme('catppuccin')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>te", ":lua require('config.theme').set_theme('everforest')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tk", ":lua require('config.theme').set_theme('kanagawa')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tn", ":lua require('config.theme').set_theme('nightfox')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>to", ":lua require('config.theme').set_theme('onedark')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tx", ":lua require('config.theme').set_theme('oxocarbon')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ts", ":lua require('config.theme').set_theme('solarized')<CR>", { noremap = true, silent = true })


--                           _ __ 
--   ____  ___  ____  ____ _(_) /_
--  / __ \/ _ \/ __ \/ __ `/ / __/
-- / / / /  __/ /_/ / /_/ / / /_  
--/_/ /_/\___/\____/\__, /_/\__/  
--                 /____/        


vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Abrir Neogit" })
vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>", { desc = "Abrir commit en Neogit" })
vim.keymap.set("n", "<leader>gp", ":Neogit push<CR>", { desc = "Hacer push con Neogit" })
vim.keymap.set("n", "<leader>gf", ":Neogit pull<CR>", { desc = "Hacer pull con Neogit" })
vim.keymap.set("n", "<leader>gb", ":Neogit branch<CR>", { desc = "Abrir menú de ramas en Neogit" })


--       ___ ________      _             
--  ____/ (_) __/ __/   __(_)__ _      __
-- / __  / / /_/ /_| | / / / _ \ | /| / /
--/ /_/ / / __/ __/| |/ / /  __/ |/ |/ / 
--\__,_/_/_/ /_/   |___/_/\___/|__/|__/  
--

                                       
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Abrir Diffview" })
vim.keymap.set("n", "<leader>gq", ":DiffviewClose<CR>", { desc = "Cerrar Diffview" })
vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "Ver historial del archivo actual" })


--                           __               
--   ____  ___  ____        / /_________  ___ 
--  / __ \/ _ \/ __ \______/ __/ ___/ _ \/ _ \
-- / / / /  __/ /_/ /_____/ /_/ /  /  __/  __/
--/_/ /_/\___/\____/      \__/_/   \___/\___/ 
--
--
                                            
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Abrir/Cerrar Neo-tree" })
vim.keymap.set("n", "<leader>nf", ":Neotree focus<CR>", { desc = "Enfocar en Neo-tree" })
vim.keymap.set("n", "<leader>gs", ":Neotree source=git_status toggle<CR>", { desc = "Abrir estado de Git en Neo-tree" })


--          _ __       _                 
--   ____ _(_) /______(_)___ _____  _____
--  / __ `/ / __/ ___/ / __ `/ __ \/ ___/
-- / /_/ / / /_(__  ) / /_/ / / / (__  ) 
-- \__, /_/\__/____/_/\__, /_/ /_/____/  
--/____/             /____/                                                         
--
--

vim.keymap.set("n", "]g", function() require("gitsigns").next_hunk() end, { desc = "Siguiente cambio en Git" })
vim.keymap.set("n", "[g", function() require("gitsigns").prev_hunk() end, { desc = "Anterior cambio en Git" })
vim.keymap.set("n", "<leader>gk", function() require("gitsigns").preview_hunk() end, { desc = "Vista previa del cambio" })
vim.keymap.set("n", "<leader>ga", function() require("gitsigns").blame_line() end, { desc = "Ver autor de la línea actual" })
vim.keymap.set("n", "<leader>gr", function() require("gitsigns").reset_hunk() end, { desc = "Revertir cambio en Git" })


--   __                    __     __                    
--  / /_____  ____ _____ _/ /__  / /____  _________ ___ 
-- / __/ __ \/ __ `/ __ `/ / _ \/ __/ _ \/ ___/ __ `__ \
--/ /_/ /_/ / /_/ / /_/ / /  __/ /_/  __/ /  / / / / / /
--\__/\____/\__, /\__, /_/\___/\__/\___/_/  /_/ /_/ /_/ 
--         /____//____/                                
--
--

vim.keymap.set("n", "<C-\\>", ":ToggleTerm<CR>", { desc = "Abrir/Cerrar Terminal" })
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>:ToggleTerm<CR>", { desc = "Cerrar Terminal desde Terminal Mode" })
vim.keymap.set("n", "<leader>th", ":lua toggle_term_based_on_focus()<CR>", { noremap = true, silent = true, desc = "Abrir terminal horizontal dependiendo del foco" })
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", { noremap = true, silent = true, desc = "Abrir terminal vertical" })



