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
        extensions = with pkgs.vscode-extensions; [
            # Development Environment
            github.copilot

            # Language Support
            bbenoist.nix
        ]  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            #{
            #	name = "remote-ssh-edit";
            #	publisher = "ms-vscode-remote";
            #	version = "0.47.2";
            #	sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
            #}
            {
                name = "remote-ssh";
                publisher = "ms-vscode-remote";
                version = "0.115.0";
                sha256 = "CUGzDEZIqIJqGmA+ymZTbcA7DPRF6fj37WW7CnRHkPE=";
            }
            {
                name = "glassit";
                publisher = "s-nlf-fh";
                version = "0.2.6";
                sha256 = "LcAomgK91hnJWqAW4I0FAgTOwr8Kwv7ZhvGCgkokKuY=";
            }
            {
                name = "vscord";
                publisher = "LeonardSSH";
                version = "5.2.13";
                sha256 = "Jgm3ekXFLhylX7RM6tdfi+lRLrcl4UQGmRHbr27M59M=";
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
        ];
        userSettings = {
            "editor.fontFamily" = pkgs.lib.mkForce "'DejaVu Sans Mono'";
            "terminal.integrated.fontFamily" = "'DejaVu Sans Mono'";
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
        }; 
    };
}
