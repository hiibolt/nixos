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
        extraPackages = [ ];
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
            require("presence").setup({
                -- General options
                auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
                neovim_image_text   = "MEOOOOOWWW...", -- Text displayed when hovered over the Neovim image
                main_image          = "file",                   -- Main image display (either "neovim" or "file")
                -- client_id        = "793271441293967371",       -- Use your own Discord application client id (not recommended)
                log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
                debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
                enable_line_number  = false,                      -- Displays the current line number instead of the current project
                blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
                buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
                file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
                show_time           = true,                       -- Show the timer

                -- Rich Presence text options
                editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
                file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
                git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
                plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
                reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
                workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
                line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
            })
            '';
        plugins = with pkgs.vimPlugins; [
            catppuccin-nvim
            bufferline-nvim
            nvim-treesitter.withAllGrammars
            nvim-web-devicons
            transparent-nvim
            presence-nvim
        ];
    };
    git = {
        enable = true;
        userName = "hiibolt";
        userEmail = "my_git_username@gmail.com";
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
            "editor.fontFamily" = "'DejaVu Sans Mono'";
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
