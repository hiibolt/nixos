{ 
	config,
	pkgs,
	hostname,
	uses_plasma
}:
{
    directories = [
        "Development"
        {
            directory = "Games";
            method = "symlink";
        }
        ".gnupg"
        ".ssh"
        ".nixops"
        ".local/share/keyrings"
        ".local/share/kwalletd"

        # Postman
        ".config/Postman"

        # Logseq
        ".config/logseq"
        ".logseq"

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
        ".local/share/osu"
        ".local/share/PrismLauncher"
        ".local/share/lutris"
        ".cache/winetricks"
        ".cache/lutris"
    ];
    files = [
        ".screenrc"

        # Git
        ".config/gh/hosts.yml"
    ];
    allowOther = true;
}