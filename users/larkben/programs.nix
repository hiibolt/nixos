{
    config,
    pkgs,
    unstable-pkgs,
    hostname,
    uses_plasma
}:
{
    vim = {
        enable = true;
        plugins = [ ];
        extraConfig = ''
        
        '';
        settings = {

        };
    };
    zsh = {
        enable = true;
    };
    # Remember, Alacritty is a terminal emulator,
    #  and only works when physically using the system!
    alacritty = {
        enable = true;
        settings = {
            "live_config_reload" = true;
            "colors" = pkgs.lib.mkForce {
                "draw_bold_text_with_bright_colors" = false;
            
                "bright" = {
                    "black" = "0x665c54";
                    "blue" = "0xbdae93";
                    "cyan" = "0xd65d0e";
                    "green" = "0x3c3836";
                    "magenta" = "0xebdbb2";
                    "red" = "0xfe8019";
                    "white" = "0xfbf1c7";
                    "yellow" = "0x504945";
                };

                "cursor" = {
                    "cursor" = "0xd5c4a1";
                    "text" = "0x1d2021";
                };

                "normal" = {
                    "black" = "0x1d2021";
                    "blue" = "0x83a598";
                    "cyan" = "0x8ec07c";
                    "green" = "0xb8bb26";
                    "magenta" = "0xd3869b";
                    "red" = "0xfb4934";
                    "white" = "0xd5c4a1";
                    "yellow" = "0xfabd2f";
                };
                
                "primary" = {
                    "background" = "0x1d2021";
                    "foreground" = "0xd5c4a1";
                };
            };
            "env" = {
                "TERM" = "alacritty";
            };
            "font" = pkgs.lib.mkForce {
                "size" = 15;

                "normal" = {
                    "family" = "Andale Mono";
                };
            };
            "keyboard" = {
                "bindings" = [
                    {
                        "chars" = "\u001BF";
                        "key" = "Right";
                        "mods" = "Alt";
                    }
                    {
                        "chars" = "\u001BB";
                        "key" = "Left";
                        "mods" = "Alt";
                    }
                ];
            };
            "scrolling" = {
                "history" = 100000;
            };
            "window" = {
                "dynamic_title" = true;
                "title" = "Terminal";
            };
        };
    };
    git = {
        enable = true;
        userName = "larkben";
        userEmail = "my_git_username@gmail.com";
        extraConfig = {
            safe.directory = "*";
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