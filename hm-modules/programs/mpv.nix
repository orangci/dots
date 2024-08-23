{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.mpv = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    programs.mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
    };
  };
}
