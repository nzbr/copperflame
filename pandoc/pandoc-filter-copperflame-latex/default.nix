{ stdenv
, haskellPackages
, ...
}:

stdenv.mkDerivation {
  name = "pandoc-filter-copeprflame-latex";
  nativeBuildInputs = [
    (haskellPackages.ghcWithPackages (hkgs: with hkgs; [
      pandoc-types
      regex-tdfa
    ]))
  ];
  src = ./src;
  buildPhase = ''
    ghc -dynamic Main
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp Main $out/bin/pandoc-filter-copperflame-latex
  '';
}
