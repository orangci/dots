{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkOption types;
in
  with lib; {
    imports = [./hyprlock.nix];
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
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        extraConfig = concatStrings [
          ''source = ~/dots/hm-modules/programs/hyprland/hyprland.conf''
        ];
      };
    };
  }
