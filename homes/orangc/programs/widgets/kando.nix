{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    singleton
    types
    mkIf
    ;
  cfg = config.hmModules.programs.widgets.kando;
in
{
  options.hmModules.programs.widgets.kando = {
    enable = mkEnableOption "Enable the kando module";
  };

  config = mkIf cfg.enable {
    home.packages = singleton pkgs.kando;
    wayland.windowManager.hyprland.settings = {
      bind = singleton "SUPERCONTROL, Space, global, menu.kando.Kando:main";
      exec-once = singleton "kando";
      windowrule = [
        "noblur, class:kando"
        "opaque, class:kando"
        "size 100% 100%, class:kando"
        "noborder, class:kando"
        "noanim, class:kando"
        "float, class:kando"
        "pin, class:kando"
      ];

    };
  };
}
