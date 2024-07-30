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
    waybarEnable
    ;
in
with lib; {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
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


          # >>> STARTUP COMMANDS <<<
        exec-once = dbus-update-activation-environment --systemd --all
        exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = ags &
        ${if waybarEnable then '''' else ''# ''}exec-once = killall -q waybar;waybar
        exec-once = killall -q swaync;swaync
        # exec-once = nm-applet --indicator
        exec-once = lxqt-policykit-agent
        exec-once = clipse -listen
        exec-once = swww kill;swww-daemon
        exec-once = wallset
        # exec-once = blueman-applet
        exec-once = arrpc



        # >>> WINDOW RULES <<<
        windowrulev2 = opacity 1 override,title:^Minecraft
        windowrulev2 = opacity 1 override,class:^(zoom)$
        windowrulev2 = noblur,class:^(zoom)$
        windowrulev2 = float,class:(clipse) # ensure you have a floating window class set if you want this behaviour
        windowrulev2 = size 622 700,class:(clipse) # set the size of the window as necessary
        windowrulev2 = stayfocused,class:(clipse) # make this silly window stay focused
        layerrule = blur,logout_dialog
        layerrule = blur,swaync-control-center
        layerrule = blur,swaync-notification-window
        layerrule = ignorezero,swaync-control-center
        layerrule = ignorezero,swaync-notification-window
        layerrule = ignorealpha 0.8,swaync-control-center
        layerrule = ignorealpha 0.8,swaync-notification-window
        layerrule = blur,rofi
        layerrule = ignorezero,rofi
        layerrule = ignorealpha 0.8,rofi


        # >>> KEYBINDINDS <<<
        bind = SUPER,Return,exec,kitty # launch kitty
        bind = SUPER,K,exec,rofi -show drun -theme launcher.rasi # application launcher rofi
        bind = SUPER,R,exec,rofi -show run -theme run.rasi # run individual commands with rofi
        bind = SUPER,M,exec,rofi-prism-exec # minecraft launcher powered by prism and rofi
        bind = SUPER,C,exec,rofi-calc # calculator with rofi
        bind = SUPERSHIFT,W,exec,web-search # use various search engines with rofi
        bind = SUPER,A,exec,swaync-client -t # open swaync
        bind = SUPERSHIFT,A,exec,swaync-client -C # clear swaync notifs
        bind = SUPER,W,exec,firefox # launch firefox
        bind = SUPER,PERIOD,exec,bemoji -t # emoji picker w/ rofi
        bind = SUPER,S,exec,grimblast --freeze save area - | swappy -f - # screenshot an area
        bind = SUPERSHIFT,M,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle # mute microphone
        bind = SUPER,D,exec,discord # launch discord
        bind = SUPER,P,exec,playerctl play-pause # pause playerctl
        bind = SUPERSHIFT,P,exec,playerctl next # playerctl next
        bind = SUPERALT,P,exec,playerctl previous # playerctl previous
        bind = SUPERSHIFT,C,exec,codium # vscode
        bind = SUPER,O,exec,obs # obs
        bind = SUPER,G,exec,google-chrome-stable # chrome
        bind = SUPER,E,exec,thunar # file browser
        bind = SUPER,l,exec,killall hyprlock; hyprlock # lock screen
        bind = SUPER,BACKSLASH,exec,logout-exit # wlogout
        bind = SUPER,APOSTROPHE,exec,killall -q wallset;wallset # set random wallpaper
        bind = SUPER,V, exec,kitty --class clipse -e 'clipse' # open clipboard
        bind = SUPERSHIFT,V, exec,clipse -clear # clear clipboard

        # window control binds
        bind = SUPER,SEMICOLON,pseudo # idk tbh
        bind = SUPERSHIFT,I,togglesplit # again idk
        bind = SUPER,Q,killactive # kill active
        bind = SUPER,F,fullscreen,
        bind = SUPERSHIFT,F,togglefloating
        bind = SUPERSHIFT,left,movewindow,l
        bind = SUPERSHIFT,right,movewindow,r
        bind = SUPERSHIFT,up,movewindow,u
        bind = SUPERSHIFT,down,movewindow,d
        bind = SUPER,left,movefocus,l
        bind = SUPER,right,movefocus,r
        bind = SUPER,up,movefocus,u
        bind = SUPER,down,movefocus,d
        bind = SUPER,1,workspace,1
        bind = SUPER,2,workspace,2
        bind = SUPER,3,workspace,3
        bind = SUPER,4,workspace,4
        bind = SUPER,5,workspace,5
        bind = SUPER,6,workspace,6
        bind = SUPER,7,workspace,7
        bind = SUPER,8,workspace,8
        bind = SUPER,9,workspace,9
        bind = SUPER,0,workspace,10
        bind = SUPERSHIFT,1,movetoworkspace,1
        bind = SUPERSHIFT,2,movetoworkspace,2
        bind = SUPERSHIFT,3,movetoworkspace,3
        bind = SUPERSHIFT,4,movetoworkspace,4
        bind = SUPERSHIFT,5,movetoworkspace,5
        bind = SUPERSHIFT,6,movetoworkspace,6
        bind = SUPERSHIFT,7,movetoworkspace,7
        bind = SUPERSHIFT,8,movetoworkspace,8
        bind = SUPERSHIFT,9,movetoworkspace,9
        bind = SUPERSHIFT,0,movetoworkspace,10
        binde = SUPERCONTROL,right,workspace,e+1
        binde = SUPERCONTROL,left,workspace,e-1
        binde = SUPER,mouse_down,workspace, e+1
        binde = SUPER,mouse_up,workspace, e-1
        bindm = SUPER,mouse:272,movewindow
        bindm = SUPER,mouse:273,resizewindow
        bind = ,mouse:275,workspace, e+1
        bind = ,mouse:276,workspace, e-1
        bind = ALT,Tab,cyclenext
        bind = ALT,Tab,bringactivetotop
        # nothing to touch here
        binde = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        binde = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bind = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bind = ,XF86AudioPlay, exec, playerctl play-pause
        bind = ,XF86AudioPause, exec, playerctl play-pause
        bind = ,XF86AudioNext, exec, playerctl next
        bind = ,XF86AudioPrev, exec, playerctl previous
        binde = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
        binde = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
      ''
    ];
  };
}
