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
            gnumake
            inkscape
            nodePackages.pnpm
            nodejs
            pandoc
            powershell
            roboto-slab
            stack
            tectonic
            self.packages.${system}.pandoc-filter-bibtex
            self.packages.${system}.texlive-copperflame
          ];
        };

        checks = {
          nixpkgs-fmt = pkgs.runCommand "check-nixpkgs-fmt" { nativeBuildInputs = [ pkgs.nixpkgs-fmt ]; } ''
            nixpkgs-fmt --check ${./.}
            touch $out
          '';
        };

        packages = {

          copperflame =
            let
              modules = (pkgs.mkPnpmPackage {
                src = ./.;
                copyPnpmStore = false;
              }).passthru.nodeModules;
            in
            pkgs.callPackage
              (
                { stdenv, powershell, nodejs, inkscape, roboto-slab, jetbrains-mono, perfect-dos-vga, ... }:
                stdenv.mkDerivation {
                  name = "copperflame";
                  src = ./.;

                  buildInputs = [
                    powershell
                    nodejs
                    inkscape
                    roboto-slab
                  ];

                  robotoSlab = roboto-slab;
                  jetbrainsMono = jetbrains-mono;
                  perfectDosVga = perfect-dos-vga;

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
                    sed -E '/%NONIX$/d;s/^(\s*)%NIX /\1/' -i pandoc/partials/copperflame-common.tex
                    substituteAll pandoc/partials/copperflame-common.tex pandoc/partials/copperflame-common.tex
                  '';
                  installPhase = ''
                    mkdir -p $out
                    cp -r . $out
                  '';
                }
              )
              self.packages.${system};

          mkCopperflamePandoc = pkgs.callPackage
            (
              { stdenv, pandoc, copperflame, pandoc-filter-bibtex, texlive-copperflame, ... }:
              attrs: stdenv.mkDerivation (attrs // {
                nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [
                  pandoc
                  pandoc-filter-bibtex
                  (attrs.texlive or texlive-copperflame)
                ];

                inherit copperflame;
              })
            )
            self.packages.${system};

          perfect-dos-vga = pkgs.callPackage ./assets/perfect-dos-vga { };

          pandoc-filter-bibtex = pkgs.callPackage ./pandoc/pandoc-filter-bibtex { };

          texlive-scheme-copperflame = {
            inherit (pkgs.texlive)
              scheme-small

              datetime2
              environ
              framed
              tcolorbox
              ;
          };

          texlive-copperflame = pkgs.texlive.combine self.packages.${system}.texlive-scheme-copperflame;

          examples = pkgs.callPackage ./examples self.packages.${system};

        };
      }
    );

}
