{ 
	config,
	pkgs,
	hostname,
	uses_plasma
}:
{
    directories = [
        "Development"
        "Games"
        ".gnupg"
        ".ssh"
        ".nixops"
        ".local/share/keyrings"
        ".local/share/kwalletd"

        # Shell & Dev
        ".local/share/direnv"
        ".local/share/fish"
        ".config/Code"
        ".kube"

        # Browser
        ".librewolf"

        # Vesktop
        ".config/vesktop"

        # Music
        ".config/sh.cider.electron"

        # Games
        ".local/share/lutris"
        ".cache/winetricks"
        ".cache/lutris"
        {
        	directory = ".local/share/Steam";
        	method = "symlink";
        }
    ];
    files = [
        ".screenrc"

        # Git
        ".config/gh/hosts.yml"
    ];
    allowOther = true;
}