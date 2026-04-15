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
    	claude-code-nix.url = "github:sadjow/claude-code-nix";
		rust-overlay.url = "github:oxalica/rust-overlay";

		kdiff.url = "github:hiibolt/kdiff";

       	nix-index-database = {
 			url = "github:nix-community/nix-index-database";
      		inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{
		nixpkgs,
		unstable-nixpkgs,
		nixos-wsl,
		nix-index-database,
		claude-code-nix,
		rust-overlay,
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
			overlays = [ rust-overlay.overlays.default ];
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
		nixosConfigurations.default = nixosConfigurations.nuclearbombconsole;
		nixosConfigurations.nuclearbombwsl = nixpkgs.lib.nixosSystem {
			inherit system;
			specialArgs = {
				inherit inputs;
				inherit unstable-pkgs;
				inherit claude-code-nix;
				enable_vscode = false;
				keyboard = {
					device = "by-path/pci-0000\\:00\\:14.0-usb-0\\:2.2\\:1.1-event-kbd";
				};
			};
			modules = [
				nix-index-database.nixosModules.nix-index
				./nuclearbombwsl/configuration.nix
				nixos-wsl.nixosModules.wsl
			];
		};
		nixosConfigurations.nuclearbombconsole = nixpkgs.lib.nixosSystem {
			inherit system;
			specialArgs = {
				inherit inputs;
				inherit unstable-pkgs;
				inherit claude-code-nix;
				enable_vscode = true;
				keyboard = {
					device = "by-path/platform-i8042-serio-0-event-kbd";
				};
			};
			modules = [
				nix-index-database.nixosModules.nix-index

				./nuclearbombconsole/configuration.nix
			];
		};
		nixosConfigurations.nuclearbombwarhead = nixpkgs.lib.nixosSystem {
			inherit system;
			specialArgs = {
				inherit inputs;
				inherit unstable-pkgs;
				inherit claude-code-nix;
				enable_vscode = true;
				keyboard = {
					device = "by-path/pci-0000\\:00\\:14.0-usb-0\\:2.3\\:1.1-event-kbd";
				};
			};
			modules = [
				nix-index-database.nixosModules.nix-index

				./nuclearbombwarhead/configuration.nix
			];
		};
	};
}
