{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkOption types;
in
with lib; {
  options.hmModules.programs.hyprland = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      extraConfig = concatStrings [
        ''source = ~/dots/hm-modules/programs/hyprland/hyprland.conf''
      ];
    };
  };
}
