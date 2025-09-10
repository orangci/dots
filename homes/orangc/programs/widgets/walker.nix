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
    mkOption
    types
    mkIf
    ;
  cfg = config.hmModules.programs.widgets.walker;
  colours = config.stylix.base16Scheme;
in
{
  imports = [ inputs.walker.homeManagerModules.default ];
  options.hmModules.programs.widgets.walker = {
    enable = mkEnableOption "Enable the walker module";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      layerrule = [
        "blur,walker"
        "ignorezero,walker"
        "ignorealpha 0.8,walker"
      ];
      bindd = [
        "SUPER, R, Walker, exec, walker"
        "SUPER, PERIOD, Emoji Picker, exec, walker -m emojis"
        "SUPERSHIFT, PERIOD, Emoji Picker, exec, walker -m symbols"
        "SUPER, M, Launch Minecraft Instance, exec, walker -m minecraft"
        "SUPER, V, Open Clipboard, exec, walker -m clipboard"
        "SUPERSHIFT, V, Clear Clipboard, exec, walker --clear-clipboard"
      ];
    };
    home.file."${config.xdg.configHome}/hypr/xdph.conf".text = ''
      screencopy {
          custom_picker_binary=${config.xdg.configHome}/hypr/walker_xdph_picker
      }
    '';
    home.file."${config.xdg.configHome}/hypr/walker_xdph_picker" = {
      text = ''walker -n --modules xdphpicker'';
      executable = true;
    };
    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        force_keyboard_focus = false;
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
          close = "esc";
          next = "down";
          previous = "up";
          toggle_exact = "ctrl e";
          resume_last_query = "ctrl r";
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
            copy = "enter";
            save = "ctrl s";
            delete = "ctrl d";
          };
          websearch = {
            click = "search";
            search = "enter";
          };
          providerlist = {
            click = "activate";
            activate = "enter";
          };
          clipboard = {
            time_format = "%b %d ~ %H:%M";
            click = "copy";
            copy = "enter";
            delete = "ctrl d";
            edit = "ctrl o";
            toggle_images_only = "ctrl i";
          };
          desktopapplications = {
            click = "start";
            start = "enter";
          };
          files = {
            click = "open";
            open = "enter";
            open_dir = "ctrl enter";
            copy_path = "ctrl shift C";
            copy_file = "ctrl c";
          };
          todo = {
            click = "save";
            save = "enter";
            delete = "ctrl d";
            mark_active = "ctrl a";
            mark_done = "ctrl f";
            clear = "ctrl shift X";
          };
          runner = {
            click = "start";
            start = "enter";
            start_terminal = "shift enter";
          };
          dmenu = {
            click = "select";
            select = "enter";
          };
          symbols = {
            click = "copy";
            copy = "enter";
          };
          unicode = {
            click = "copy";
            copy = "enter";
          };
          menus = {
            click = "activate";
            activate = "enter";
          };
        };
      };
      theme.style = ''
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
