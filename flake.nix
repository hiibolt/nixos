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
			};
			modules = [
				nix-index-database.nixosModules.nix-index
				./devices/nuclearbombwsl/configuration.nix
				nixos-wsl.nixosModules.wsl
			];
		};
		nixosConfigurations.nuclearbombconsole = nixpkgs.lib.nixosSystem {
			inherit system;

			#
			# "nuclearbombconsole" is the laptop
			#

			specialArgs = {
				inherit inputs;
				inherit unstable-pkgs;
				inherit claude-code-nix;
				enable_vscode = true;
			};
			modules = [
				nix-index-database.nixosModules.nix-index

				./devices/nuclearbombconsole/configuration.nix
			];
		};
	};
}
