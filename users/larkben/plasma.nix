{ 
	config,
	pkgs,
	hostname,
	uses_plasma
}:
{
	plasma = {
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
		powerdevil = {
			AC = {
				autoSuspend = {
					action = "nothing";
				};
				turnOffDisplay = {
					idleTimeout = "never";
				};
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
			"kwinrc"."Xwayland"."Scale" = 1;
			"plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
			"spectaclerc"."GuiConfig"."captureMode" = 0;
			"spectaclerc"."ImageSave"."translatedScreenshotsFolder" = "Screenshots";
			"spectaclerc"."VideoSave"."translatedScreencastsFolder" = "Screencasts";
		} // (import ./desktops/${hostname}.nix);
		dataFile = {
			# Nothing, yet
		};
	};
}