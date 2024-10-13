{ 
	config,
	pkgs,
	inputs,
	impermanence,
	wallpaper
}:
{ 
	imports = [
		inputs.impermanence.nixosModules.home-manager.impermanence
	];

	# HM-only Stylix options
	stylix = {
		targets.kde = {
			enable = true;
			service = true;
		};
		fonts.sizes = {
			applications = 10;
			desktop = 8;
		};
		#opacity = {
		#	applications = 0.9;
		#	desktop = 0.9;
		#	popups = 0.9;
		#	terminal = 0.9;
		#};
	};

	home.stateVersion = "23.11"; # Please read the comment before changing
	home.file = {
		".config/fish/config.fish" = {
			source = ../../dotfiles/fish/config.fish;
		};
	};

	# KDE Plasma 6 Configuration
	programs.plasma = {
		enable = true;
		workspace = {
			clickItemTo = "open";
			lookAndFeel = "org.kde.breezedark.desktop";
			cursor = {
				theme = "Bibata-Modern-Ice";
				size = 25;
			};
		};
		shortcuts = {
			kwin = {
				"Increase Opacity" = "Meta+U";
				"Decrease Opacity" = "Meta+O";
				"Window Maximize"  = "Meta+Alt+D";
			};
		};
		configFile = {
			"baloofilerc"."General"."dbVersion" = 2;
			"baloofilerc"."General"."exclude filters" = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found";
			"baloofilerc"."General"."exclude filters version" = 9;
			"kactivitymanagerdrc"."activities"."35f6587d-eec1-4283-a0e8-300a6b1a889a" = "Default";
			"kactivitymanagerdrc"."main"."currentActivity" = "35f6587d-eec1-4283-a0e8-300a6b1a889a";
			"kcminputrc"."Mouse"."cursorSize" = 25;
			"kded5rc"."Module-device_automounter"."autoload" = false;
			"kdeglobals"."KDE"."SingleClick" = true;
			"kdeglobals"."WM"."activeBackground" = "27,25,46";
			"kdeglobals"."WM"."activeBlend" = "126,147,166";
			"kdeglobals"."WM"."activeForeground" = "211,229,241";
			"kdeglobals"."WM"."inactiveBackground" = "27,25,46";
			"kdeglobals"."WM"."inactiveBlend" = "144,156,204";
			"kdeglobals"."WM"."inactiveForeground" = "211,229,241";
			"kwalletrc"."Wallet"."First Use" = false;
			"kwinrc"."Desktops"."Id_1" = "783299e3-3440-4116-b9d0-845941cc0e51";
			"kwinrc"."Desktops"."Id_2" = "9d30429e-a316-48ba-838c-3385fa16c0f6";
			"kwinrc"."Desktops"."Id_3" = "d24dfdcb-1ed5-4ce1-824f-06b115df8873";
			"kwinrc"."Desktops"."Number" = 3;
			"kwinrc"."Desktops"."Rows" = 2;
			"kwinrc"."Tiling"."padding" = 12;
			"kwinrc"."Tiling/cbc2ee2d-43b8-5fed-8410-299addbcca52"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"layoutDirection\":\"vertical\",\"tiles\":[{\"height\":0.45833333333333337},{\"height\":0.5416666666666666}],\"width\":0.3911458333333333},{\"width\":0.6088541666666627}]}";
			"kwinrc"."Tiling/d3b153ee-5d4a-5046-a2e9-ded4dc797d82"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.6083333333333305},{\"width\":0.3916666666666695}]}";
			"kwinrc"."Xwayland"."Scale" = 1;
			"plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
			"spectaclerc"."GuiConfig"."captureMode" = 0;
			"spectaclerc"."ImageSave"."translatedScreenshotsFolder" = "Screenshots";
			"spectaclerc"."VideoSave"."translatedScreencastsFolder" = "Screencasts";
		};
		dataFile = {
			# Nothing, yet
		};
	};	

	# Everything else
	programs = {
		git = {
			enable = true;
			userName = "hiibolt";
			userEmail = "my_git_username@gmail.com";
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
		vscode = {
			enable = true;
			extensions = with pkgs.vscode-extensions; [
				# Development Environment
				github.copilot

				# Language Support
				bbenoist.nix
			]  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
				{
					name = "remote-ssh-edit";
					publisher = "ms-vscode-remote";
					version = "0.47.2";
					sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
				}
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
			];
			userSettings = {
				"editor.fontFamily" = "'DejaVu Sans Mono'";
  				"terminal.integrated.fontFamily" = "'DejaVu Sans Mono'";
  				"workbench.colorTheme" = "Stylix";
				"git.autofetch" = true;
				"security.workspace.trust.enabled" = false;

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