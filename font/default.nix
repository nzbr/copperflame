{ stdenvNoCC
, fetchzip
, iosevka
, fontforge
, parallel
, ...
}:
let
  unpatched = (iosevka.override (args: {
    set = "copperflame";
    privateBuildPlan = builtins.readFile ./build-configuration.toml;
  })).overrideAttrs (args: {
    pname = "CopperflameMono";
  });
in
stdenvNoCC.mkDerivation {
  name = "CopperflameMono Nerd Font";

  src = fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FontPatcher.zip";
    stripRoot = false;
    hash = "sha256-koZj0Tn1HtvvSbQGTc3RbXQdUU4qJwgClOVq1RXW6aM=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ fontforge parallel ];

  buildPhase = ''
    runHook preBuild

    parallel -j $NIX_BUILD_CORES fontforge --script $src/font-patcher --complete ::: ${unpatched}/share/fonts/truetype/*.ttf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp -vr ${unpatched}/share/fonts/truetype/. $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  preFixup = ''
    chmod -x $out/share/fonts/truetype/*.ttf
  '';

  passthru = {
    inherit unpatched;
  };
}
