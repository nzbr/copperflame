{ stdenv
, powershell
, pandoc
, roboto-slab
, jetbrains-mono
, copperflame
, pandoc-filter-bibtex
, texlive-copperflame
, ... }:

stdenv.mkDerivation {
  name = "copperflame-examples";
  src = ./.;
  nativeBuildInputs = [
    powershell
    pandoc
    pandoc-filter-bibtex
    texlive-copperflame

    roboto-slab
    jetbrains-mono
  ];

  inherit copperflame;

  buildPhase = ''
    mkdir -p $out
    pwsh ./build.ps1
  '';
  installPhase = "true";
}
