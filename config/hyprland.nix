{ config
, lib
, host
, ...
}:
let
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
    # hyprplugins.hyprtrailss
    # ];
    extraConfig = concatStrings [
      ''
            monitor=,preferred,auto,1
            ${extraMonitorSettings}
            general {
              gaps_in = 6
              ${if boxyStyle then ''gaps_out = 0'' else ''gaps_out = 8''}
              border_size = 2
              ${if boxyStyle then ''
            col.active_border = rgba(${theme.base00}ff) rgba(${theme.base00}ff) rgba(${theme.base00}ff) rgba(${theme.base00}ff) 45deg
            col.inactive_border = rgba(${theme.base00}cc) rgba(${theme.base00}cc) 45deg'' else ''
            col.active_border = rgba(${theme.base0E}ff) rgba(${theme.base0E}ff) rgba(${theme.base0E}ff) rgba(${theme.base0E}ff) 45deg
            col.inactive_border = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg''}
              layout = dwindle
              resize_on_border = true
            }

            input {
              kb_layout = us,ara
              kb_variant = qwerty
              kb_options = compose:ins, grp:alt_caps_toggle
              follow_mouse = 1
              touchpad {
                natural_scroll = false
              }
              sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
              accel_profile = flat
            }
            gestures {
              workspace_swipe = true
              workspace_swipe_fingers = 3
            }
            misc {
              mouse_move_enables_dpms = true
              key_press_enables_dpms = false
            }
            animations {
                enabled = yes
                bezier = wind, 0.05, 0.9, 0.1, 1.05
                bezier = winIn, 0.1, 1.1, 0.1, 1.1
                bezier = winOut, 0.3, -0.3, 0, 1
                bezier = liner, 1, 1, 1, 1
                animation = windows, 1, 6, wind, slide
                animation = windowsIn, 1, 6, winIn, slide
                animation = windowsOut, 1, 5, winOut, slide
                animation = windowsMove, 1, 5, wind, slide
                animation = border, 1, 1, liner
                animation = borderangle, 1, 30, liner, loop
                animation = fade, 1, 10, default
                animation = workspaces, 1, 5, wind
            }
            decoration {
              ${if boxyStyle then ''rounding = 0'' else ''rounding = 15''}
              drop_shadow = false
              blur {
                  ${if boxyStyle then ''enabled = false'' else ''enabled = true''}
                  size = 6
                  passes = 3
                  ignore_opacity = true
                  popups = true
                  new_optimizations = true
                  xray = true
              }
              ${
          if boxyStyle then '''' else ''
            inactive_opacity = 0.85
            active_opacity = 0.925
            fullscreen_opacity = 0.925
          ''
        }

            }
            dwindle {
              pseudotile = true
              preserve_split = true
            }


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
