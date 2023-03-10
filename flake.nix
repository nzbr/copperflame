{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            stack
            pandoc
            tectonic
            gnumake
            powershell
            self.packages.${system}.pandoc-filter-bibtex
          ];
        };

        packages = {
          copperflame = pkgs.callPackage (
            { stdenv, powershell, ... }:
            stdenv.mkDerivation {
              name = "copperflame";
              src = ./.;
              buildInputs = [
                 powershell
              ];
              unpackPhase = ''
                export HOME=$NIX_BUILD_TOP
                mkdir build
                cp -r $src/. build
                chmod -R +w build
                cd build
              '';
              buildPhase = ''
                pwsh colors/generator/generator.ps1
              '';
              installPhase = ''
                mkdir -p $out
                cp -r . $out
               '';
            }
          ) { };
          pandoc-filter-bibtex = pkgs.callPackage ./pandoc/pandoc-filter-bibtex { };
          texlive-copperflame = (pkgs.texlive.combine {
            inherit (pkgs.texlive)
              scheme-small
              environ
              framed
              tcolorbox
              ;
          });
          examples = pkgs.callPackage ./examples self.packages.${system};
        };
      }
    );

}
