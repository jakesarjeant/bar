{
	cage,
	stdenv,
	esbuild,
	inputs,
	accountsservice,
	writeShellScript,
	system
}:
let
	name = "shell";

	ags = inputs.ags.packages.${system}.default.override {
		extraPackages = [accountsservice];
	};

	dependencies = [];

	addBins = list:
		builtins.concatStringsSep ":" (builtins.map (p: "${p}/bin") list);

	desktop = writeShellScript name ''
		export PATH=$PATH:${addBins dependencies};
		${cage}/bin/cage -b ${name} -c ${config}/main.js $@
	'';

	greeter = writeShellScript "greeter" ''
		export PATH=$PATH:${addBins dependencies};
		${cage}/bin/cage -ds -m last ${ags}/bin/ags -- -c ${config}/greeter.js
	'';

	config = stdenv.mkDerivation {
		inherit name;
		src = ./.;
		
		buildPhase = ''
			${esbuild}/bin/esbuild \
				--bundle ./main.ts \
				--outfile=main.js \
				--format=esm \
				--external:resource://\* \
				--external:gi://\* \

			${esbuild}/bin/esbuild \
				--bundle ./greeter/greeter.ts \
				--outfile=greeter.js \
				--format=esm \
				--external:resource://\* \
				--external:gi://\* \
		'';

    installPhase = ''
      mkdir -p $out
      cp -r assets $out
      cp -r style $out
      cp -r greeter $out
      cp -r widget $out
      cp -f main.js $out/config.js
      cp -f greeter.js $out/greeter.js
    '';
	};
in
	stdenv.mkDerivation {
		inherit name;
		src = config;
		installPhase = ''
			mkdir -p $out/bin
			cp -r . $out
			cp ${desktop} $out/bin/${name}
			cp ${greeter} $out/bin/greeter
		'';
	}
