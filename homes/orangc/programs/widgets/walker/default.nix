{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.hmModules.programs.widgets.walker;
in
{
  imports = [ inputs.walker.homeManagerModules.default ];
  options.hmModules.programs.widgets.walker = {
    enable = mkEnableOption "Enable the walker module";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      layerrule = [
        "blur,walker"
        "ignorezero,walker"
        "ignorealpha 0.8,walker"
      ];
      bindd = [
        "SUPER, R, Walker, exec, walker"
      ];
    };
    programs.walker = {
      enable = true;
      # runAsService = true;
      # config = {};
      # style = '''';
    };
  };
}
