{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.microfetch = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = {
    home.packages = [pkgs.microfetch];
  };
}
