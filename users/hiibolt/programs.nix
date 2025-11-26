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
        userName = "hiibolt";
        userEmail = "me@hiibolt.com";
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
    vscode = {
        enable = true;
        package = unstable-pkgs.vscode;
        extensions = with unstable-pkgs.vscode-extensions; [
            # Language Support
            bbenoist.nix
            rust-lang.rust-analyzer

            # Design
            leonardssh.vscord
        ]  ++ unstable-pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
                name="copilot";
                publisher="GitHub";
                version="1.383.1811";
                sha256="sha256-XDWYy65u6edMcA1mrqlYJ/TAlq1W5SEA3TLRlGxCIaM=";
            }
            {
                name="copilot-chat";
                publisher="GitHub";
                version="0.32.0";
                sha256="sha256-0B4ZJd2D+GY2CpVB4gyJ3NHiLS1HiG948Ycu7UCysF0=";
            }
            {
                name = "remote-ssh";
                publisher = "ms-vscode-remote";
                version = "0.115.0";
                sha256 = "CUGzDEZIqIJqGmA+ymZTbcA7DPRF6fj37WW7CnRHkPE=";
            }
            {
                name = "vscode-sshfs";
                publisher = "Kelvin";
                version = "1.26.1";
                sha256 = "WO9vYELNvwmuNeI05sUBE969KAiKYtrJ1fRfdZx3OYU=";
            }
            {
                name = "glassit";
                publisher = "s-nlf-fh";
                version = "0.2.6";
                sha256 = "LcAomgK91hnJWqAW4I0FAgTOwr8Kwv7ZhvGCgkokKuY=";
            }
            {
                name = "remote-explorer";
                publisher = "ms-vscode";
                version = "0.5.2024081309";
                sha256 = "YExf9Yyo7Zp0Nfoap8Vvtas11W9Czslt55X9lb/Ri3s=";
            }
            {
                name = "vscode-remote-extensionpack";
                publisher = "ms-vscode-remote";
                version = "0.25.0";
                sha256 = "CleLZvH40gidW6fqonZv/E/VO8IDI+QU4Zymo0n35Ns=";
            }
            {
                name = "cpptools";
                publisher = "ms-vscode";
                version = "1.23.6";
                sha256 = "4wU4zoddbJVGvYO7VLORB1nrqfXXXynUG+VyM5rdw/U=";
            }
        ];
        userSettings = {
            "chat.editor.fontFamily" = pkgs.lib.mkForce  "DejaVu Sans Mono";
            "chat.editor.fontSize" = pkgs.lib.mkForce 14.0;
            "debug.console.fontFamily" = pkgs.lib.mkForce "DejaVu Sans Mono";
            "debug.console.fontSize" = pkgs.lib.mkForce 14.0;
            "editor.fontFamily" = pkgs.lib.mkForce "'DejaVu Sans Mono'";
            "editor.fontSize" = pkgs.lib.mkForce 14.0;
            "editor.inlayHints.fontFamily" = pkgs.lib.mkForce "DejaVu Sans Mono";
            "editor.inlineSuggest.fontFamily" = pkgs.lib.mkForce "DejaVu Sans Mono";
            "editor.minimap.sectionHeaderFontSize" = 10.285714285714286;
            "workbench.colorTheme" = "Stylix";
            "git.autofetch" = true;
            "security.workspace.trust.enabled" = false;
            "git.openRepositoryInParentFolders" = "always";
            "extensions.ignoreRecommendations" = true;
            "remote.SSH.useLocalServer" = false;

            # Extensions
            ## Glassit
            "glassit.alpha" = 235;

            ## Discord RPC
            "vscord.status.details.text.idle" = "honk shoo mimimi";
            "vscord.status.details.text.notInFile" = "honk shoo mimimi";
            "vscord.status.state.text.idle" = "idling~";
            "vscord.app.name" = "Visual Studio Code";
            "vscord.status.buttons.button1.active.enabled" = "true";
        }; 
    };
}
