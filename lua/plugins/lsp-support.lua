--██      ███████ ██████        ███████ ██    ██ ██████  ██████   ██████  ██████  ████████ 
--██      ██      ██   ██       ██      ██    ██ ██   ██ ██   ██ ██    ██ ██   ██    ██    
--██      ███████ ██████  █████ ███████ ██    ██ ██████  ██████  ██    ██ ██████     ██    
--██           ██ ██                 ██ ██    ██ ██      ██      ██    ██ ██   ██    ██    
--███████ ███████ ██            ███████  ██████  ██      ██       ██████  ██   ██    ██    
                                                                                         
                                                                                         

return{
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require('lspconfig')
        
        -- Configuración del servidor LSP para diferentes lenguajes
        lspconfig.pyright.setup{}  -- Python
        lspconfig.jdtls.setup{}  -- Java
        -- Agrega más servidores LSP para los lenguajes que uses
    end
}

