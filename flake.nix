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
          };
          dejavucode-nerd-font = pkgs.stdenvNoCC.mkDerivation {
              name = "dejavucode-nerd-font";
              src = pkgs.fetchzip {
                url = "https://github.com/SSNikolaevich/DejaVuSansCode/releases/download/v1.2.2/dejavu-code-ttf-1.2.2.zip";
                sha256 = "sha256-208QBXkeQIMwawCDhVG4DNqlGh5GYfhTNJybzMZhE/4=";
              };
              noConfig = true;
              buildInputs = [
                pkgs.unzip
              ];
              installPhase = ''
                cd ttf
                mkdir -p $out/share/fonts/truetype
                for f in *; do
                  ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c $f -o $out/share/fonts/truetype/
                done
              '';
              meta = { description = "DejaVu with complete Nerd Font patching (2023-07-13)"; };
          };
          iwidejavu = pkgs.stdenvNoCC.mkDerivation {
              name = "iwidejavu";
              src = pkgs.fetchzip {
                url = "https://github.com/ToxicFrog/Ligaturizer/releases/download/v5/LigaturizedFonts.zip";
                sha256 = "sha256-2ywFe7khH4WRmQoKwkDHacqKOPGve5fYFaNYGoPJsQ4=";
                stripRoot = false;
              };
              noConfig = true;
              buildInputs = [
                pkgs.unzip
              ];
              installPhase = ''
                mkdir -p $out/share/fonts/truetype
                ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c $src/LigaDejaVuSansMono.ttf -o $out/share/fonts/truetype/
              '';
              meta = { description = "Custom dejavu Code with complete Nerd Font patching (2023-07-13)"; };
          }; in {
            packages = {
              inherit dejavusansmonocode-nerd-font;
              inherit dejavucode-nerd-font;
              inherit iwidejavu;
              default = iwidejavu;
            };
          }
    );
}
