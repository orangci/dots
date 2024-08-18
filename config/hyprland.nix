{
  config,
  lib,
  host,
  pkgs,
  ...
}: let
  theme = config.stylix.base16Scheme;
  inherit
    (import ../hosts/${host}/variables.nix)
    extraMonitorSettings
    boxyStyle
    ;
in
  with lib; {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      # plugins = [
      # pkgs.hyprlandPlugins.hyprexpo
      # ];
      extraConfig = concatStrings [
        ''
          # >>> ENVIRONMENT VARIABLES <<<
          env = NIXOS_OZONE_WL, 1
          env = NIXPKGS_ALLOW_UNFREE, 1
          env = XDG_CURRENT_DESKTOP, Hyprland
          env = XDG_SESSION_TYPE, wayland
          env = XDG_SESSION_DESKTOP, Hyprland
          env = GDK_BACKEND, wayland, x11
          env = CLUTTER_BACKEND, wayland
          env = QT_QPA_PLATFORM=wayland;xcb
          env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
          env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
          env = SDL_VIDEODRIVER, x11
          env = MOZ_ENABLE_WAYLAND, 1
          env = NIXPKGS_ALLOW_UNFREE, 1

          source = ~/dots/config/hyprland.conf
        ''
      ];
    };
  }
