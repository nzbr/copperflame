{ stdenv
, haskellPackages
, ...
}:

stdenv.mkDerivation {
  name = "pandoc-filter-bibtex";
  nativeBuildInputs = [
    (haskellPackages.ghcWithPackages (hkgs: with hkgs; [
      pandoc-types
    ]))
  ];
  src = ./src;
  buildPhase = ''
    ghc -dynamic Main
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp Main $out/bin/pandoc-filter-bibtex
  '';
}
