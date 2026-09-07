{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.thunderbird;
in
{
  options.hmModules.programs.thunderbird.enable = mkEnableOption "Enable the thunderbird module";
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = lib.my.hyprlandLua.bindd [
      "SUPER, T, Open Thunderbird, exec, thunderbird"
    ];
    programs.thunderbird = {
      # https://home-manager-options.extranix.com/?query=programs.thunderbird.&release=master
      enable = true;
      profiles.${config.home.username}.isDefault = true;
    };
  };
}
