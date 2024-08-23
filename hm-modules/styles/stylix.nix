{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.styles.stylix = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    stylix = {
      targets = {
        waybar.enable = false;
        rofi.enable = false;
        hyprland.enable = false;
        kde.enable = false;
      };
    };
  };
}
