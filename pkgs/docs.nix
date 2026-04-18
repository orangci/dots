args@{
  inputs,
  pkgs,
  lib,
  system,
  flakeSettings,
  ...
}:
let
  docs-pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ inputs.aagl.overlays.default ];
  };
in
inputs.ndg.packages.${system}.ndg-builder.override {
  title = "orangc's Flake Documentation";
  inputDir = ../.;
  optionsDepth = 30;
  warningsAreErrors = false;
  rawModules = lib.singleton ../modules;
  specialArgs = args // {
    pkgs = docs-pkgs;
  };
  moduleArgs = {
    pkgs = docs-pkgs;
  };
}
