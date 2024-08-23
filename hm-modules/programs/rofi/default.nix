{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  palette = config.stylix.base16Scheme;
in {
  imports = [
    ./selector.nix
    ./selector-big.nix
  ];
  options.hmModules.programs.name = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    programs.rofi = {
      package = pkgs.rofi-wayland;
      enable = true;
    };

    # Default rofi
    home.file."${config.xdg.configHome}/rofi/config.rasi".text = ''
      /*****----- Configuration -----*****/
      configuration {
        modi:                       "drun";
          show-icons:                 true;
          display-drun:               "drun :";
          display-run:                "";
          display-filebrowser:        "";
          display-window:             "";
        drun-display-format:        "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
        window-format:              "{w} · {c} · {t}";
          no-fading-openclose:        true;
          font:                 "Raleway Regular 14";
      }
      * {
          border-colour:               rgba(203, 166, 247, 85%);
          handle-colour:               rgba(203, 166, 247, 85%);
          background-colour:           rgba(30, 30, 46, 85%);
          foreground-colour:           #${palette.base05};
          normal-background:           rgba(30, 30, 46, 85%);
          normal-foreground:           #${palette.base05};
          urgent-foreground:           rgba(30, 30, 46, 85%);
          active-foreground:           rgba(30, 30, 46, 85%);
          selected-normal-background:  rgba(203, 166, 247, 85%);
          selected-normal-foreground:  rgba(30, 30, 46, 85%);
          selected-urgent-foreground:  rgba(30, 30, 46, 85%);
          selected-active-foreground:  rgba(30, 30, 46, 85%);
      }

      /*****----- Main Window -----*****/
      window {
          /* properties for window widget */
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  true;
          width:                       1366px;
          height:                      768px;
          x-offset:                    0px;
          y-offset:                    0px;

          /* properties for all widgets */
          enabled:                     true;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                rgba(203, 166, 247, 85%);
          cursor:                      "default";
          background-color:            transparent;
      }

      /*****----- Main Box -----*****/
      mainbox {
          enabled:                     true;
          spacing:                     20px;
          margin:                      0px;
          padding:                     25% 35%;
          border:                      0px solid;
          border-radius:               0px 0px 0px 0px;
          border-color:                rgba(203, 166, 247, 85%);
          background-color:            transparent;
          children:                    [ "inputbar", "listview" ];
      }

      /*****----- Inputbar -----*****/
      inputbar {
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     12px;
          border:                      0px;
          border-radius:               24px;
          border-color:                rgba(203, 166, 247, 85%);
          background-color:            rgba(30, 30, 46, 85%);
          text-color:                  #${palette.base05};
          children:                    [ "entry" ];
      }

      prompt {
          enabled:                     true;
          background-color:            transparent;
          text-color:                  inherit;
      }
      textbox-prompt-colon {
          enabled:                     true;
          expand:                      false;
          str:                         "::";
          background-color:            transparent;
          text-color:                  inherit;
      }
      entry {
          enabled:                     true;
          background-color:            transparent;
          text-color:                  inherit;
          cursor:                      text;
          placeholder:                 "Launch applications";
          placeholder-color:           inherit;
          vertical-align:              0.5;
          horizontal-align:            0.5;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          columns:                     1;
          lines:                       12;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                true;
          fixed-columns:               true;

          spacing:                     10px;
          margin:                      0px;
          padding:                     8px;
          border:                      0px solid;
          border-radius:               24px;
          border-color:                rgba(203, 166, 247, 85%);
          background-color:            rgba(30, 30, 46, 85%);
          text-color:                  #${palette.base05};
          cursor:                      "default";
      }
      scrollbar {
          handle-width:                5px ;
          handle-color:                rgba(203, 166, 247, 85%);
          border-radius:               0px;
          background-color:            rgba(69, 71, 90, 85%);
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     8px;
          border:                      0px solid;
          border-radius:               24px;
          border-color:                rgba(203, 166, 247, 85%);
          background-color:            transparent;
          text-color:                  #${palette.base05};
          cursor:                      pointer;
      }
      element normal.normal {
          background-color:            transparent;
          text-color:                  var(normal-foreground);
      }
      element normal.urgent {
          background-color:            var(urgent-background);
          text-color:                  var(urgent-foreground);
      }
      element normal.active {
          background-color:            var(active-background);
          text-color:                  var(active-foreground);
      }
      element selected.normal {
          background-color:            white / 5%;
          text-color:                  #${palette.base05};
      }
      element selected.urgent {
          background-color:            var(selected-urgent-background);
          text-color:                  var(selected-urgent-foreground);
      }
      element selected.active {
          background-color:            var(selected-active-background);
          text-color:                  var(selected-active-foreground);
      }

      element-icon {
          background-color:            transparent;
          text-color:                  inherit;
          size:                        32px;
          cursor:                      inherit;
      }
      element-text {
          background-color:            transparent;
          text-color:                  inherit;
          highlight:                   inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.0;
      }

      /*****----- Mode Switcher -----*****/
      mode-switcher{
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                rgba(203, 166, 247, 85%);
          background-color:            transparent;
          text-color:                  #${palette.base05};
      }
      button {
          padding:                     10px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                rgba(203, 166, 247, 85%);
          background-color:            rgba(69, 71, 90, 85%);
          text-color:                  inherit;
          cursor:                      pointer;
      }
      button selected {
          background-color:            rgba(203, 166, 247, 85%);
          text-color:                  rgba(30, 30, 46, 85%);
      }

      /*****----- Message -----*****/
      message {
          enabled:                     true;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px 0px 0px 0px;
          border-color:                rgba(203, 166, 247, 85%);
          background-color:            transparent;
          text-color:                  #${palette.base05};
      }
      textbox {
          padding:                     100px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                rgba(203, 166, 247, 85%);
          background-color:            rgba(69, 71, 90, 85%);
          text-color:                  #${palette.base05};
          vertical-align:              0.5;
          horizontal-align:            0.0;
          highlight:                   none;
          placeholder-color:           #${palette.base05};
          blink:                       true;
          markup:                      true;
      }
      error-message {
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                rgba(203, 166, 247, 85%);
          background-color:            rgba(30, 30, 46, 85%);
          text-color:                  #${palette.base05};
      }
        element.alternate.normal {
          background-color: transparent;
          text-color:       #${palette.base05};
        }
    '';

    # For running quick bash commands
    home.file.".config/rofi/run.rasi".text = ''
      @theme "~/.config/rofi/config.rasi"
      listview {
           enabled:                     false;
       }
       entry {
       placeholder:                 "Run a command...";
       }
    '';

    # Styling for the clipboard
    home.file.".config/rofi/clipboard.rasi".text = ''
      @theme "~/.config/rofi/config.rasi"
      inputbar {
           enabled:                     false;
       }
    '';
  };
}
