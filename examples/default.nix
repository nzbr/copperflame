{ mkCopperflamePandoc
, powershell
, ...
}:

mkCopperflamePandoc {
  name = "copperflame-examples";
  src = ./.;
  nativeBuildInputs = [
    powershell
  ];

  buildPhase = ''
    pwsh ./build.ps1
  '';
  installPhase = "true";
}
