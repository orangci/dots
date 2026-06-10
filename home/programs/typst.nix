{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption singleton mkIf;
  cfg = config.hmModules.programs.typst;
in
{
  options.hmModules.programs.typst.enable =
    mkEnableOption "Typst typesetting language and document system";

  config = mkIf cfg.enable {
    hmModules.cli.shell.extraAliases = {
      "tp" = "typst";
      "tpf" = "typstyle -i .";
    };
    home.packages =
      with pkgs.typstPackages;
      [
        # plugins
        touying # using this instead of polylux, haven't tried polylux
        codly # using this instead of zebraw, haven't tried zebraw
        cetz
        fletcher
        unify
        equate
        quick-maths
        zero
        glossarium
        wordometer
        # templates
        elsearticle
        ilm
        basic-resume
        basic-academic-letter
        fireside
        diatypst
        bamdone-rebuttal
      ]
      ++ (with pkgs; [
        typst
        typst-live
        tinymist
        typstyle
      ]);
    programs.vscodium.profiles.default.userSettings."tinymist.formatterMode" = lib.mkForce "typstyle";
    programs.vscodium.profiles.default.extensions =
      singleton pkgs.vscode-extensions.myriad-dreamin.tinymist;
  };
}
