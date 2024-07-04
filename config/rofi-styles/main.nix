{ config, ... }:
let
  palette = config.stylix.base16Scheme;
in
{
    # Default rofi
  home.file.".config/rofi/config.rasi".text = ''
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
        }
        * {
            border-colour:               #${palette.base0E};
            handle-colour:               #${palette.base0E};
            background-colour:           #${palette.base00};
            foreground-colour:           #${palette.base05};
            normal-background:           #${palette.base00};
            normal-foreground:           #${palette.base05};
            urgent-foreground:           #${palette.base00};
            active-foreground:           #${palette.base00};
            selected-normal-background:  #${palette.base0E};
            selected-normal-foreground:  #${palette.base00};
            selected-urgent-foreground:  #${palette.base00};
            selected-active-foreground:  #${palette.base00};
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
            border-color:                #${palette.base0E};
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
            border-color:                #${palette.base0E};
            background-color:            transparent;
            children:                    [ "inputbar", "listview" ];
        }

        /*****----- Inputbar -----*****/
        inputbar {
            enabled:                     true;
            spacing:                     10px;
            margin:                      0px;
            padding:                     20px;
            border:                      0px;
            border-radius:               20px;
            border-color:                #${palette.base0E};
            background-color:            #${palette.base02};
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
            padding:                     30px;
            border:                      0px solid;
            border-radius:               20px;
            border-color:                #${palette.base0E};
            background-color:            #${palette.base02};
            text-color:                  #${palette.base05};
            cursor:                      "default";
        }
        scrollbar {
            handle-width:                5px ;
            handle-color:                #${palette.base0E};
            border-radius:               0px;
            background-color:            #${palette.base02};
        }

        /*****----- Elements -----*****/
        element {
            enabled:                     true;
            spacing:                     10px;
            margin:                      0px;
            padding:                     8px;
            border:                      0px solid;
            border-radius:               12px;
            border-color:                #${palette.base0E};
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
            border-color:                #${palette.base0E};
            background-color:            transparent;
            text-color:                  #${palette.base05};
        }
        button {
            padding:                     10px;
            border:                      0px solid;
            border-radius:               0px;
            border-color:                #${palette.base0E};
            background-color:            #${palette.base02};
            text-color:                  inherit;
            cursor:                      pointer;
        }
        button selected {
            background-color:            #${palette.base0E};
            text-color:                  #${palette.base00};
        }

        /*****----- Message -----*****/
        message {
            enabled:                     true;
            margin:                      0px;
            padding:                     0px;
            border:                      0px solid;
            border-radius:               0px 0px 0px 0px;
            border-color:                #${palette.base0E};
            background-color:            transparent;
            text-color:                  #${palette.base05};
        }
        textbox {
            padding:                     100px;
            border:                      0px solid;
            border-radius:               0px;
            border-color:                #${palette.base0E};
            background-color:            #${palette.base02};
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
            border-color:                #${palette.base0E};
            background-color:            #${palette.base00};
            text-color:                  #${palette.base05};
        }
         element.alternate.normal {
            background-color: #${palette.base02};
            text-color:       #${palette.base05};
         }

      '';
}