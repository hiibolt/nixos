{
    config,
    pkgs,
    unstable-pkgs,
    hostname,
    uses_plasma
}:
{   
    neovim = {
        enable = true;
        extraPackages = with pkgs; [ 
            code-minimap
        ] ++ [
            unstable-pkgs.rust-analyzer
        ];
        extraLuaPackages = ps: [ ];
        extraConfig = ''
            set number
            syntax enable
            colorscheme catppuccin-frappe
            '';
        extraLuaConfig = ''
            require("bufferline").setup()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true }
            })
            require('transparent').setup({})
            require("neocord").setup({})
            '';
        plugins = with pkgs.vimPlugins; [
            catppuccin-nvim
            bufferline-nvim
            nvim-treesitter.withAllGrammars
            nvim-web-devicons
            transparent-nvim
            neocord
            rustaceanvim
        ];
    };
    git = {
        enable = true;
        settings = {
            user = {
                name = "hiibolt";
                email = "me@hiibolt.com";
            };
        };
    };
    gh = {
        enable = true;
        settings = {
            version = "1";
            git_protocol = "https";
            editor = "";
            prompt = "enabled";
            pager = "";
            aliases = {
                co = "pr checkout";
            };
            http_unix_socket = "";
            browser = "";
        };
    };
}
