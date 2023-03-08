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
            self.packages.${system}.filter-bibtex
          ];
        };

        packages.filter-bibtex = pkgs.callPackage ./pandoc/pandoc-filter-bibtex { };
      }
    );

}
