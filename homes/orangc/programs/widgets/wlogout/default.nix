{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.hmModules.programs.widgets.wlogout;

  logoutScript = pkgs.writeShellScriptBin "logout-exit" ''
    wlogout --css ~/.config/wlogout/${
      if cfg.horizontal
      then "style_horizontal.css"
      else "style.css"
    } --layout ~/.config/wlogout/${
      if cfg.horizontal
      then "layout_horizontal -b 5 -T 400 -B 400"
      else "layout -b 2 -L 600 -R 600"
    }
  '';
in {
  options.hmModules.programs.widgets.wlogout = {
    enable = mkEnableOption "Enable wlogout";
    horizontal = mkOption {
      type = types.bool;
      default = false;
      description = "Use horizontal layout and style for wlogout";
    };
  };

  config = mkIf cfg.enable {
    programs.wlogout.enable = true;
    wayland.windowManager.hyprland.settings = {
      bindd = ["SUPER, BACKSLASH, Open Logout Menu, exec, logout-exit"];
      layerrule = ["blur,logout_dialog"];
    };
    home = {
      packages = [logoutScript];
      file.".config/wlogout" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
