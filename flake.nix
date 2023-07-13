{
  description = "Custom font for iwilare";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          dejavusansmonocode-nerd-font = pkgs.stdenvNoCC.mkDerivation {
              name = "dejavusansmonocode-nerd-font";
              src = pkgs.fetchzip {
                url = "https://github.com/mdschweda/dejavusansmonocode/releases/download/v1.1/DejaVuSansMonoCode.zip";
                sha256 = "sha256-MJPTJoKDzCEgbrYZ/66fHkLSpO34RDF5Jix+1n2Xfck=";
                stripRoot = false;
              };
              noConfig = true;
              buildInputs = [
                pkgs.unzip
              ];
              installPhase = ''
                mkdir -p $out/share/fonts/truetype
                for f in *.ttf; do
                  ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c $f -o $out/share/fonts/truetype/
                done
              '';
              meta = { description = "DejaVu Sans Code with complete Nerd Font patching (2023-07-13)"; };
          }; in {
            packages = {
              inherit dejavusansmonocode-nerd-font;
              default = dejavusansmonocode-nerd-font;
            };
          }
    );
}
