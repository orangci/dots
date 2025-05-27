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
          "sleep 3; arrpc &"
          "kdeconnect-indicator"
          "sleep 10; cd ~/code/pyminaret; python3 main.py --city Riyadh --country \"Saudi Arabia\" -g 10 -n"
        ];

        bindd =
          [
            "SUPER, E, Open File Manager, exec, thunar"
            # "SUPER, K, exec, rofi -show drun # application launcher rofi"
            # "SUPER, R, exec, rofi -show run -theme run.rasi" # run individual commands with rofi
            "SUPER, M, Open Minecraft Instance Menu, exec, rofi-prism" # minecraft launcher powered by prism and rofi
            # "SUPER, C, exec, rofi-calc"
            "SUPERALT, C, Colour Picker, exec, hyprpicker -a"
            "SUPERSHIFT, APOSTROPHE, Choose Wallpaper, exec, wall-select" # choose a wallpaper
            "SUPER, APOSTROPHE, Random Wallpaper, exec, wall-select --fast" # choose a wallpaper
            "SUPER, PERIOD, Select Emoji, exec, emoji-select a"
            "SUPERSHIFT, PERIOD, Select Emoji To Clipboard, exec, emoji-select"
            "SUPERSHIFT, M, Mute Microphone, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" # mute microphone
            "SUPER, P, Pause Media, exec, playerctl play-pause"
            "SUPERSHIFT, P, Next Media, exec, playerctl next"
            "SUPERALT, P, Previous Media, exec, playerctl previous"
            "SUPERSHIFT, SPACE, Move To Special Workspace, movetoworkspace,special"
            "SUPER, SPACE, Open Special Workspace, togglespecialworkspace"
            "SUPER, B, Blur/Unblur Current Window, exec, hyprctl setprop active opaque toggle # toggle transparency for le active window"
            "SUPERSHIFT, I, Toggle Split, togglesplit"
            "SUPERSHIFT, F, Float Current Window, togglefloating"
            "SUPER, Q, Close Window, killactive"
            "SUPER, F, Make Window Fullscreen, fullscreen,"
            "SUPER, left, Move Focus Left, movefocus,l"
            "SUPER, right, Move Focus Right, movefocus,r"
            "SUPER, up, Move Focus Up, movefocus,u"
            "SUPER, down, Move Focus Down, movefocus,d"
            "SUPERSHIFT, left, Move Window Left, movewindow,l"
            "SUPERSHIFT, right, Move Window Right, movewindow,r"
            "SUPERSHIFT, up, Move Window Up, movewindow,u"
            "SUPERSHIFT, down, Move Window Down, movewindow,d"
            ",mouse:275, Scroll Workspace Forward, workspace, e+1"
            ",mouse:276,Scroll Workspace Backward, workspace, e-1"
            "ALT,Tab, Cycle To Next Window, cyclenext"
            "ALT,Tab, Cycle To Next Window, bringactivetotop"
            ",XF86AudioMute, Mute Microphone, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioPlay, Play Media, exec, playerctl play-pause"
            ",XF86AudioPause, Pause Media, exec, playerctl play-pause"
            ",XF86AudioNext, Next Media, exec, playerctl next"
            ",XF86AudioPrev, Previous Media, exec, playerctl previous"
            ",XF86Mail, Open Special Workspace, togglespecialworkspace"
          ]
          ++ ( # workspaces: binds SUPER + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (i: let
                ws = i + 1;
              in [
                "SUPER, code:1${toString i}, Move To Workspace ${toString ws}, workspace, ${toString ws}"
                "SUPER SHIFT, code:1${toString i}, Move Window To Workspace ${toString ws}, movetoworkspace, ${toString ws}"
              ])
              9)
          );

        binddm = [
          "SUPER, mouse:272, Move Window, movewindow"
          "SUPER, mouse:273, Resize Window, resizewindow"
        ];

        bindde = [
          "SUPERCONTROL,right, Switch To Right Workspace, workspace,e+1"
          "SUPERCONTROL,left, Switch To Left Workspace, workspace,e-1"
          "SUPER, mouse_down, Switch To Right Workspace, workspace, e+1"
          "SUPER, mouse_up, Switch To Left Workspace, workspace, e-1"
          ",XF86AudioRaiseVolume, Raise Volume, exec,  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, Lower Volume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86MonBrightnessDown, Raise Brightness, exec, brightnessctl set 5%-"
          ",XF86MonBrightnessUp, Lower Brightness, exec, brightnessctl set +5%"
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
