{ 
	config,
	pkgs,
	hostname,
	uses_plasma,
	enable_vscode ? true
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
        "/etc/cdi"
        "VirtualBox VMs"

        # Postman
        ".config/Postman"

        # Logseq
        ".config/logseq"
        ".logseq"

        # Shell & Dev
        ".local/share/direnv"
        ".local/share/fish"
        ".kube"
    ] ++ pkgs.lib.optionals enable_vscode [
        ".config/Code"
        ".zowe"
        ".local/share/zed"
        ".config/zed"
        ".claude"

        # Browser
        ".librewolf"

        # Vesktop
        ".config/vesktop"

        # Music
        ".config/spotify"
        ".config/sh.cider.electron"

        # Games
        ".local/share/osu"
        ".local/share/PrismLauncher"
        ".local/share/lutris"
        ".local/share/Steam"
        ".steam"
        ".cache/winetricks"
        ".cache/lutris"
    ];
    files = [
        ".screenrc"
        ".claude.json"
        ".config/kwinoutputconfig.json"
        ".config/kcminputrc"
        ".config/plasma-org.kde.plasma.desktop-appletsrc"

        # Git
        ".config/gh/hosts.yml"
    ];
}