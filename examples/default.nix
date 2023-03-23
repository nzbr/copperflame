{ stdenv
, powershell
, pandoc
, copperflame
, pandoc-filter-bibtex
, texlive-copperflame
, ...
}:

stdenv.mkDerivation {
  name = "copperflame-examples";
  src = ./.;
  nativeBuildInputs = [
    powershell
    pandoc
    pandoc-filter-bibtex
    texlive-copperflame
  ];

  inherit copperflame;

  buildPhase = ''
    pwsh ./build.ps1
  '';
  installPhase = "true";
}
