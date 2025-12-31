# Useful commands:
# - Update single dep `nix flake lock --update-input nixpkgs`

{
	description = "Configuration for multiple of @hiibolt's systems.";

	inputs = {
		etc-nixos = {
			url = "/etc/nixos";
			flake = false;
		};

		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
		unstable-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixos-wsl.url = "github:nix-community/nixos-wsl";

		kdiff.url = "github:hiibolt/kdiff";

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

		home-manager = {
			url = "github:nix-community/home-manager/release-25.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		plasma-manager = {
			url = "github:nix-community/plasma-manager";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};
    	stylix = {
			url = "github:danth/stylix/release-25.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};

    	nix-index-database = {
			url = "github:nix-community/nix-index-database";
    		inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{
		nixpkgs, 
		unstable-nixpkgs,
		nixos-wsl,
		disko,
		sops-nix,
		impermanence,
		home-manager,
		plasma-manager,
		stylix,
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
	rec {
		nixosConfigurations.default = nixosConfigurations.nuclearbombwarhead;
		nixosConfigurations.nuclearbombwsl = nixpkgs.lib.nixosSystem {
			inherit system;
			modules = [
				./devices/nuclearbombwsl/configuration.nix
				nixos-wsl.nixosModules.wsl
			];
		};
		nixosConfigurations.nuclearbombwarhead = nixpkgs.lib.nixosSystem {
			inherit system;

			#
			# "nuclearbombwarhead" is the primary system (CyberPowerPC Case)
			#

			specialArgs = {inherit inputs;};
			modules = [
				nix-index-database.nixosModules.nix-index
				./devices/nuclearbombwarhead/configuration.nix 

				disko.nixosModules.default
				impermanence.nixosModules.impermanence
				
				home-manager.nixosModules.default {	
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.sharedModules = [ 
						plasma-manager.homeModules.plasma-manager
					];
					home-manager.backupFileExtension = "meow";
					home-manager.users = {
						"hiibolt" = import ./users/hiibolt/home.nix {
							config = home-manager.nixosModules.default.config;
							inherit pkgs;
							inherit unstable-pkgs;
							inherit inputs;
							hostname = "nuclearbombwarhead";
							uses_plasma = true;
							impermanence = impermanence.nixosModules.home-manager.impermanence;
						};
					};
				}
				stylix.nixosModules.stylix				
			];
		};
		nixosConfigurations.nuclearbombconsole = nixpkgs.lib.nixosSystem {
			inherit system;

			#
			# "nuclearbombconsole" is the laptop
			#

			specialArgs = {inherit inputs;};
			modules = [
				disko.nixosModules.default

				nix-index-database.nixosModules.nix-index

				./devices/nuclearbombconsole/configuration.nix 
				
				home-manager.nixosModules.default {	
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.sharedModules = [ 
						plasma-manager.homeModules.plasma-manager
					];
					home-manager.backupFileExtension = "meow";
					
					home-manager.users."hiibolt" = import ./users/hiibolt/home.nix {
						config = home-manager.nixosModules.default.config;
						inherit pkgs;
						inherit unstable-pkgs;
						inherit inputs;
						hostname = "nuclearbombconsole";
						uses_plasma = true;
						impermanence = impermanence.nixosModules.home-manager.impermanence;
					};
				}
				stylix.nixosModules.stylix

				impermanence.nixosModules.impermanence
			#	
			];
		};
		nixosConfigurations.nuclearbombchassis = nixpkgs.lib.nixosSystem {
			inherit system;

			#
			# "nuclearbombchassis" is the main machine
			#

			specialArgs = {inherit inputs;};
			modules = [
				disko.nixosModules.default

				nix-index-database.nixosModules.nix-index

				./devices/nuclearbombchassis/configuration.nix 
				
				home-manager.nixosModules.default {	
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.sharedModules = [ 
						plasma-manager.homeModules.plasma-manager
					];
					home-manager.backupFileExtension = "meow";
					
					home-manager.users."hiibolt" = import ./users/hiibolt/home.nix {
						config = home-manager.nixosModules.default.config;
						inherit pkgs;
						inherit unstable-pkgs;
						inherit inputs;
						hostname = "nuclearbombchassis";
						uses_plasma = true;
						impermanence = impermanence.nixosModules.home-manager.impermanence;
					};
				}
				stylix.nixosModules.stylix

				impermanence.nixosModules.impermanence
			#	
			];
		};
	};
}
