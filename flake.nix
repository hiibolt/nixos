{
	description = "Configuration for multiple of @hiibolt's systems.";

	inputs = {
		etc-nixos = {
			url = "/etc/nixos";
			flake = false;
		};

		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

		disko = {
			url = "github:nix-community/disko";
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
		disko,
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
		config = pkgs.config;

		# Theming
		wallpaper = "/etc/nixos/backgrounds/6.jpg";
	in
	rec {
		nixosConfigurations.default = nixosConfigurations.nuclearbombwarhead;
		nixosConfigurations.nuclearbombwarhead = nixpkgs.lib.nixosSystem {
			inherit system;

			specialArgs = {inherit inputs;};
			modules = [
				disko.nixosModules.default

				nix-index-database.nixosModules.nix-index

				./devices/nuclearbombwarhead/configuration.nix 
				
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
						inherit inputs;
						inherit wallpaper;
						hostname = "nuclearbombwarhead";
						impermanence = impermanence.nixosModules.home-manager.impermanence;
					};
				}
				stylix.nixosModules.stylix

				impermanence.nixosModules.impermanence
				
			];
		};
		nixosConfigurations.nuclearbombconsole = nixpkgs.lib.nixosSystem {
			inherit system;

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
						inherit inputs;
						inherit wallpaper;
						hostname = "nuclearbombconsole";
						impermanence = impermanence.nixosModules.home-manager.impermanence;
					};
				}
				stylix.nixosModules.stylix

				impermanence.nixosModules.impermanence
				
			];
		};
	};
}
