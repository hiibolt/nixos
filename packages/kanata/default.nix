{ config, pkgs, ... }:
{	
  environment.systemPackages = with pkgs; [ kanata ];
  hardware.uinput.enable = true;
  services.udev.extraRules = "KERNEL==\"uinput\", MODE=\"0660\", GROUP=\"uinput\", OPTIONS+=\"static_node=uinput\"";
  systemd.user.services = {
    kanata = {
      path = [ pkgs.kanata ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ConditionPathExists=''${./semimak.kbd}'';
        ExecStart = ''${pkgs.kanata}/bin/kanata -c ${./semimak.kbd}'';
      };
      enable = true;
    };
  };
}