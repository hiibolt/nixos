{ 
	config,
	pkgs,
    unstable-pkgs,
	inputs,
	hostname,
	uses_plasma,
	enable_vscode ? true,
	claude-code-nix
}:
let
	vscode-server = fetchGit {
		url = "https://github.com/msteen/nixos-vscode-server.git";
		rev = "8b6db451de46ecf9b4ab3d01ef76e59957ff549f";
	};
in
{ 
	imports = [
	] ++ pkgs.lib.optionals enable_vscode [
		"${vscode-server}/modules/vscode-server/home.nix"
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
	home.persistence."/persist" = import ./persistence.nix {
		inherit config;
		inherit pkgs;
		inherit hostname;
		inherit uses_plasma;
		inherit enable_vscode;
	};

	# VSC Server
	services = pkgs.lib.optionalAttrs enable_vscode {
		vscode-server.enable = true;
	};

	home.stateVersion = "23.11"; # Please read the comment before changing
	home.packages = with pkgs; [
        claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
		dconf
	] ++ [
		unstable-pkgs.osu-lazer-bin
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

