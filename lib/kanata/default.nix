{ config, pkgs, keyboard_path }:
{	
  environment.systemPackages = with pkgs; [ kanata ];
  hardware.uinput.enable = true;
  services.udev.extraRules = "KERNEL==\"uinput\", MODE=\"0660\", GROUP=\"uinput\", OPTIONS+=\"static_node=uinput\"";
  systemd.services.kanata = {
    path = [ pkgs.kanata ];
    wantedBy = [ "multi-user.target" ];
    script = ''kanata -c ${keyboard_path}'';
    enable = true;
  };
}