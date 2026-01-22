{ config, pkgs, ... }:
{
  # Import Fish, Tide and Tilix
  environment = {
    systemPackages = with pkgs; [
      fishPlugins.tide
      tilix
      direnv
    ];
    shells = with pkgs; [ fish ];
  };

  # Set the default shell
  programs.fish = {
    enable = true;
    shellAliases = {
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
  };
  users.defaultUserShell = pkgs.fish;

  # Fix `command-not-found`
  programs.command-not-found.enable = false;

  # Load the config files
  system.userActivationScripts = {
    fish = {
      text = ''
      ${pkgs.dconf}/bin/dconf load /com/gexperts/Tilix/ < /etc/nixos/lib/shell/tilix.dconf
    	${pkgs.fish}/bin/fish -c "tide configure --auto --style=Classic --prompt_colors='16 colors' --show_time=No --classic_prompt_separators=Slanted --powerline_prompt_heads=Sharp --powerline_prompt_tails=Sharp --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_spacing=Compact --icons='Many icons' --transient=Yes"
      '';
    };
  };
}
