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
			kdePackages.kate
			osu-lazer
			brave
			librewolf
			tilix
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
			docker
			docker-compose
			logseq
			direnv
		    (pkgs.callPackage /etc/nixos/packages/cider/default.nix {})	
			(vscode-with-extensions.override {
				vscodeExtensions = with vscode-extensions; [
					bbenoist.nix
					ms-python.python
					ms-azuretools.vscode-docker
					ms-vscode-remote.remote-ssh
				] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
					{
						name = "remote-ssh-edit";
						publisher = "ms-vscode-remote";
						version = "0.47.2";
						sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
					}
				];
			})
		];
	};
}
