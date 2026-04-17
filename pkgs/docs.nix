{
  inputs,
  pkgs,
  lib,
  system,
}:
inputs.ndg.packages.${system}.ndg-builder.override {
  title = "orangc's Flake Documentation";
  inputDir = ../../docs;
  optionsDepth = 30;
  rawModules = lib.singleton ../modules;
  specialArgs = { inherit pkgs; };
  moduleArgs = {
    pkgs = pkgs;
  };
}
