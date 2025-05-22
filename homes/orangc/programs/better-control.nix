{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.hmModules.programs.better-control;
in {
  options.hmModules.programs.better-control = {
    enable = mkEnableOption "Enable better-control";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [better-control pulseaudio];
  };
}
