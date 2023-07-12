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
          commitmono = pkgs.stdenvNoCC.mkDerivation {
              name = "commitmono-font";
              src = ./.;
              noConfig = true;
              buildInputs = [
                pkgs.unzip
              ];
              installPhase = ''
                mkdir fonts
                unzip $src/CommitMono.zip -d fonts
                mkdir -p $out/share/fonts
                cp -R fonts/ $out/share/fonts/opentype/
              '';
              meta = { description = "Commit mono derivation 2023-07-12."; };
          }; in {
            packages = {
              inherit commitmono;
              default = commitmono;
            };
          }
    );
}


        # defaultPackage = pkgs.symlinkJoin {
        #   name = "iwifonts-1.0";
        #   paths = builtins.attrValues
        #     self.packages.${system}; # Add font derivation names here
        # };

        # packages.gillsans = pkgs.stdenvNoCC.mkDerivation {
        #   name = "gillsans-font";
        #   dontConfigue = true;
        #   src = pkgs.fetchzip {
        #     url =
        #       "https://cdn.freefontsvault.com/wp-content/uploads/2020/02/03141445/Gill-Sans-Font-Family.zip";
        #     sha256 = "sha256-YcZUKzRskiqmEqVcbK/XL6ypsNMbY49qJYFG3yZVF78=";
        #     stripRoot = false;
        #   };
        #   installPhase = ''
        #     mkdir -p $out/share/fonts
        #     cp -R $src $out/share/fonts/opentype/
        #   '';
        #   meta = { description = "A Gill Sans Font Family derivation."; };
        # };

        # packages.palatino = pkgs.stdenvNoCC.mkDerivation {
        #   name = "palatino-font";
        #   dontConfigue = true;
        #   src = pkgs.fetchzip {
        #     url =
        #       "https://www.dfonts.org/wp-content/uploads/fonts/Palatino.zip";
        #     sha256 = "sha256-FBA8Lj2yJzrBQnazylwUwsFGbCBp1MJ1mdgifaYches=";
        #     stripRoot = false;
        #   };
        #   installPhase = ''
        #     mkdir -p $out/share/fonts
        #     cp -R $src/Palatino $out/share/fonts/truetype/
        #   '';
        #   meta = { description = "The Palatino Font Family derivation."; };
        # };
