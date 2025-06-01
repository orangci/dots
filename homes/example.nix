{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.hmModules.category.example;
in
{
  options.hmModules.category.example = {
    enable = mkEnableOption "Enable the example module";

    hiThere = mkOption {
      type = types.str;
      default = "ohayo senpai~";
      description = "a friendly greeting";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hello
    ];

    home.sessionVariables.HELLO = cfg.hiThere;
  };
}
