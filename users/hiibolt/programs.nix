{
    config,
    pkgs,
    unstable-pkgs,
    hostname,
    uses_plasma
}:
{
    fish = {
        enable = true;
        plugins = [
            {
                name = "tide";
                src = pkgs.fishPlugins.tide.src;
            }
            {
                name = "tmux";
                src = pkgs.fetchFromGitHub {
                    owner = "budimanjojo";
                    repo = "tmux.fish";
                    rev = "v2.0.1";
                    sha256 = "sha256-ynhEhrdXQfE1dcYsSk2M2BFScNXWPh3aws0U7eDFtv4=";
                };
            }
        ];
        shellAliases = {
            # Claude Code / Zed
            c = "claude";
            z = "zeditor";

            # Kanata
            ka = "systemctl start kanata.service";
            kd = "systemctl stop kanata.service";

            # Fastfetch
            ff = "fastfetch";

            # Kubernetes
            k = "kubectl";
            kgp = "kubectl get pods";
            kgpa = "kubectl get pods --all-namespaces";
            kgd = "kubectl get deployments";
            kgs = "kubectl get services";
            kgn = "kubectl get nodes";
            kgns = "kubectl get namespaces";
            kdp = "kubectl describe pod";
            kdd = "kubectl describe deployment";
            kds = "kubectl describe service";
            kdn = "kubectl describe node";
            kdelp = "kubectl delete pod";
            kdeld = "kubectl delete deployment";
            kdels = "kubectl delete service";
            kl = "kubectl logs";
            klf = "kubectl logs -f";
            ksc = "kubectl config set-context --current --namespace";
            kex = "kubectl exec -it";
            ktop = "kubectl top nodes";
            ktopp = "kubectl top pods";

            # Talos
            t = "talosctl";
            tap = "talosctl apply-config";

            # Nixos
            rb-s = "sudo mkdir -p /persist/hypermeow && TMPDIR=/persist/hypermeow sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --show-trace && sudo rm -rf /persist/hypermeow";
            rb-b = "sudo mkdir -p /persist/hypermeow && TMPDIR=/persist/hypermeow sudo nixos-rebuild boot --flake /etc/nixos#$(hostname) --show-trace && sudo rm -rf /persist/hypermeow";
        };
        interactiveShellInit = ''
            set -x DIRENV_LOG_FORMAT ""
            eval (direnv hook fish)
            function boilerplate -d "Grabs a boilerplate from https://github.com/boltr6/nix-templates"
                if contains -- "$argv" "-L" "--list"
                    # List the available boilerplates
                    git clone -q https://github.com/boltr6/nix-templates
                    echo "Availabe boilerplates:"
                    ls "$PWD/nix-templates"
                    rm -R -f nix-templates
                else
                    # Clone and move the selected boilerplate
                    git clone -q https://github.com/boltr6/nix-templates
                    echo "Grabbing the following files:"
                    ls -A "$PWD/nix-templates/$argv[1]"
                    mv -n "$PWD/nix-templates/$argv[1]/"{.*,*} "$PWD"
                    rm -R -f nix-templates
                    echo "Done"
                end
            end
            set_color -i cyan
            set fish_greeting "Don't stop 'till Stanford"
            kubectl completion fish | source
            talosctl completion fish | source

            string match -q "$TERM_PROGRAM" "vscode"
            and . (code --locate-shell-integration-path fish)
        '';
    };
    direnv = {
        enable = true;
    };
    tmux = {
        enable = true;
        extraConfig = ''
            bind J run-shell "for i in $(tmux list-windows -F '#{window_index}' | grep -v $(tmux display -p '#{window_index}')); do tmux join-pane -s :\$i -h; done; tmux select-layout tiled"
        '';
    };
    zed-editor = {
        enable = true;
        package = unstable-pkgs.zed-editor;
        extraPackages = [
            unstable-pkgs.rust-analyzer
        ];
    };
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
    vscode = {
        enable = true;
        package = unstable-pkgs.vscode;
        profiles.default = {
                extensions = with unstable-pkgs.vscode-extensions; [
                # Language Support
                bbenoist.nix
                rust-lang.rust-analyzer
                svelte.svelte-vscode
                redhat.vscode-yaml
                ms-kubernetes-tools.vscode-kubernetes-tools

                # Design
                leonardssh.vscord
                ms-kubernetes-tools.vscode-kubernetes-tools

                # Copilot / Claude
                github.copilot
                github.copilot-chat
            ]  ++ unstable-pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
                "vscord.status.buttons.button1.active.enabled" = true;

                ## fucking zowe
                "zowe.security.secureCredentialsEnabled" = false;
                "files.associations" = {
                    "**/*.ASM*{,/*}" = "hlasm";
                    "**/*.ASSEMBLE*{,/*}" = "hlasm";
                    "**/*.CNTL*{,/*}" = "jcl";
                    "**/*.COB*{,/*}" = "cobol";
                    "**/*.COBCOPY*{,/*}" = "cobol";
                    "**/*.COBOL*{,/*}" = "cobol";
                    "**/*.COPY*{,/*}" = "cobol";
                    "**/*.COPYBOOK*{,/*}" = "cobol";
                    "**/*.DBD*{,/*}" = "hlasm";
                    "**/*.EXEC*{,/*}" = "rexx";
                    "**/*.HLA*{,/*}" = "hlasm";
                    "**/*.HLASM*{,/*}" = "hlasm";
                    "**/*.INC*{,/*}" = "pl1";
                    "**/*.INCLUDE*{,/*}" = "pl1";
                    "**/*.JCL*{,/*}" = "jcl";
                    "**/*.MACLIB*{,/*}" = "hlasm";
                    "**/*.MFS*{,/*}" = "hlasm";
                    "**/*.PCB*{,/*}" = "hlasm";
                    "**/*.PL1*{,/*}" = "pl1";
                    "**/*.PLI*{,/*}" = "pl1";
                    "**/*.PROC*{,/*}" = "jcl";
                    "**/*.REXX*{,/*}" = "rexx";
                    "**/*.REXXINC*{,/*}" = "rexx";
                    "*.rex" = "rexx";
                };
            };
        };
    };
}
