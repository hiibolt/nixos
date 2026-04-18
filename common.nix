{ config, lib, pkgs, inputs, unstable-pkgs, claude-code-nix, enable_vscode ? true, keyboard ? { device = ""; }, ... }:
let
  primary_users = [ "hiibolt" ];

  # Kanata keyboard remapping
  hasKeyboard = keyboard.device != "";
  kanataConfig = ''
    (defcfg
      linux-dev /dev/input/${keyboard.device}
    )

    (defsrc
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lmet lalt           spc            ralt rmet rctl
    )

    (deflayer semimak
      grv  XX  XX    [    ]   XX   XX   XX   XX   XX    -    =    (layer-switch qwerty)    bspc
      tab  f    l    h    v    z    XX    q    w    u    o    y    @scd    ;
      caps  s    r    n    t    k    XX    c    d    e    a    i    ret
      x      '    b    m    j    XX   XX    p    g    ,    .    rsft
      lctl lmet lalt           spc            rshift rmet rctl
    )
    (defalias
      scd  (layer-toggle secondlayer)
    )
    (deflayer secondlayer
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    1    2    3    4    f3    _    S-f5    f5   up   C-S-f9    _    _    _
      _    5    6    7    8    esc    _    f9    left    down    rght    _    _
      _    \    /    9    0    _    _    C-grv    _    _    _    _
      _    _    _              _              _    _    _
    )

    (deflayer qwerty
      grv  1    2    3    4    5    6    7    8    9    0    - (layer-switch semimak)        bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lmet lalt           spc            ralt rmet rctl
    )
  '';
  kanataFile = pkgs.writeText "semimak-kbd" kanataConfig;
in
{
  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Add system fonts
  fonts.packages = [
    pkgs.nerd-fonts.mononoki
    pkgs.nerd-fonts.symbols-only
  ];

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Allow unfree packages and enable Nix Flakes
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Tailscale + SSH
  services.openssh.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  # Disable NVME Write Cache, additional NVME utils
  services.udev.extraRules =
    ''
    ACTION=="add", KERNEL=="nvme*", RUN+="${pkgs.nvme-cli}/bin/nvme set-feature -f 6 -V 0 %N"
    ''
    + lib.optionalString hasKeyboard ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

  environment.systemPackages = with pkgs; [
    nvme-cli
    mdadm

    # Shell
    kitty

    # Zsh plugins
    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting
  ] ++ lib.optionals hasKeyboard [
    kanata
  ];

  environment.shells = with pkgs; [ zsh ];

  # Automatically clean the Nix store
  nix.settings.auto-optimise-store = true;

  # Automate garbage collection for old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };

  # Groups
  users.groups = {
    docker.members = primary_users;
    nix-editor.members = primary_users;
    libvirtd.members = primary_users;
    uinput.members = primary_users;
    input.members = primary_users;
  };

  # Root user
  users.users.root.initialPassword = "1234";

  # Insecure packages and overlays
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  # Create our primary user (`hiibolt`)
  users.users.hiibolt = {
    isNormalUser = true;
    description = "hiibolt";
    initialPassword = "1234";
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
      exiftool

      # Dev Environment
      claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
      unstable-pkgs.vscode
      unstable-pkgs.zed-editor
      dconf
      rustup
      gcc
      pkg-config
      openssl.dev
      clang
      cmake
      mpi
      bun
      nodejs
      pest-ide-tools

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
    ];
  };

  # Shell configuration
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      # Claude Code / Zed
      c = "claude";
      z = "zeditor . && exit";

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
      # Auto-start tmux in Kitty
      if [[ "$TERM" == "xterm-kitty" ]] && [[ -z "$TMUX" ]]; then
        exec tmux new-session
      fi

      # Powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      # PATH
      export PATH="$HOME/.cargo/bin:$HOME/.bun/bin:$PATH"

      # Direnv
      eval "$(direnv hook zsh)"

      # Completions
      source <(kubectl completion zsh)
      source <(talosctl completion zsh)

      # Word navigation
      bindkey '^[[1;5D' backward-word   # Ctrl+Left
      bindkey '^[[1;5C' forward-word    # Ctrl+Right

      # Greeting
      echo "\e[3;38;2;137;180;250mAre you saving time?\e[0m"

      # Boilerplate function
      boilerplate() {
        if [[ "$1" == "-L" || "$1" == "--list" ]]; then
          git clone -q https://github.com/boltr6/nix-templates
          echo "Available boilerplates:"
          ls "$PWD/nix-templates"
          rm -rf nix-templates
        else
          git clone -q https://github.com/boltr6/nix-templates
          echo "Grabbing the following files:"
          ls -A "$PWD/nix-templates/$1"
          mv -n "$PWD/nix-templates/$1/"* "$PWD/nix-templates/$1/".* "$PWD" 2>/dev/null
          rm -rf nix-templates
          echo "Done"
        fi
      }

      # VSCode shell integration
      if [[ "$TERM_PROGRAM" == "vscode" ]]; then
        . "$(code --locate-shell-integration-path zsh)"
      fi
    '';
  };

  users.defaultUserShell = pkgs.zsh;

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse on
      set -g destroy-unattached on
      set -g status-style 'bg=#313244 fg=#89b4fa'
      set -g window-status-current-style 'bg=#45475a fg=#89b4fa bold'
      set -g window-status-style 'bg=#313244 fg=#6c7086'
      set -g set-clipboard on
      bind -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'wl-copy'
      bind J run-shell "for i in $(tmux list-windows -F '#{window_index}' | grep -v $(tmux display -p '#{window_index}')); do tmux join-pane -s :\$i -h; done; tmux select-layout tiled"
    '';
  };

  programs.direnv = {
    enable = true;
    silent = true;
  };

  environment.etc."gitconfig".text = ''
    [user]
      name = hiibolt
      email = me@hiibolt.com
  '';

  # Kanata keyboard remapping (conditional)
  hardware.uinput.enable = hasKeyboard;
} // lib.optionalAttrs hasKeyboard {
  systemd.services.kanata = {
    path = [ pkgs.kanata ];
    wantedBy = [ "multi-user.target" ];
    script = ''kanata -c ${kanataFile}'';
    enable = true;
  };
}
