{
	description = "Jake's Bar";

  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
	inputs.ags.url = "github:Aylur/ags";


	outputs = {
		self,
		nixpkgs,
		flake-parts,
		...
	} @ inputs:
		flake-parts.lib.mkFlake {inherit inputs;} {
			systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
			];

			perSystem = {
				pkgs,
				system,
				...
			}: let
				nixpkgs' = nixpkgs.legacyPackages."${system}";
				ags = nixpkgs'.callPackage ./config {inherit inputs;};
			in {
				packages = {
					inherit ags;
					default = ags;
				};
				devShells.default = pkgs.mkShell {
					buildInputs = [inputs.ags.packages.${system}.default];

					shellHook = ''
						ags --init --config ./config/main.js
						rm ./config/main.js
					'';
				};
			};
		};
}
