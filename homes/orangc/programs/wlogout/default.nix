{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption types mkIf;
  cfg = config.hmModules.programs.wlogout;
in {
  options.hmModules.programs.wlogout = {
    enable = mkEnableOption "Enable wlogout";
  };
  config = mkIf cfg.enable {
    programs.wlogout.enable = true;
    home.file.".config/wlogout" = {
      source = ./config;
      recursive = true;
    };
  };
}
