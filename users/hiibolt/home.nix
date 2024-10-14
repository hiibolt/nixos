{ 
	config,
	pkgs,
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
		inherit hostname;
		inherit uses_plasma;
	};

	# Stylization
	stylix = import ./stylix.nix {
		inherit config;
		inherit pkgs;
		inherit hostname;
		inherit uses_plasma;
	};
	
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
			source = ../../dotfiles/fish/config.fish;
		};
	};

	# Everything else
	programs = {
		git = {
			enable = true;
			userName = "hiibolt";
			userEmail = "me@hiibolt.com";
		};
		gh = {
			enable = true;
			settings = {
				version = "1";
				git_protocol = "https";
				editor = "";
				prompt = "enabled";
				pager = "";
				aliases = {
					co = "pr checkout";
				};
				http_unix_socket = "";
				browser = "";
			};
		};
		neovim = {
			enable = true;
			vimAlias = true;
			extraPackages = [ ];
			extraLuaPackages = ps: [ ];
			extraConfig = '''';
			extraLuaConfig = '''';
		};
		vscode = {
			enable = true;
			extensions = with pkgs.vscode-extensions; [
				# Development Environment
				github.copilot

				# Language Support
				bbenoist.nix
			]  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
				#{
				#	name = "remote-ssh-edit";
				#	publisher = "ms-vscode-remote";
				#	version = "0.47.2";
				#	sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
				#}
				#{
				#	name = "remote-ssh";
				#	publisher = "ms-vscode-remote";
				#	version = "0.116.2024100715";
				#	sha256 = "Mo11BGA27Bi62JRPU6INOq3SXTsp5ASYzd8ihlV3ZZY=";
				#}
				{
					name = "glassit";
					publisher = "s-nlf-fh";
					version = "0.2.6";
					sha256 = "LcAomgK91hnJWqAW4I0FAgTOwr8Kwv7ZhvGCgkokKuY=";
				}
				{
					name = "vscord";
					publisher = "LeonardSSH";
					version = "5.2.13";
					sha256 = "Jgm3ekXFLhylX7RM6tdfi+lRLrcl4UQGmRHbr27M59M=";
				}
				{
					name = "remote-explorer";
					publisher = "ms-vscode";
					version = "0.5.2024081309";
					sha256 = "YExf9Yyo7Zp0Nfoap8Vvtas11W9Czslt55X9lb/Ri3s=";
				}
				{
					name = "vscode-remote-extensionpack";
					publisher = "ms-vscode-remote";
					version = "0.25.0";
					sha256 = "CleLZvH40gidW6fqonZv/E/VO8IDI+QU4Zymo0n35Ns=";
				}
			];
			userSettings = {
				"editor.fontFamily" = "'DejaVu Sans Mono'";
  				"terminal.integrated.fontFamily" = "'DejaVu Sans Mono'";
  				"workbench.colorTheme" = "Stylix";
				"git.autofetch" = true;
				"security.workspace.trust.enabled" = false;
				"git.openRepositoryInParentFolders" = "always";
				"extensions.ignoreRecommendations" = true;
				"remote.SSH.useLocalServer" = false;

				# Extensions
				## Glassit
  				"glassit.alpha" = 235;

				## Discord RPC
				"vscord.status.details.text.idle" = "honk shoo mimimi";
				"vscord.status.details.text.notInFile" = "honk shoo mimimi";
				"vscord.status.state.text.idle" = "idling~";
				"vscord.app.name" = "Visual Studio Code";
			};
		};
	};
	
	# Persistence
	home.persistence."/persist/home/hiibolt" = {
		directories = [
			"Development"
			"Games"
			".gnupg"
			".ssh"
			".nixops"
			".local/share/keyrings"
			".local/share/kwalletd"

			# Shell & Dev
			".local/share/direnv"
			".local/share/fish"
			".config/Code"

			# Browser
			".librewolf"

			# Vesktop
			".config/vesktop"

			# Music
			".config/sh.cider.electron"

			# Games
			".local/share/lutris"
			".cache/winetricks"
			".cache/lutris"
			#{
			#		directory = ".local/share/Steam";
			#		method = "symlink";
			#}
		];
		files = [
			".screenrc"

			# Git
			".config/gh/hosts.yml"
		];
		allowOther = true;
	};
}
