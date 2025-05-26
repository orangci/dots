{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.hmModules.programs.hyprland;
  colours = config.stylix.base16Scheme;
in {
  options.hmModules.programs.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

      settings = {
        env = [
          "NIXOS_OZONE_WL,1"
          "NIXPKGS_ALLOW_UNFREE,1"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "GDK_BACKEND,wayland,x11"
          "CLUTTER_BACKEND,wayland"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "QT_STYLE_OVERRIDE,kvantum-dark"
          "SDL_VIDEODRIVER,x11"
          "MOZ_ENABLE_WAYLAND,1"
        ];

        exec-once = [
          "dbus-update-activation-environment --systemd --all"
          "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "lxqt-policykit-agent"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "swww kill; swww-daemon"
          "sleep 3; walls &"
          "sleep 3; arrpc &"
          "kdeconnect-indicator"
          "sleep 10; cd ~/code/pyminaret; python3 main.py --city Riyadh --country \"Saudi Arabia\" -g 10 -n"
        ];

        bind =
          [
            "SUPER, E, exec, thunar"
            "SUPER, O, exec, screenrec"
            "SUPERALT, O, exec, screenrec mic"
            "SUPERSHIFT, O, exec, pkill wl-screenrec"
            # "SUPER, K, exec, rofi -show drun # application launcher rofi"
            # "SUPER, R, exec, rofi -show run -theme run.rasi" # run individual commands with rofi
            "SUPER, M, exec, rofi-prism" # minecraft launcher powered by prism and rofi
            # "SUPER, C, exec, rofi-calc"
            "SUPERALT, C, exec, hyprpicker -a"
            "SUPERSHIFT, APOSTROPHE, exec, wall-select" # choose a wallpaper
            "SUPER, APOSTROPHE, exec, wall-select --fast" # choose a wallpaper
            "SUPER, PERIOD, exec, emoji-select a"
            "SUPERSHIFT, PERIOD, exec, emoji-select"
            "SUPERSHIFT, M, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" # mute microphone
            "SUPER, P, exec, playerctl play-pause"
            "SUPERSHIFT, P, exec, playerctl next"
            "SUPERALT, P, exec, playerctl previous"
            "SUPER,  V, exec, cliphist list | rofi -dmenu -theme clipboard.rasi | cliphist decode | wl-copy" # open clipboard
            "SUPERSHIFT, V, exec, cliphist wipe # clear clipboard"
            "SUPERSHIFT, SPACE,movetoworkspace,special"
            "SUPER, SPACE,togglespecialworkspace"
            "SUPER, B, exec, hyprctl setprop active opaque toggle # toggle transparency for le active window"
            "SUPERSHIFT, I,togglesplit"
            "SUPERSHIFT, F,togglefloating"
            "SUPER, Q,killactive # kill active"
            "SUPER, F,fullscreen,"
            "SUPER, left,movefocus,l"
            "SUPER, right,movefocus,r"
            "SUPER, up,movefocus,u"
            "SUPER, down,movefocus,d"
            "SUPERSHIFT, left,movewindow,l"
            "SUPERSHIFT, right,movewindow,r"
            "SUPERSHIFT, up,movewindow,u"
            "SUPERSHIFT, down,movewindow,d"
            ",mouse:275,workspace, e+1"
            ",mouse:276,workspace, e-1"
            "ALT,Tab, cyclenext"
            "ALT,Tab, bringactivetotop"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioPlay, exec, playerctl play-pause"
            ",XF86AudioPause, exec, playerctl play-pause"
            ",XF86AudioNext, exec, playerctl next"
            ",XF86AudioPrev, exec, playerctl previous"
            ",XF86Mail, togglespecialworkspace"
            ",XF86Calculator, exec, rofi-calc"
          ]
          ++ ( # workspaces: binds SUPER + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (i: let
                ws = i + 1;
              in [
                "SUPER,  code:1${toString i}, workspace, ${toString ws}"
                "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ])
              9)
          );

        bindm = [
          "SUPER, mouse:272,movewindow"
          "SUPER, mouse:273,resizewindow"
        ];

        binde = [
          "SUPERCONTROL,right,workspace,e+1"
          "SUPERCONTROL,left,workspace,e-1"
          "SUPER, mouse_down,workspace, e+1"
          "SUPER, mouse_up,workspace, e-1"
          ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
          ",XF86MonBrightnessUp,exec,brightnessctl set +5%"
        ];

        monitor = [",preferred,auto,1"];

        general = {
          gaps_in = 6;
          gaps_out = 8;
          border_size = 0;
          # "col.active_border" = "rgba(${colours.base0E}ff)";
          # "col.inactive_border" = "rgba(${colours.base00}cc)";
          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = true;
        };

        input = {
          kb_layout = "us,ara";
          kb_variant = ",qwerty";
          kb_options = "compose:ins,grp:alt_caps_toggle";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = false;
          };
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          accel_profile = "flat";
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
        };

        misc = {
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };

        animations = {
          enabled = true;
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 6, winIn, slide"
            "windowsOut, 1, 5, winOut, slide"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 30, liner, loop"
            "fade, 1, 10, default"
            "workspaces, 1, 5, wind"
          ];
        };

        decoration = {
          rounding = 15;
          blur = {
            enabled = true;
            size = 6;
            passes = 3;
            popups = false;
            ignore_opacity = true;
            new_optimizations = true;
            xray = true;
          };
          inactive_opacity = 0.85;
          active_opacity = 0.965;
          fullscreen_opacity = 0.965;
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        windowrulev2 = [
          "opacity 1 override,class:^(Minecraft* 1.21)$"
          "opacity 1 override,class:^(zoom)$"
          "opacity 0.85 override 0.75 override 0.85 override,class:^(kitty)$"
          "opacity 0.85 override 0.75 override 0.85 override,class:^(thunar)$"
          "opacity 0.85 override 0.75 override 0.85 override,initialTitle:^(Open Folder)$"
          "opacity 0.85 override 0.75 override 0.85 override,class:^(codium-url-handler)$"
          "opacity 0.85 override 0.75 override 0.85 override,class:^(obsidian)$"
          "opacity 0.9 override 0.75 override 0.9 override,class:^(equibop)$"
          "noblur,class:^(zoom)$"
          "stayfocused,class:^(yad)$"
          # Picture-in-Picture
          "float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
          "keepaspectratio, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
          "move 73% 72%, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$ "
          "size 25%, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
          "float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
          "pin, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
          # Dialog windows – float+center these windows.
          "center, title:^(Open File)(.*)$"
          "center, title:^(Select a File)(.*)$"
          "center, title:^(Choose wallpaper)(.*)$"
          "center, title:^(Open Folder)(.*)$"
          "center, title:^(Save As)(.*)$"
          "center, title:^(File Upload)(.*)$"
          "float, title:^(Open File)(.*)$"
          "float, title:^(Select a File)(.*)$"
          "float, title:^(Choose wallpaper)(.*)$"
          "float, title:^(Open Folder)(.*)$"
          "float, title:^(Save As)(.*)$"
          "float, title:^(File Upload)(.*)$"
        ];
      };
    };
  };
}
