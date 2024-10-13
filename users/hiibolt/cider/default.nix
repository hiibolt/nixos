{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
  , appimageTools ? pkgs.appimageTools
  , lib ? pkgs.lib
  , fetchurl ? pkgs.fetchurl
}:

appimageTools.wrapType2 rec {
  pname = "cider";
  version = "2.5.0";

  src = fetchurl {
    url = "file://${./Cider-${version}.AppImage}";
    sha256 = "HwfByY8av1AvI+t7wnaNbhDLXBxgzRKYiLG1hPUto9o=";
  };

	extraInstallCommands =
	    let
		contents = appimageTools.extract { inherit pname version src; };
	    in 
		# mv $out/bin/${pname}-${version} $out/bin/${pname}
		''
	        install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
	        substituteInPlace $out/share/applications/${pname}.desktop \
		  --replace 'Exec=AppRun' 'Exec=${pname}'
	        cp -r ${contents}/usr/share/icons $out/share
	    	''; 
}
