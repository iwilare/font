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
                  ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c --progressbars $f -o $out/share/fonts/truetype/
                done
              '';
              meta = { description = "DejaVu Sans Code with complete Nerd Font patching (2023-07-13)"; };
          }; in {
            packages = {
              inherit dejavucode-nerd-font;
              default = dejavucode-nerd-font;
            };
          }
    );
}
