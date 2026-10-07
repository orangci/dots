{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.hmModules.desktop.niri;
in
{
  options.hmModules.desktop.niri = {
    enable = mkEnableOption "Enable the Niri module";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.niri = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-gtk;
    };
  };
}
