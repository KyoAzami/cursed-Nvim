--██    ██ ██ ███    ███        ██████  ██████  ████████ ██  ██████  ███    ██ ███████ 
--██    ██ ██ ████  ████       ██    ██ ██   ██    ██    ██ ██    ██ ████   ██ ██      
--██    ██ ██ ██ ████ ██ █████ ██    ██ ██████     ██    ██ ██    ██ ██ ██  ██ ███████ 
-- ██  ██  ██ ██  ██  ██       ██    ██ ██         ██    ██ ██    ██ ██  ██ ██      ██ 
--  ████   ██ ██      ██        ██████  ██         ██    ██  ██████  ██   ████ ███████ 
                                                                                     
                                                                                     

--opciones generales que implementa el editor (heredadas de vim)

vim.cmd("set number")
vim.cmd("set mouse=a")
vim.cmd("syntax enable")
vim.cmd("set showcmd")
vim.cmd("set encoding=utf-8")
vim.cmd("set showmatch")
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")
vim.cmd("set autoindent")
vim.cmd("set smarttab")


--quitar los simbolos ~ de las lineas no numeradas

vim.opt.fillchars = { eob = " " }

