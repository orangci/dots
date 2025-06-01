{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.styles.gtk;
in
{
  options.hmModules.styles.gtk = {
    enable = mkEnableOption "Enable GTK theming";
  };
  config = mkIf cfg.enable {
    gtk = {
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "mauve";
        };
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
