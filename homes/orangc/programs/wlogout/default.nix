{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.hmModules.programs.wlogout;

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
  options.hmModules.programs.wlogout = {
    enable = mkEnableOption "Enable wlogout";
    horizontal = mkOption {
      type = types.bool;
      default = false;
      description = "Use horizontal layout and style for wlogout";
    };
  };

  config = mkIf cfg.enable {
    programs.wlogout.enable = true;

    home.file.".config/wlogout" = {
      source = ./config;
      recursive = true;
    };

    home.packages = [logoutScript];
  };
}
