{ iosevka
, ...
}:

(iosevka.override (args: {
  set = "copperflame";
  privateBuildPlan = builtins.readFile ./build-configuration.toml;
})).overrideAttrs (args: {
  pname = "CopperflameMono";
})
