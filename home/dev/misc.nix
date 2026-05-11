{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.dev.misc;
in
{
  options.hmModules.dev.misc.enable = mkEnableOption "Enable the misc dev module";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gcc
      jq
      nodejs
    ];
  };
}
