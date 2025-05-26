{
  pkgs,
  config,
  lib,
  host,
  ...
}: let
  inherit (lib) mkEnableOption types mkIf;
  cfg = config.hmModules.programs.swaync;
  colours = config.stylix.base16Scheme;
in {
  options.hmModules.programs.swaync = {
    enable = mkEnableOption "Enable swaync";
  };
  config = mkIf cfg.enable {
    home.packages = [pkgs.swaynotificationcenter];
    home.file.".config/swaync/config.json".source = ./swaync.json;
    home.file.".config/swaync/style.css".source = ./swaync.css;
    wayland.windowManager.hyprland.settings = {
      layerrule = [
        "blur,swaync-control-center"
        "blur,swaync-notification-window"
        "ignorezero,swaync-control-center"
        "ignorezero,swaync-notification-window"
        "ignorealpha 0.8,swaync-control-center"
        "ignorealpha 0.8,swaync-notification-window"
      ];
      bind = [
        "SUPER, A, exec, swaync-client -t "
        "SUPERSHIFT, A, exec, swaync-client -C"
      ];
    };
  };
}
