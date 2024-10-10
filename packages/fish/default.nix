{ config, pkgs, ... }:

{
  programs.fish.enable = true;

  # Set the default shell
  users.defaultUserShell = pkgs.fish;

  # Import Fish and Tide
  environment = {
    systemPackages = with pkgs; [ fishPlugins.tide ];
    shells = with pkgs; [ fish ];
  };

  # Load the config files
  system.userActivationScripts = {
    fish = {
      text = ''
        rm ~/.config/fish/config.fish; ln -s /etc/nixos/packages/fish/config.fish ~/.config/fish/config.fish
	${pkgs.fish}/bin/fish -c "tide configure --auto --style=Classic --prompt_colors='16 colors' --show_time=No --classic_prompt_separators=Slanted --powerline_prompt_heads=Sharp --powerline_prompt_tails=Sharp --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_spacing=Compact --icons='Many icons' --transient=Yes"
      '';
    };
  };
}
