{
	description = "Configuration for multiple of @hiibolt's systems.";

	inputs = {
		etc-nixos = {
			url = "/etc/nixos";
			flake = false;
		};

		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
		unstable-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		impermanence = {
			url = "github:nix-community/impermanence";
		};

		home-manager = {
			url = "github:nix-community/home-manager/release-24.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		plasma-manager = {
			url = "github:nix-community/plasma-manager";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};
    	stylix = {
			url = "github:hiibolt/stylix?rev=abcd2036a1420779f6925f0db5aea86b86ae3ac6";
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
						plasma-manager.homeManagerModules.plasma-manager
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
						"larkben" = import ./users/larkben/home.nix {
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
		nixosConfigurations.nuclearbombsoc = nixpkgs.lib.nixosSystem {
			inherit system;

			#
			# "nuclearbombsoc" is the laptop
			#

			specialArgs = {inherit inputs;};
			modules = [
				disko.nixosModules.default

				nix-index-database.nixosModules.nix-index

				./devices/nuclearbombsoc/configuration.nix 
				
				home-manager.nixosModules.default {	
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.sharedModules = [ 
						plasma-manager.homeManagerModules.plasma-manager
					];
					home-manager.backupFileExtension = "meow";
					
					home-manager.users = {
						"hiibolt" = import ./users/hiibolt/home.nix {
							config = home-manager.nixosModules.default.config;
							inherit pkgs;
							inherit unstable-pkgs;
							inherit inputs;
							hostname = "nuclearbombsoc";
							uses_plasma = true;
							impermanence = impermanence.nixosModules.home-manager.impermanence;
						};
						"larkben" = import ./users/larkben/home.nix {
							config = home-manager.nixosModules.default.config;
							inherit pkgs;
							inherit unstable-pkgs;
							inherit inputs;
							hostname = "nuclearbombsoc";
							uses_plasma = true;
							impermanence = impermanence.nixosModules.home-manager.impermanence;
						};
					};
				}
				stylix.nixosModules.stylix

				impermanence.nixosModules.impermanence
			#	
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
						plasma-manager.homeManagerModules.plasma-manager
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
		nixosConfigurations.nuclearbombcell-1 = nixpkgs.lib.nixosSystem {
			inherit system;

			#
			# "nuclearbombcell-1" is the first of the Dell machines
			#

			specialArgs = {inherit inputs;};
			modules = [
				disko.nixosModules.default

				nix-index-database.nixosModules.nix-index

				./devices/nuclearbombcell-1/configuration.nix 
				
				home-manager.nixosModules.default {	
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.sharedModules = [ ];
					home-manager.backupFileExtension = "meow";
					
					home-manager.users."hiibolt" = import ./users/hiibolt/home.nix {
						config = home-manager.nixosModules.default.config;
						inherit pkgs;
						inherit unstable-pkgs;
						inherit inputs;
						hostname = "nuclearbombcell-1";
						uses_plasma = false;
						impermanence = impermanence.nixosModules.home-manager.impermanence;
					};
					home-manager.users."larkben" = import ./users/larkben/home.nix {
						config = home-manager.nixosModules.default.config;
						inherit pkgs;
						inherit unstable-pkgs;
						inherit inputs;
						hostname = "nuclearbombcell-1";
						uses_plasma = false;
						impermanence = impermanence.nixosModules.home-manager.impermanence;
					};
				}

				impermanence.nixosModules.impermanence
				
			];
		};

		nixosConfigurations.nuclearbombcell-2 = nixpkgs.lib.nixosSystem {
			inherit system;

			#
			# "nuclearbombcell-2" is the burger box
			#

			specialArgs = {inherit inputs;};
			modules = [
				disko.nixosModules.default

				nix-index-database.nixosModules.nix-index

				./devices/nuclearbombcell-2/configuration.nix 
				
				home-manager.nixosModules.default {	
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.sharedModules = [ ];
					home-manager.backupFileExtension = "meow";
					
					home-manager.users."hiibolt" = import ./users/hiibolt/home.nix {
						config = home-manager.nixosModules.default.config;
						inherit pkgs;
						inherit unstable-pkgs;
						inherit inputs;
						hostname = "nuclearbombcell-2";
						uses_plasma = false;
						impermanence = impermanence.nixosModules.home-manager.impermanence;
					};
					home-manager.users."larkben" = import ./users/larkben/home.nix {
						config = home-manager.nixosModules.default.config;
						inherit pkgs;
						inherit unstable-pkgs;
						inherit inputs;
						hostname = "nuclearbombcell-2";
						uses_plasma = false;
						impermanence = impermanence.nixosModules.home-manager.impermanence;
					};
				}

				impermanence.nixosModules.impermanence
				
			];
		};nixosConfigurations.nuclearbombcell-3 = nixpkgs.lib.nixosSystem {
			inherit system;

			#
			# "nuclearbombcell-3" is the first of the Dell machines
			#

			specialArgs = {inherit inputs;};
			modules = [
				disko.nixosModules.default

				nix-index-database.nixosModules.nix-index

				./devices/nuclearbombcell-3/configuration.nix 
				
				home-manager.nixosModules.default {	
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.sharedModules = [ ];
					home-manager.backupFileExtension = "meow";
					
					home-manager.users."hiibolt" = import ./users/hiibolt/home.nix {
						config = home-manager.nixosModules.default.config;
						inherit pkgs;
						inherit unstable-pkgs;
						inherit inputs;
						hostname = "nuclearbombcell-3";
						uses_plasma = false;
						impermanence = impermanence.nixosModules.home-manager.impermanence;
					};
					home-manager.users."larkben" = import ./users/larkben/home.nix {
						config = home-manager.nixosModules.default.config;
						inherit pkgs;
						inherit unstable-pkgs;
						inherit inputs;
						hostname = "nuclearbombcell-3";
						uses_plasma = false;
						impermanence = impermanence.nixosModules.home-manager.impermanence;
					};
				}

				impermanence.nixosModules.impermanence
				
			];
		};
	};
}
