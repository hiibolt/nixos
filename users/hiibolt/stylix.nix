{ 
	config,
	pkgs,
	hostname,
	uses_plasma
}:
{
	stylix = {
		targets.kde = {
			enable = true;
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
}
