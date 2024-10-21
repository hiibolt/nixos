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
      ff = "fastfetch";
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
