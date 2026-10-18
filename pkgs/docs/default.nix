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
  # fonts are copied beside the stylesheet so the rose pine css can load them
  assetsDir = pkgs.runCommand "docs-assets" { } ''
    cp -r ${../../assets} $out
    chmod -R u+w $out
    mkdir -p $out/fonts
    cp ${pkgs.lexend}/share/fonts/truetype/lexend/lexend/Lexend-{Regular,SemiBold}.ttf $out/fonts/
    cp ${pkgs.martian-mono}/share/fonts/opentype/MartianMono-Regular.otf $out/fonts/
  '';
in
inputs.ndg.packages.${system}.ndg-builder.override {
  title = "orangc's Flake Documentation";
  inputDir = ../../.;
  optionsDepth = 30;
  warningsAreErrors = false;
  stylesheets = [ ./theme.css ];
  rawModules = lib.my.recursivelyImport [ ../../modules ];
  extraConfig = {
    assets_dir = assetsDir;
    index.use_readme = true;
    template_dir = ./templates;
  };
  specialArgs = args // {
    pkgs = docs-pkgs;
  };
  moduleArgs = {
    pkgs = docs-pkgs;
  };
}
