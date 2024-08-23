{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.styles.qt = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    qt = {
      enable = true;
      style.name = "adwaita-dark";
      platformTheme.name = "gtk3";
    };
  };
}
