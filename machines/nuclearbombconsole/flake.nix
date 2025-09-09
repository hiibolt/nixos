# Useful commands:
# - Update single dep `nix flake lock --update-input nixpkgs`

{
	description = "Configuration for multiple of @hiibolt's systems.";

	inputs = {
		etc-nixos = {
			url = "/etc/nixos";
			flake = false;
		};

		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
		unstable-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# To edit sops, switch to superuser and run the following:
		# * `sops secrets/secrets.yaml`
		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		impermanence = {
			url = "github:nix-community/impermanence";
		};

    	nix-index-database = {
			url = "github:nix-community/nix-index-database";
    		inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{
		nixpkgs, 
		unstable-nixpkgs,
		disko,
		sops-nix,
		impermanence,
		home-manager,
		nix-index-database,
		...
	}:
	let 
		system = "x86_64-linux";

		globalPkgsConfig = {
			allowUnfree = true;
			pulseaudio = true;
		};
		pkgs = import nixpkgs {
			inherit system;
			overlays = [ ];
			config = globalPkgsConfig;
		};
		unstable-pkgs = import unstable-nixpkgs {
			inherit system;
			overlays = [ ];
			config = globalPkgsConfig;
		};
		config = pkgs.config;
	in
	{
		nixosConfigurations.nuclearbombconsole = nixpkgs.lib.nixosSystem {
			inherit system;

			specialArgs = {inherit inputs;};
			modules = [
				home-manager.nixosModules.default {	
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.backupFileExtension = "meow";
					
					home-manager.users = {
						"hiibolt" = import ../../users/hiibolt/home.nix {
							config = home-manager.nixosModules.default.config;
							inherit pkgs;
							inherit unstable-pkgs;
							inherit inputs;
							hostname = "nuclearbombconsole";
							impermanence = impermanence.nixosModules.home-manager.impermanence;
						};
					};
				}

				disko.nixosModules.default

				nix-index-database.nixosModules.nix-index

				./configuration.nix 

				impermanence.nixosModules.impermanence
			#	
			];
		};
	};
}
