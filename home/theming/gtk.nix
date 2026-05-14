{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.theming.gtk;
in
{
  options.hmModules.theming.gtk = {
    enable = mkEnableOption "Enable GTK theming";
  };
  config = mkIf cfg.enable {
    gtk = {
      gtk4.theme = config.gtk.theme;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    xresources.properties = {
      "Xcursor.size" = 20;
    };
  };
}
