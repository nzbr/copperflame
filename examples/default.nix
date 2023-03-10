{ stdenv
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
    pandoc
    pandoc-filter-bibtex
    texlive-copperflame

    roboto-slab
    jetbrains-mono
  ];
  buildPhase = ''
    pandoc --to=beamer beamer.md -o beamer.tex --template=${copperflame}/pandoc/copperflame.tex --highlight-style=${copperflame}/pandoc/copperflame.theme --filter pandoc-filter-bibtex

    for x in *.tex; do
      xelatex $x
      bibtex ''${x%.*}
      xelatex $x
      xelatex $x
    done
  '';
  installPhase = ''
    mkdir -p $out
    cp *.tex *.pdf $out
  '';
}
