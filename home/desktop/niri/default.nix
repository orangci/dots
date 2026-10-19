{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe
    ;
  cfg = config.hmModules.desktop.niri;

  # bind that shows up in the hotkey overlay (mod+shift+/)
  bind = title: action: action // { _props.hotkey-overlay-title = title; };
  spawn = title: command: bind title { spawn-sh = command; };

  # windows that were see-through on hyprland: active, inactive
  translucent = {
    "^kitty$" = [
      0.85
      0.75
    ];
    "^thunar$" = [
      0.85
      0.75
    ];
    "^codium(-url-handler)?$" = [
      0.85
      0.75
    ];
    "^obsidian$" = [
      0.85
      0.75
    ];
    "^equibop$" = [
      0.9
      0.75
    ];
  };
  dialogs = [
    "^Open File"
    "^Select a File"
    "^Choose wallpaper"
    "^Open Folder"
    "^Save As"
    "^File Upload"
  ];
in
{
  options.hmModules.desktop.niri = {
    enable = mkEnableOption "the Niri module";
  };

  config = mkIf cfg.enable {
    xdg.portal.config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      # the gnome portal wants nautilus for file pickers
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };

    wayland.windowManager.niri = {
      enable = true;
      settings = {
        prefer-no-csd = { };
        hotkey-overlay.skip-at-startup = { };
        screenshot-path = "${config.xdg.userDirs.pictures}/Screenshots/%Y-%m-%d_%H.%M.%S.png";

        environment = {
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          NIXOS_OZONE_WL = "1";
          NIXPKGS_ALLOW_UNFREE = "1";
          GDK_BACKEND = "wayland,x11";
          CLUTTER_BACKEND = "wayland";
          QT_QPA_PLATFORM = "wayland;xcb";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";
          QT_STYLE_OVERRIDE = "breeze-dark";
          SDL_VIDEODRIVER = "x11";
          MOZ_ENABLE_WAYLAND = "1";
        };

        input = {
          keyboard.xkb = {
            layout = "us,ara";
            variant = ",qwerty";
            options = "compose:ins,grp:alt_caps_toggle";
          };
          mouse.accel-profile = "flat";
          touchpad.tap = { };
          # focus follows the mouse, but don't scroll the view to do it
          focus-follows-mouse._props.max-scroll-amount = "0%";
          warp-mouse-to-focus = { };
        };

        layout = {
          gaps = 8;
          center-focused-column = "on-overflow";
          default-column-width.proportion = 0.5;
          preset-column-widths._children = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];
          focus-ring.off = { };
          border.off = { };
          shadow.on = { };
          background-color = "transparent";
        };

        overview.workspace-shadow.off = { };

        binds = {
          "Mod+Shift+Slash".show-hotkey-overlay = { };

          "Mod+E" = spawn "Open File Manager" "thunar";
          "Mod+Alt+C" = spawn "Colour Picker" "${getExe pkgs.hyprpicker} -a";
          "Mod+Shift+M" = spawn "Mute Microphone" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "Mod+P" = spawn "Pause Media" "playerctl play-pause";
          "Mod+Shift+P" = spawn "Next Media" "playerctl next";
          "Mod+Alt+P" = spawn "Previous Media" "playerctl previous";

          "Mod+Q" = bind "Close Window" { close-window = { }; };
          "Mod+F" = bind "Make Window Fullscreen" { fullscreen-window = { }; };
          "Mod+Alt+F" = bind "Maximise Column" { maximize-column = { }; };
          "Mod+Shift+F" = bind "Float Current Window" { toggle-window-floating = { }; };
          "Mod+B" = bind "Toggle Window Transparency" { toggle-window-rule-opacity = { }; };
          "Mod+Space" = bind "Open Overview" { toggle-overview = { }; };
          "Mod+C".center-column = { };
          "Mod+Alt+R".switch-preset-column-width = { };
          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+BracketLeft".consume-or-expel-window-left = { };
          "Mod+BracketRight".consume-or-expel-window-right = { };
          "Mod+Alt+T" = bind "Tab Column" { toggle-column-tabbed-display = { }; };

          "Mod+Left" = bind "Move Focus Left" { focus-column-left = { }; };
          "Mod+Right" = bind "Move Focus Right" { focus-column-right = { }; };
          "Mod+Up" = bind "Move Focus Up" { focus-window-or-workspace-up = { }; };
          "Mod+Down" = bind "Move Focus Down" { focus-window-or-workspace-down = { }; };
          "Mod+Shift+Left" = bind "Move Window Left" { move-column-left = { }; };
          "Mod+Shift+Right" = bind "Move Window Right" { move-column-right = { }; };
          "Mod+Shift+Up" = bind "Move Window Up" { move-window-up-or-to-workspace-up = { }; };
          "Mod+Shift+Down" = bind "Move Window Down" { move-window-down-or-to-workspace-down = { }; };

          # workspaces are stacked vertically in niri
          "Mod+Ctrl+Right" = bind "Switch To Next Workspace" { focus-workspace-down = { }; };
          "Mod+Ctrl+Left" = bind "Switch To Previous Workspace" { focus-workspace-up = { }; };
          "Mod+Ctrl+Down".focus-workspace-down = { };
          "Mod+Ctrl+Up".focus-workspace-up = { };
          "Mod+Ctrl+Shift+Down".move-column-to-workspace-down = { };
          "Mod+Ctrl+Shift+Up".move-column-to-workspace-up = { };
          "Mod+WheelScrollDown" = {
            _props.cooldown-ms = 150;
            focus-workspace-down = { };
          };
          "Mod+WheelScrollUp" = {
            _props.cooldown-ms = 150;
            focus-workspace-up = { };
          };
          "MouseForward".focus-workspace-up = { };
          "MouseBack".focus-workspace-down = { };

          "XF86AudioRaiseVolume" = {
            _props.allow-when-locked = true;
            spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          };
          "XF86AudioLowerVolume" = {
            _props.allow-when-locked = true;
            spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          };
          "XF86AudioMute" = {
            _props.allow-when-locked = true;
            spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
          "XF86AudioPlay".spawn-sh = "playerctl play-pause";
          "XF86AudioPause".spawn-sh = "playerctl play-pause";
          "XF86AudioNext".spawn-sh = "playerctl next";
          "XF86AudioPrev".spawn-sh = "playerctl previous";
          "XF86MonBrightnessUp".spawn-sh = "brightnessctl set +5%";
          "XF86MonBrightnessDown".spawn-sh = "brightnessctl set 5%-";
          "XF86Mail".toggle-overview = { };
        }
        # mod + [shift +] 1..9 to focus / move to workspace 1..9
        // lib.listToAttrs (
          lib.concatMap (
            i:
            let
              n = toString i;
            in
            [
              (lib.nameValuePair "Mod+${n}" (bind "Move To Workspace ${n}" { focus-workspace = i; }))
              (lib.nameValuePair "Mod+Shift+${n}" (
                bind "Move Window To Workspace ${n}" { move-column-to-workspace = i; }
              ))
            ]
          ) (lib.range 1 9)
        );

        _children = [
          {
            output = {
              _args = [ "HDMI-A-2" ];
              scale = 1.0;
            };
          }
          { spawn-at-startup = [ "lxqt-policykit-agent" ]; }
          { spawn-at-startup = [ "waybar" ]; }
          {
            window-rule = {
              geometry-corner-radius = 15;
              clip-to-geometry = true;
            };
          }
          {
            window-rule = {
              match._props.is-active = false;
              opacity = 0.85;
              background-effect = {
                blur = true;
                xray = false;
              };
            };
          }
        ]
        ++ lib.concatLists (
          lib.mapAttrsToList (appId: opacity: [
            {
              window-rule = {
                match._props.app-id = appId;
                opacity = builtins.elemAt opacity 0;
                background-effect = {
                  blur = true;
                  xray = false;
                };
              };
            }
            {
              window-rule = {
                match._props = {
                  app-id = appId;
                  is-active = false;
                };
                opacity = builtins.elemAt opacity 1;
              };
            }
          ]) translucent
        )
        ++ [
          {
            window-rule = {
              match._props.app-id = "^zoom$";
              opacity = 1.0;
              background-effect.blur = false;
            };
          }
          {
            window-rule = {
              match._props.title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)";
              open-floating = true;
              default-column-width.proportion = 0.25;
              default-window-height.proportion = 0.25;
              default-floating-position._props = {
                x = 32;
                y = 32;
                relative-to = "bottom-right";
              };
            };
          }
          {
            window-rule._children = map (title: { match._props = { inherit title; }; }) dialogs ++ [
              { open-floating = true; }
            ];
          }
          {
            # put the wallpaper in the backdrop so it stays put while workspaces scroll over it.
            # needs the transparent layout background-color, or workspaces cover it
            layer-rule = {
              match._props.namespace = "^awww-daemon";
              place-within-backdrop = true;
            };
          }
        ];
      };
    };
  };
}
