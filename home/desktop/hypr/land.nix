{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe
    singleton
    ;
  cfg = config.hmModules.desktop.hypr.land;
  hypr = lib.my.hyprlandLua;
in
{
  options.hmModules.desktop.hypr.land = {
    enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    home.packages = singleton pkgs.hyprshutdown;
    wayland.windowManager.hyprland = {
      # Hyprland 0.55+ uses Lua; Home Manager then writes hyprland.lua.
      configType = "lua";
      enable = true;
      systemd.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      settings = {
        env = map hypr.env [
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
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
          "QT_STYLE_OVERRIDE,breeze-dark"
          "SDL_VIDEODRIVER,x11"
          "MOZ_ENABLE_WAYLAND,1"
        ];

        on = map hypr.onStart [
          "dbus-update-activation-environment --systemd --all"
          "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "lxqt-policykit-agent"
        ];

        bind =
          hypr.bindd [
            "SUPER, E, Open File Manager, exec, thunar"
            "SUPERALT, C, Colour Picker, exec, ${getExe pkgs.hyprpicker} -a"
            "SUPER, PERIOD, Select Emoji, exec, emoji-select a"
            "SUPERSHIFT, PERIOD, Select Emoji To Clipboard, exec, emoji-select"
            "SUPERSHIFT, M, Mute Microphone, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            "SUPER, P, Pause Media, exec, playerctl play-pause"
            "SUPERSHIFT, P, Next Media, exec, playerctl next"
            "SUPERALT, P, Previous Media, exec, playerctl previous"
            "SUPERSHIFT, SPACE, Move To Special Workspace, movetoworkspace,special"
            "SUPER, SPACE, Open Special Workspace, togglespecialworkspace"
            "SUPER, B, Blur/Unblur Current Window, exec, hyprctl setprop active opaque toggle # toggle transparency for le active window"
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
            # "ALT,Tab, Cycle To Next Window, cycle-next"
            "ALT,Tab, Cycle To Next Window, bringactivetotop"
            ",XF86AudioMute, Mute Microphone, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioPlay, Play Media, exec, playerctl play-pause"
            ",XF86AudioPause, Pause Media, exec, playerctl play-pause"
            ",XF86AudioNext, Next Media, exec, playerctl next"
            ",XF86AudioPrev, Previous Media, exec, playerctl previous"
            ",XF86Mail, Open Special Workspace, togglespecialworkspace"
          ]
          ++
            # workspaces: binds SUPER + [shift +] {1..9} to [move to] workspace {1..9}
            (hypr.bindd (
              builtins.concatLists (
                builtins.genList (
                  i:
                  let
                    ws = i + 1;
                  in
                  [
                    "SUPER, code:1${toString i}, Move To Workspace ${toString ws}, workspace, ${toString ws}"
                    "SUPER SHIFT, code:1${toString i}, Move Window To Workspace ${toString ws}, movetoworkspace, ${toString ws}"
                  ]
                ) 9
              )
            ))
          ++ hypr.binddm [
            "SUPER, mouse:272, Move Window, movewindow"
            "SUPER, mouse:273, Resize Window, resizewindow"
          ]
          ++ hypr.bindde [
            "SUPERCONTROL,right, Switch To Right Workspace, workspace,e+1"
            "SUPERCONTROL,left, Switch To Left Workspace, workspace,e-1"
            "SUPER, mouse_down, Switch To Right Workspace, workspace, e+1"
            "SUPER, mouse_up, Switch To Left Workspace, workspace, e-1"
            ",XF86AudioRaiseVolume, Raise Volume, exec,  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, Lower Volume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86MonBrightnessDown, Raise Brightness, exec, brightnessctl set 5%-"
            ",XF86MonBrightnessUp, Lower Brightness, exec, brightnessctl set +5%"
          ];

        monitor = [
          {
            _args = [
              {
                output = "";
                mode = "preferred";
                position = "auto";
                scale = 1;
              }
            ];
          }
        ];

        config = {
          general = {
            gaps_in = 6;
            gaps_out = 8;
            border_size = 0;
            # "col.active_border" = "rgba(${colours.base0E}ff)";
            # "col.inactive_border" = "rgba(${colours.base00}cc)";
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

          misc = {
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            focus_on_activate = true;
            force_default_wallpaper = 1; # 2 to force hyprchan to be the default
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
            active_opacity = 1; # 0.965 previously, but
            fullscreen_opacity = 0.965;
          };

          dwindle = {
            preserve_split = true;
          };
        };

        gesture = [
          {
            _args = [
              {
                fingers = 3;
                direction = "left";
                action = "workspace";
              }
            ];
          }
          {
            _args = [
              {
                fingers = 3;
                direction = "right";
                action = "workspace";
              }
            ];
          }
        ];

        curve = [
          {
            _args = [
              "wind"
              {
                type = "bezier";
                points = [
                  [
                    0.05
                    0.9
                  ]
                  [
                    0.1
                    1.05
                  ]
                ];
              }
            ];
          }
          {
            _args = [
              "winIn"
              {
                type = "bezier";
                points = [
                  [
                    0.1
                    1.1
                  ]
                  [
                    0.1
                    1.1
                  ]
                ];
              }
            ];
          }
          {
            _args = [
              "winOut"
              {
                type = "bezier";
                points = [
                  [
                    0.3
                    (-0.3)
                  ]
                  [
                    0
                    1
                  ]
                ];
              }
            ];
          }
          {
            _args = [
              "liner"
              {
                type = "bezier";
                points = [
                  [
                    1
                    1
                  ]
                  [
                    1
                    1
                  ]
                ];
              }
            ];
          }
        ];

        animation = [
          {
            _args = [
              {
                leaf = "windows";
                enabled = true;
                speed = 6;
                bezier = "wind";
                style = "slide";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "windowsIn";
                enabled = true;
                speed = 6;
                bezier = "winIn";
                style = "slide";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "windowsOut";
                enabled = true;
                speed = 5;
                bezier = "winOut";
                style = "slide";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "windowsMove";
                enabled = true;
                speed = 5;
                bezier = "wind";
                style = "slide";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "border";
                enabled = true;
                speed = 1;
                bezier = "liner";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "borderangle";
                enabled = true;
                speed = 30;
                bezier = "liner";
                style = "loop";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "fade";
                enabled = true;
                speed = 10;
                bezier = "default";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "workspaces";
                enabled = true;
                speed = 5;
                bezier = "wind";
              }
            ];
          }
        ];

        window_rule = map hypr.windowRule [
          "match:class ^(zoom)$, opacity 1 override"
          "match:class ^(kitty)$, opacity 0.85 override 0.75 override 0.85 override"
          "match:class ^(thunar)$, opacity 0.85 override 0.75 override 0.85 override"
          "match:initial_title ^(Open Folder)$, opacity 0.85 override 0.75 override 0.85 override"
          "match:class ^(codium-url-handler)$, opacity 0.85 override 0.75 override 0.85 override"
          "match:class ^(obsidian)$, opacity 0.85 override 0.75 override 0.85 override"
          "match:class ^(equibop)$, opacity 0.9 override 0.75 override 0.9 override"
          "match:class ^(zoom)$, no_blur on"
          "match:class ^(yad)$, stay_focused on"
          # Picture-in-Picture
          "match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$, move 73% 72%"
          "match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$, size 25% 25%"
          "match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$, pin on"
          # Dialog windows – float+center these windows.
          "match:title ^(Open File)(.*)$, center on"
          "match:title ^(Select a File)(.*)$, center on"
          "match:title ^(Choose wallpaper)(.*)$, center on"
          "match:title ^(Open Folder)(.*)$, center on"
          "match:title ^(Save As)(.*)$, center on"
          "match:title ^(File Upload)(.*)$, center on"
          "match:title ^(Open File)(.*)$, float on"
          "match:title ^(Select a File)(.*)$, float on"
          "match:title ^(Choose wallpaper)(.*)$, float on"
          "match:title ^(Open Folder)(.*)$, float on"
          "match:title ^(Save As)(.*)$, float on"
          "match:title ^(File Upload)(.*)$, float on"
        ];
      };
    };
  };
}
