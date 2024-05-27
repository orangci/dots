{
  pkgs,
  config,
  lib,
  inputs,
  host,
  ...
}: let
  theme = config.colorScheme.palette;
  hyprplugins = inputs.hyprland-plugins.packages.${pkgs.system};
  inherit
    (import ../../hosts/${host}/options.nix)
    browser
    cpuType
    gpuType
    wallpaperDir
    theKBDLayout
    terminal
    theSecondKBDLayout
    theKBDVariant
    sdl-videodriver
    extraMonitorSettings
    ;
in
  with lib; {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      plugins = [
        # hyprplugins.hyprtrails
      ];
      extraConfig = let
        modifier = "SUPER";
      in
        concatStrings [
          ''
            monitor=,preferred,auto,1
            ${extraMonitorSettings}
            general {
              gaps_in = 6
              gaps_out = 8
              border_size = 2
              col.active_border = rgba(${theme.base0E}ff) rgba(${theme.base0E}ff) rgba(${theme.base0E}ff) rgba(${theme.base0E}ff) 45deg
              col.inactive_border = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg
              layout = dwindle
              resize_on_border = true
            }

            input {
              kb_layout = ${theKBDLayout}, ${theSecondKBDLayout}
              kb_variant = ${theKBDVariant}
              kb_options = compose:ins, grp:alt_caps_toggle
              follow_mouse = 1
              touchpad {
                natural_scroll = false
              }
              sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
              accel_profile = flat
            }





            # >>> ENVIRONMENT VARIABLES <<<
            env = NIXOS_OZONE_WL, 1
            env = NIXPKGS_ALLOW_UNFREE, 1
            env = XDG_CURRENT_DESKTOP, Hyprland
            env = XDG_SESSION_TYPE, wayland
            env = XDG_SESSION_DESKTOP, Hyprland
            env = GDK_BACKEND, wayland
            env = CLUTTER_BACKEND, wayland
            env = SDL_VIDEODRIVER, ${sdl-videodriver}
            env = QT_QPA_PLATFORM, wayland
            env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
            env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
            env = MOZ_ENABLE_WAYLAND, 1
            ${
              if cpuType == "vm"
              then ''
                env = WLR_NO_HARDWARE_CURSORS,1
                env = WLR_RENDERER_ALLOW_SOFTWARE,1
              ''
              else ''
              ''
            }
            ${
              if gpuType == "nvidia"
              then ''
                env = WLR_NO_HARDWARE_CURSORS,1
              ''
              else ''
              ''
            }




            # >>> WINDOW RULES <<<
            windowrule = opacity 1.0 override 1.0 override 1.0 override,^(Zoom)$
            windowrule = noblur,^(Zoom)$
            windowrule = opacity 1.0 override 1.0 override 1.0 override,^(Minecraft)$




            # >>> Animations & Stuff <<<
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
              rounding = 15
              drop_shadow = false
              blur {
                  enabled = true
                  size = 6
                  passes = 3
                  ignore_opacity = true
                  popups = true
                  new_optimizations = true
                  xray = true
              }
              inactive_opacity = 0.85
              active_opacity = 0.925
              fullscreen_opacity = 0.925
            }
            plugin {
              hyprtrails {
                color = rgba(${theme.base0A}ff)
              }
            }


            # >>> STARTUP COMMANDS <<<
            exec-once = $POLKIT_BIN
            exec-once = dbus-update-activation-environment --systemd --all
            exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
            exec-once = swww init
            exec-once = waybar
            exec-once = swaync
            exec-once = wallsetter
            exec-once = nm-applet --indicator
            exec-once = swayidle -w timeout 720 'hyprlock' timeout 800 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'hyprlock'
            exec-once = wl-paste --type text --watch cliphist store #Stores only text data
            exec-once = wl-paste --type image --watch cliphist store #Stores only image data
            exec-once = arrpc
            exec-once = noisetorch -i
            dwindle {
              pseudotile = true
              preserve_split = true
            }
            master {
              new_is_master = true
            }



            # >>> KEYBINDINDS <<<
            bind = ${modifier},Return,exec,${terminal}
            bind = ALT,SPACE,exec,rofi-launcher
            bind = ${modifier}SHIFT,W,exec,web-search
            bind = ${modifier}SHIFT,N,exec,swaync-client -rs
            ${
              if browser == "google-chrome"
              then ''
                bind = ${modifier},W,exec,google-chrome-stable
              ''
              else ''
                bind = ${modifier},W,exec,${browser}
              ''
            }
            bind = ${modifier},PERIOD,exec,emopicker9000
            bind = ${modifier},S,exec,screenshootin
            bind = ${modifier},D,exec,vesktop
            bind = ${modifier},P,exec,playerctl play-pause
            bind = ${modifier},R,exec,rofi -show run -theme run.rasi
            bind = ${modifier},C,exec,codium
            bind = ${modifier},O,exec,obsidian
            bind = ${modifier},A,exec,task-waybar
            bind = ${modifier},G,exec,google-chrome-stable
            bind = ${modifier},E,exec,thunar
            bind = ${modifier},Q,killactive
            bind = ${modifier},SEMICOLON,pseudo
            bind = ${modifier}SHIFT,I,togglesplit
            bind = ${modifier}SHIFT,V,exec,cliphist wipe
            bind = ${modifier}SHIFT,C,exec,grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:- | tail -n 1 | cut -d ' ' -f 4 | wl-copy
            bind = ${modifier},F,fullscreen,
            bind = ${modifier}SHIFT,F,togglefloating
            bind = ${modifier}SHIFT,left,movewindow,l
            bind = ${modifier}SHIFT,right,movewindow,r
            bind = ${modifier}SHIFT,up,movewindow,u
            bind = ${modifier}SHIFT,down,movewindow,d
            bind = ${modifier},left,movefocus,l
            bind = ${modifier},right,movefocus,r
            bind = ${modifier},up,movefocus,u
            bind = ${modifier},down,movefocus,d
            bind = ${modifier},l,exec,hyprlock
            bind = ${modifier},BACKSLASH,exec,rofi-powermenu
            bind = ${modifier},1,workspace,1
            bind = ${modifier},2,workspace,2
            bind = ${modifier},3,workspace,3
            bind = ${modifier},4,workspace,4
            bind = ${modifier},5,workspace,5
            bind = ${modifier},6,workspace,6
            bind = ${modifier},7,workspace,7
            bind = ${modifier},8,workspace,8
            bind = ${modifier},9,workspace,9
            bind = ${modifier},0,workspace,10
            bind = ${modifier}SHIFT,1,movetoworkspace,1
            bind = ${modifier}SHIFT,2,movetoworkspace,2
            bind = ${modifier}SHIFT,3,movetoworkspace,3
            bind = ${modifier}SHIFT,4,movetoworkspace,4
            bind = ${modifier}SHIFT,5,movetoworkspace,5
            bind = ${modifier}SHIFT,6,movetoworkspace,6
            bind = ${modifier}SHIFT,7,movetoworkspace,7
            bind = ${modifier}SHIFT,8,movetoworkspace,8
            bind = ${modifier}SHIFT,9,movetoworkspace,9
            bind = ${modifier}SHIFT,0,movetoworkspace,10
            bind = ${modifier}CONTROL,right,workspace,e+1
            bind = ${modifier}CONTROL,left,workspace,e-1
            bind = ${modifier},mouse_down,workspace, e+1
            bind = ${modifier},mouse_up,workspace, e-1
            bindm = ${modifier},mouse:272,movewindow
            bindm = ${modifier},mouse:273,resizewindow
            bind = ALT,Tab,cyclenext
            bind = ALT,Tab,bringactivetotop
            bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
            bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            bind = ,XF86AudioPlay, exec, playerctl play-pause
            bind = ,XF86AudioPause, exec, playerctl play-pause
            bind = ,XF86AudioNext, exec, playerctl next
            bind = ,XF86AudioPrev, exec, playerctl previous
            bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
            bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
            bind = SUPER, V, exec, cliphist list | rofi -dmenu -theme clipboard.rasi | cliphist decode | wl-copy
          ''
        ];
    };
  }
