{
	description = "A purely structural code editor";

	inputs = {
		nixpkgs.url     = "github:nixos/nixpkgs/nixpkgs-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils }:
		flake-utils.lib.eachDefaultSystem(system:
			let
				pkgs     = nixpkgs.legacyPackages.${system};
				version  = "0.0.1";
				src      = self;
			in rec {
				packages = {
					struct-edit = pkgs.rustPlatform.buildRustPackage {
						inherit src version;
						pname              = "struct-edit";
						cargoSha256        = "sha256-ah8IjShmivS6IWL3ku/4/j+WNr/LdUnh1YJnPdaFdcM=";
						cargoLock.lockFile = "${self}/Cargo.lock";
					};

					default = packages.struct-edit;
				};

				devShells.default = pkgs.mkShell {
					nativeBuildInputs = with pkgs; [
						rustup
						gdb
						mold
						gnumake
					];
				};
			}
		);
}
