{ config, pkgs, layout, device }:
let 
  fileContents = builtins.readFile ./keyboards/${layout}.kbd;

  modifiedFileContents = builtins.replaceStrings ["<!KEYBOARD_ID_INJECT_MARKER>"] ["${device}"] fileContents;

  modifiedFile = pkgs.writeText "${layout}-${device}-kbd" modifiedFileContents;

  # Early return if the layout is question
  isQwerty = layout == "qwerty" ;

  result = if isQwerty then 
    {}
  else
    {
      environment.systemPackages = with pkgs; [ kanata ];
      hardware.uinput.enable = true;
      services.udev.extraRules = "KERNEL==\"uinput\", MODE=\"0660\", GROUP=\"uinput\", OPTIONS+=\"static_node=uinput\"";
      systemd.services.kanata = {
        path = [ pkgs.kanata ];
        wantedBy = [ "multi-user.target" ];
        script = ''kanata -c ${modifiedFile}'';
        enable = true;
      };
    };
in
  result