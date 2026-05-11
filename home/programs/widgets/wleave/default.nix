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
    wleave -x -k --css ${
      if cfg.horizontal then "~/.config/wleave/style_horizontal.css" else "~/.config/wleave/style.css"
    } --layout ${
      if cfg.horizontal then
        "~/.config/wleave/layout_horizontal -b 5 -T 400 -B 400"
      else
        "~/.config/wleave/layout -b 2 -L 600 -R 600"
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
      layerrule = [ "blur,wleave" ];
    };
    home = {
      packages = [
        logoutScript
        pkgs.wleave
      ];
      file.".config/wleave" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
