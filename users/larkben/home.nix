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
	vscode-server = fetchTarball {
		url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
		sha256 = "1rq8mrlmbzpcbv9ys0x88alw30ks70jlmvnfr2j8v830yy5wvw7h";
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
	home.persistence."/persist/home/larkben" = import ./persistence.nix {
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
	];

} // pkgs.lib.optionalAttrs uses_plasma (import ./stylix.nix {
	inherit config;
	inherit pkgs;
	inherit hostname;
	inherit uses_plasma;
})