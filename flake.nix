{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pnpm2nix.url = "github:nzbr/pnpm2nix-nzbr";
  };

  outputs = { self, nixpkgs, flake-utils, pnpm2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.appendOverlays [
          pnpm2nix.overlays.default
        ];
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
          copperflame =
           let
             modules = (pkgs.mkPnpmPackage {
               src = ./.;
               copyPnpmStore = false;
             }).passthru.nodeModules;
           in
           pkgs.callPackage (
            { stdenv, powershell, nodejs, ... }:
            stdenv.mkDerivation {
              name = "copperflame";
              src = ./.;
              buildInputs = [
                 powershell
                 nodejs
              ];
              unpackPhase = ''
                export HOME=$NIX_BUILD_TOP
                mkdir build
                cp -r $src/. build
                chmod -R +w build
                cd build
              '';
              configurePhase = ''
                ln -s ${modules} node_modules
              '';
              buildPhase = ''
                pwsh base16/build.ps1
                sed -i 's/^%NIX//' pandoc/copperflame-common.tex
                substituteAll pandoc/copperflame-common.tex pandoc/copperflame-common.tex
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
