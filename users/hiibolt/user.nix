
{ config, lib, pkgs, inputs, unstable-pkgs, claude-code-nix, enable_vscode ? true, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  # Create our primary user (`hiibolt`)
  users.users.hiibolt = {
    isNormalUser = true;
    description = "hiibolt";
    initialPassword = "1234";
    # hashedPasswordFile = "/etc/nixos/users/hiibolt/passwords/hiibolt.pw";
    extraGroups = [ "wheel" "docker" "vboxusers" ];
    packages = with pkgs; [
      # Development
      gh
      git
      postman
      skopeo
      racket
      jq

      # Kubernetes
      argocd
      kubernetes-helm
      kubectl
      talosctl
      yq-go
      inputs.kdiff.defaultPackage.${pkgs.stdenv.hostPlatform.system}

      # System Utilities
      fastfetch
      lsof
      sysstat
      nmap
      dnsutils
      inetutils
      tcpdump
      ethtool
      mtr
      droidcam
      caligula

      # Dev Environment
      claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
      unstable-pkgs.vscode
      unstable-pkgs.zed-editor
      dconf
      (pkgs.rust-bin.nightly.latest.default.override {
        targets = [ "wasm32-wasip1" ];
      })
      gcc

      # Neovim extras
      code-minimap
      unstable-pkgs.rust-analyzer

      # Games / Media
      unstable-pkgs.osu-lazer-bin
      (unstable-pkgs.prismlauncher.override {
        jdks = with pkgs; [
          temurin-bin-21
          temurin-bin-17
          zulu8
        ];
      })
    ] ++ lib.optionals enable_vscode [
      # Web & Office
      librewolf
      libreoffice
      zoom-us
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          obs-backgroundremoval
          obs-composite-blur
          droidcam-obs
        ];
      })

      # Note-taking
      anki

      # Vesktop
      vesktop

      # Music
      spotify
      (pkgs.callPackage ./cider/default.nix {})

      # Games
      (lutris.override {
        extraLibraries = pkgs: [
          libadwaita
          gtk4
        ];
        extraPkgs = pkgs: [
          pango
        ];
      })
    ];
  };

  # Fish plugins — NixOS picks up vendor_functions.d/vendor_conf.d from systemPackages
  environment.systemPackages = [
    pkgs.fishPlugins.tide
    (pkgs.stdenv.mkDerivation {
      name = "tmux-fish-plugin";
      src = pkgs.fetchFromGitHub {
        owner = "budimanjojo";
        repo = "tmux.fish";
        rev = "v2.0.1";
        sha256 = "sha256-ynhEhrdXQfE1dcYsSk2M2BFScNXWPh3aws0U7eDFtv4=";
      };
      installPhase = ''
        mkdir -p $out/share/fish/vendor_conf.d $out/share/fish/vendor_functions.d $out/share/fish/vendor_completions.d
        [ -d conf.d ]    && cp conf.d/*.fish    $out/share/fish/vendor_conf.d/    || true
        [ -d functions ] && cp functions/*.fish $out/share/fish/vendor_functions.d/ || true
        [ -d completions ] && cp completions/*.fish $out/share/fish/vendor_completions.d/ || true
      '';
    })
  ];

  programs.fish = {
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

      # NixOS
      rb-s = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) --show-trace";
      rb-b = "sudo nixos-rebuild boot --flake /etc/nixos#$(hostname) --show-trace";
    };
    interactiveShellInit = ''
      fish_add_path $HOME/.cargo/bin $HOME/.bun/bin
      set -x DIRENV_LOG_FORMAT ""
      eval (direnv hook fish)
      function boilerplate -d "Grabs a boilerplate from https://github.com/boltr6/nix-templates"
          if contains -- "$argv" "-L" "--list"
              git clone -q https://github.com/boltr6/nix-templates
              echo "Availabe boilerplates:"
              ls "$PWD/nix-templates"
              rm -R -f nix-templates
          else
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

  programs.neovim = {
    enable = true;
    configure = {
      customRC = ''
        set number
        syntax enable
        colorscheme catppuccin-frappe

        lua << EOF
        require("bufferline").setup()
        require("nvim-treesitter.configs").setup({
            highlight = { enable = true }
        })
        require('transparent').setup({})
        require("neocord").setup({})
        EOF
      '';
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [
          catppuccin-nvim
          bufferline-nvim
          nvim-treesitter.withAllGrammars
          nvim-web-devicons
          transparent-nvim
          neocord
          rustaceanvim
        ];
      };
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      bind J run-shell "for i in $(tmux list-windows -F '#{window_index}' | grep -v $(tmux display -p '#{window_index}')); do tmux join-pane -s :\$i -h; done; tmux select-layout tiled"
    '';
  };

  programs.direnv.enable = true;

  environment.etc."gitconfig".text = ''
    [user]
      name = hiibolt
      email = me@hiibolt.com
  '';
}
