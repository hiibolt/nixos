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

    # Fish plugins
    fishPlugins.tide
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
  ] ++ lib.optionals hasKeyboard [
    kanata
  ];

  environment.shells = with pkgs; [ fish ];

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
    ];
  };

  # Shell configuration
  programs.fish = {
    enable = true;
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

  users.defaultUserShell = pkgs.fish;
  programs.command-not-found.enable = false;

  # Tide auto-configure
  system.userActivationScripts.fish.text = ''
    ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Classic --prompt_colors='16 colors' --show_time=No --classic_prompt_separators=Slanted --powerline_prompt_heads=Sharp --powerline_prompt_tails=Sharp --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_spacing=Compact --icons='Many icons' --transient=Yes"
  '';

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
