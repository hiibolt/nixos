{ config, pkgs, ... }:
{	
    nixpkgs.config.permittedInsecurePackages = [
        "electron-27.3.11" # For Logseq
    ];

    users.users.hiibolt = {
		isNormalUser = true;
		description = "hiibolt";
		extraGroups = [ "networkmanager" "wheel" "dialout" ];
		packages = with pkgs; [
			# GUI Packages
			kdePackages.kate

			# Browsers
			brave
			librewolf

			# Shell Utilies
			tilix
			fastfetch
			direnv

			# Virtualization
			docker
			docker-compose

			# Games and Applications
			osu-lazer
			(lutris.override {
				extraLibraries = pkgs: [
					libadwaita
					gtk4
				];	
				extraPkgs = pkgs: [
					pango
				];
			})
			vesktop
      		libreoffice
			logseq
		    (pkgs.callPackage /etc/nixos/packages/cider/default.nix {})	
			(vscode-with-extensions.override {
				vscodeExtensions = with vscode-extensions; [
					github.copilot
					ms-vscode-remote.remote-ssh

					# Nix
					bbenoist.nix

					# Rust
					rust-lang.rust-analyzer
				] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
					{
						name = "remote-ssh-edit";
						publisher = "ms-vscode-remote";
						version = "0.47.2";
						sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
					}
					{
						name = "glassit";
						publisher = "s-nlf-fh";
						version = "0.2.6";
						sha256 = "LcAomgK91hnJWqAW4I0FAgTOwr8Kwv7ZhvGCgkokKuY=";
					}
				];
			})
		];
	};
}
