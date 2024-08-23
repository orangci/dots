{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.wlogout = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    programs.wlogout.enable = true;
    home.file.".config/wlogout" = {
      source = ./config;
      recursive = true;
    };
  };
}
