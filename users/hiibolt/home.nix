{ 
	config,
	pkgs,
    unstable-pkgs,
	inputs,
	impermanence,
	hostname,
	uses_plasma
}:
let
	vscode-server = fetchGit {
		url = "https://github.com/msteen/nixos-vscode-server.git";
		rev = "8b6db451de46ecf9b4ab3d01ef76e59957ff549f";
	};
in
{ 
	imports = [
		"${vscode-server}/modules/vscode-server/home.nix"
		inputs.impermanence.nixosModules.home-manager.impermanence
	];

	# `home-manager` and `plasma-manager`
	programs = import ./programs.nix {
		inherit config;
		inherit pkgs;
		inherit unstable-pkgs;
		inherit hostname;
		inherit uses_plasma;
	} // pkgs.lib.optionalAttrs uses_plasma (import ./plasma.nix {
		inherit config;
		inherit pkgs;
		inherit hostname;
		inherit uses_plasma;
	});
	
	# Persistence
	home.persistence."/persist/home/hiibolt" = import ./persistence.nix {
		inherit config;
		inherit pkgs;
		inherit hostname;
		inherit uses_plasma;
	};

	# VSC Server
	services.vscode-server.enable = true;

	home.stateVersion = "23.11"; # Please read the comment before changing
	home.file = {
		".config/fish/config.fish" = {
			source = ../../lib/shell/config.fish;
		};
	};
	home.packages = with pkgs; [
		dconf
		google-chrome
	] ++ [
		(unstable-pkgs.prismlauncher.override {
			jdks = with pkgs; [
				temurin-bin-21
				temurin-bin-17
				zulu8
			];
		}) 
	];
} // pkgs.lib.optionalAttrs uses_plasma (import ./stylix.nix {
	inherit config;
	inherit pkgs;
	inherit hostname;
	inherit uses_plasma;
})

