{ config, ... }:
let
  palette = config.stylix.base16Scheme;
in
{
    # Powermenu
      home.file.".config/rofi/powermenu.rasi".text = ''
        /*****----- Configuration -----*****/
        configuration {
            show-icons:                 false;
            no-fading-openclose:        true;
        }

        /*****----- Global Properties -----*****/
        * {
            /* Resolution : 1920x1080 */
            mainbox-spacing:             50px;
            mainbox-margin:              50px;
            message-margin:              0px 300px;
            message-padding:             12px;
            message-border-radius:       12px;
            listview-spacing:            25px;
            element-padding:             35px 0px;
            element-border-radius:       60px;

            prompt-font:                 "JetBrainsMono NFM Bold 48";
            textbox-font:                "JetBrainsMono NFM 12";
            element-text-font:           "JetBrainsMono NFM 48";

            background-window:           #${palette.base00};
            background-normal:           #${palette.base02};
            background-selected:         #${palette.base0E};
            foreground-normal:           #${palette.base05};
            foreground-selected:         #${palette.base00};
        }

        /*****----- Main Window -----*****/
        window {
            transparency:                "real";
            location:                    center;
            anchor:                      center;
            fullscreen:                  false;
            width:                       1000px;
            border-radius:               50px;
            cursor:                      "default";
            background-color:            var(background-window);
        }

        /*****----- Main Box -----*****/
        mainbox {
            enabled:                     true;
            spacing:                     var(mainbox-spacing);
            margin:                      var(mainbox-margin);
            background-color:            transparent;
            children:                    [ "dummy", "inputbar", "listview", "message", "dummy" ];
        }

        /*****----- Inputbar -----*****/
        inputbar {
            enabled:                     true;
            background-color:            transparent;
            children:                    [ "dummy", "prompt", "dummy"];
        }

        dummy {
            background-color:            transparent;
        }

        prompt {
            enabled:                     true;
            font:                        var(prompt-font);
            background-color:            transparent;
            text-color:                  var(foreground-normal);
        }

        /*****----- Message -----*****/
        message {
            enabled:                     true;
            margin:                      var(message-margin);
            padding:                     var(message-padding);
            border-radius:               var(message-border-radius);
            background-color:            var(background-normal);
            text-color:                  var(foreground-normal);
        }
        textbox {
            font:                        var(textbox-font);
            background-color:            transparent;
            text-color:                  inherit;
            vertical-align:              0.5;
            horizontal-align:            0.5;
        }

        /*****----- Listview -----*****/
        listview {
            enabled:                     true;
            expand:                      false;
            columns:                     5;
            lines:                       1;
            cycle:                       true;
            dynamic:                     true;
            scrollbar:                   false;
            layout:                      vertical;
            reverse:                     false;
            fixed-height:                true;
            fixed-columns:               true;

            spacing:                     var(listview-spacing);
            background-color:            transparent;
            cursor:                      "default";
        }

        /*****----- Elements -----*****/
        element {
            enabled:                     true;
            padding:                     var(element-padding);
            border-radius:               var(element-border-radius);
            background-color:            var(background-normal);
            text-color:                  var(foreground-normal);
            cursor:                      pointer;
        }
        element-text {
            font:                        var(element-text-font);
            background-color:            transparent;
            text-color:                  inherit;
            cursor:                      inherit;
            vertical-align:              0.5;
            horizontal-align:            0.5;
        }
        element selected.normal {
            background-color:            var(background-selected);
            text-color:                  var(foreground-selected);
        }
      '';
      # Powermenu confirm menu
      home.file.".config/rofi/powermenu-confirm.rasi".text = ''
        /**
         *
         * Author : Aditya Shakya (adi1090x)
         * Github : @adi1090x
         *
         * Rofi Theme File
         * Rofi Version: 1.7.3
         **/

        /*****----- Configuration -----*****/
        configuration {
            show-icons:                 false;
            no-fading-openclose:        true;
        }

        /*****----- Main Window -----*****/
        window {
            location:                    center;
            anchor:                      center;
            fullscreen:                  false;
            width:                       500px;
            border-radius:               20px;
            cursor:                      "default";
            background-color:            #${palette.base00};
        }

        /*****----- Main Box -----*****/
        mainbox {
            spacing:                     30px;
            padding:                     30px;
            background-color:            transparent;
            children:                    [ "message", "listview" ];
        }

        /*****----- Message -----*****/
        message {
            margin:                      0px;
            padding:                     20px;
            border-radius:               20px;
            background-color:            #${palette.base02};
            text-color:                  #${palette.base05};
        }
        textbox {
            background-color:            inherit;
            text-color:                  inherit;
            vertical-align:              0.5;
            horizontal-align:            0.5;
            placeholder-color:           #${palette.base05};
            blink:                       true;
            markup:                      true;
        }

        /*****----- Listview -----*****/
        listview {
            columns:                     2;
            lines:                       1;
            cycle:                       true;
            dynamic:                     true;
            scrollbar:                   false;
            layout:                      vertical;
            reverse:                     false;
            fixed-height:                true;
            fixed-columns:               true;

            spacing:                     30px;
            background-color:            transparent;
            text-color:                  #${palette.base05};
            cursor:                      "default";
        }

        /*****----- Elements -----*****/
        element {
            padding:                     60px 10px;
            border-radius:               20px;
            background-color:            #${palette.base02};
            text-color:                  #${palette.base05};
            cursor:                      pointer;
        }
        element-text {
            font:                        "JetBrainsMono NFM 48";
            background-color:            transparent;
            text-color:                  inherit;
            cursor:                      inherit;
            vertical-align:              0.5;
            horizontal-align:            0.5;
        }
        element selected.normal {
            background-color:            #${palette.base0E};
            text-color:                  #${palette.base00};
        }
      '';
}