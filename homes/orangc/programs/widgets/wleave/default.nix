{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.hmModules.programs.widgets.wleave;

  logoutScript = pkgs.writeShellScriptBin "logout-exit" ''
    wleave --css ~/.config/wleave/${
      if cfg.horizontal then "style_horizontal.css" else "style.css"
    } --layout ~/.config/wleave/${
      if cfg.horizontal then "layout_horizontal -b 5 -T 400 -B 400" else "layout -b 2 -L 600 -R 600"
    }
  '';
in
{
  options.hmModules.programs.widgets.wleave = {
    enable = mkEnableOption "Enable wleave";
    horizontal = mkOption {
      type = types.bool;
      default = false;
      description = "Use horizontal layout and style for wleave";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bindd = [ "SUPER, BACKSLASH, Open Logout Menu, exec, logout-exit" ];
      layerrule = [ "blur,logout_dialog" ];
    };
    home = {
      packages = [ logoutScript wleave ];
      file.".config/wleave" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
