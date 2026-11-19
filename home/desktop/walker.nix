{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.hmModules.desktop.walker;
  colours = config.lib.stylix.colors.withHashtag;
in
{
  imports = [ inputs.walker.homeManagerModules.default ];
  options.hmModules.desktop.walker = {
    enable = mkEnableOption "the walker module";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      layer_rule = map lib.my.hyprlandLua.layerRule [
        "match:namespace walker, blur on"
        "match:namespace walker, ignore_alpha 0.8"
      ];
      bind = lib.my.hyprlandLua.bindd [
        "SUPER, R, Open Launcher, exec, walker"
        "SUPER, K, Open Launcher, exec, walker"
        "SUPER, PERIOD, Emoji Picker, exec, walker -m emojis"
        "SUPERSHIFT, PERIOD, Emoji Picker, exec, walker -m symbols"
        "SUPER, M, Launch Minecraft Instance, exec, walker -m minecraft"
        "SUPER, V, Open Clipboard, exec, walker -m clipboard"
        "SUPERSHIFT, V, Clear Clipboard, exec, walker --clear-clipboard"
      ];
    };
    wayland.windowManager.niri.settings = {
      _children = [
        {
          layer-rule = {
            match._props.namespace = "^walker$";
            background-effect = {
              blur = true;
              xray = false;
            };
          };
        }
      ];
      binds = {
        "Mod+R" = {
          _props.hotkey-overlay-title = "Open Launcher";
          spawn = [ "walker" ];
        };
        "Mod+K" = {
          _props.hotkey-overlay-title = "Open Launcher";
          spawn = [ "walker" ];
        };
        "Mod+Period" = {
          _props.hotkey-overlay-title = "Emoji Picker";
          spawn = [
            "walker"
            "-m"
            "emojis"
          ];
        };
        "Mod+Shift+Period" = {
          _props.hotkey-overlay-title = "Symbol Picker";
          spawn = [
            "walker"
            "-m"
            "symbols"
          ];
        };
        "Mod+M" = {
          _props.hotkey-overlay-title = "Launch Minecraft Instance";
          spawn = [
            "walker"
            "-m"
            "minecraft"
          ];
        };
        "Mod+V" = {
          _props.hotkey-overlay-title = "Open Clipboard";
          spawn = [
            "walker"
            "-m"
            "clipboard"
          ];
        };
        "Mod+Shift+V" = {
          _props.hotkey-overlay-title = "Clear Clipboard";
          spawn = [
            "walker"
            "--clear-clipboard"
          ];
        };
      };
    };
    programs.walker = {
      enable = true;
      runAsService = true;
      package = pkgs.walker;
      config = {
        theme = "nixos";
        force_keyboard_focus = true;
        close_when_open = true;
        selection_wrap = false;
        global_argument_delimiter = "#";
        keep_open_modifier = "shift";
        exact_search_prefix = "'";
        disable_mouse = false;
        shell = {
          anchor_top = true;
          anchor_bottom = true;
          anchor_left = true;
          anchor_right = true;
        };
        placeholders = {
          default = {
            input = "Search";
            list = "No Results";
          };
        };
        keybinds = {
          close = [ "Escape" ];
          next = [ "Down" ];
          previous = [ "Up" ];
          toggle_exact = [ "ctrl e" ];
          resume_last_query = [ "ctrl r" ];
        };
        providers = {
          default = [
            "desktopapplications"
            "calc"
            "runner"
            "menus"
            "websearch"
          ];
          empty = [ "desktopapplications" ];
          prefixes = [
            {
              prefix = ";";
              provider = "providerlist";
            }
            {
              prefix = "/";
              provider = "files";
            }
            {
              prefix = ".";
              provider = "symbols";
            }
            {
              prefix = "!";
              provider = "todo";
            }
            {
              prefix = "=";
              provider = "calc";
            }
            {
              prefix = "?";
              provider = "websearch";
            }
            {
              prefix = ":";
              provider = "clipboard";
            }
          ];
          calc = {
            click = "copy";
            copy = [ "Return" ];
            save = [ "ctrl s" ];
            delete = [ "ctrl d" ];
          };
          websearch = {
            click = "search";
            search = [ "Return" ];
          };
          providerlist = {
            click = "activate";
            activate = [ "Return" ];
          };
          clipboard = {
            time_format = "%b %d ~ %H:%M";
            click = "copy";
            copy = [ "Return" ];
            delete = [ "ctrl d" ];
            edit = [ "ctrl o" ];
            toggle_images_only = [ "ctrl i" ];
          };
          desktopapplications = {
            click = "start";
            start = [ "Return" ];
          };
          files = {
            click = "open";
            open = "Return";
            open_dir = [ "ctrl Return" ];
            copy_path = [ "ctrl shift C" ];
            copy_file = [ "ctrl c" ];
          };
          todo = {
            click = "save";
            save = [ "Return" ];
            delete = [ "ctrl d" ];
            mark_active = [ "ctrl a" ];
            mark_done = [ "ctrl f" ];
            clear = [ "ctrl shift X" ];
          };
          runner = {
            click = "start";
            start = [ "Return" ];
            start_terminal = "shift Return";
          };
          dmenu = {
            click = "select";
            select = [ "Return" ];
          };
          symbols = {
            click = "copy";
            copy = [ "Return" ];
          };
          unicode = {
            click = "copy";
            copy = [ "Return" ];
          };
          menus = {
            click = "activate";
            activate = [ "Return" ];
          };
        };
      };
      themes."nixos".style = ''
        @define-color window_bg_color ${colours.base00};
        @define-color accent_bg_color ${colours.base0E};
        @define-color theme_fg_color ${colours.base05};

        child:hover .item-box, child:selected .item-box { background: alpha(@accent_bg_color, 0.25); }
        .keybind-hints { opacity: 0.5; color: @theme_fg_color; }
        .item-box { border-radius: 10px; padding: 10px; }
        .item-subtext { font-size: 12px; opacity: 0.5; }
        .preview .large-icons { -gtk-icon-size: 64px; }
        .todo.done .item-text-box { opacity: 0.25; }
        .search-container { border-radius: 10px; }
        .symbols .item-image { font-size: 24px; }
        .normal-icons { -gtk-icon-size: 16px; }
        .large-icons { -gtk-icon-size: 32px; }
        .calc .item-text { font-size: 24px; }
        .input placeholder { opacity: 0.5; }
        .todo.active { font-weight: bold; }
        .item-image { margin-right: 10px; }
        .list { color: @theme_fg_color; }
        .todo.urgent { font-size: 24px; }
        .input:focus, .input:active { }
        scrollbar { opacity: 0; }
        .calc .item-subtext { }
        .content-container { }
        .item-text-box { }
        * { all: unset; }
        .preview-box { }
        .placeholder { }
        .item-text { }
        .scroll { }
        child { }
        .box { }

        .box-wrapper {
          box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3), 0 15px 12px rgba(0, 0, 0, 0.22);
          background: @window_bg_color;
          padding: 20px;
          border-radius: 20px;
        }

        .input {
          caret-color: @theme_fg_color;
          background: lighter(@window_bg_color);
          padding: 10px;
          color: @theme_fg_color;
        }

        .preview {
          border: 1px solid alpha(@accent_bg_color, 0.25);
          padding: 10px;
          border-radius: 10px;
          color: @theme_fg_color;
        }
      '';
    };
  };
}
