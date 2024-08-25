{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.ags = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    home.packages = [pkgs.hyprpanel];
  };
}
