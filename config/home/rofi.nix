{
  pkgs,
  config,
  ...
}: let
  palette = config.colorScheme.palette;
in {
  # Default rofi
  home.file.".config/rofi/config.rasi".text = ''
      /**
     *
     * Author : Aditya Shakya (adi1090x)
     * Github : @adi1090x
     *
     * Rofi Theme File
     * Rofi Version: 1.7.3
     **/

    /*****----- Configuration -----*****/
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
    	modi:                       "drun";
        show-icons:                 true;
        display-drun:               "drun :";
        display-run:                "";
        display-filebrowser:        "";
        display-window:             "";
    	drun-display-format:        "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
    	window-format:              "{w} · {c} · {t}";
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
  # Application launcher
  # Default rofi
  home.file.".config/rofi/launcher.rasi".text = ''
      /**
     *
     * Author : Aditya Shakya (adi1090x)
     * Github : @adi1090x
     *
     * Rofi Theme File
     * Rofi Version: 1.7.3
     **/

    /*****----- Configuration -----*****/
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
    	modi:                       "drun";
        show-icons:                 true;
        display-drun:               "drun :";
        display-run:                "";
        display-filebrowser:        "";
        display-window:             "";
    	drun-display-format:        "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
    	window-format:              "{w} · {c} · {t}";
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
        lines:                       2;
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
  # Unused - fullscreen rofi
  home.file.".config/rofi/launcher-fullscreen.rasi".text = ''
    /*****----- Configuration -----*****/
     configuration {
     	modi:                       "drun";
         show-icons:                 true;
         display-drun:               " Applications";
     	drun-display-format:        "{name}";
     }

     /*****----- Main Window -----*****/
     window {
         transparency:                "real";
         location:                    center;
         anchor:                      center;
         fullscreen:                  true;
         width:                       1366px;
         height:                      768px;
         x-offset:                    0px;
         y-offset:                    0px;

         enabled:                     true;
         margin:                      0px;
         padding:                     0px;
         border:                      0px solid;
         border-radius:               0px;
         border-color:                #${palette.base0E};
         background-color:            transparent;
         cursor:                      "default";
     }

     /*****----- Main Box -----*****/
     mainbox {
         enabled:                     true;
         spacing:                     20px;
         margin:                      0px;
         padding:                     200px;
         border:                      0px solid;
         border-radius:               0px 0px 0px 0px;
         border-color:                #${palette.base0E};
         background-color:            transparent;
         children:                    [ "inputbar", "listview" ];
     }

     /*****----- Inputbar -----*****/
     inputbar {
         enabled:                     true;
         spacing:                     20px;
         margin:                      0px;
         padding:                     0px;
         border:                      0px;
         border-radius:               0px;
         border-color:                #${palette.base0E};
         background-color:            #${palette.base00};
         text-color:                  #${palette.base05};
         children:                    [ "prompt", "entry" ];
     }

     prompt {
         enabled:                     true;
         padding:                     15px;
         border-radius:               100%;
         background-color:            #${palette.base0E};
         text-color:                  #${palette.base00};
     }
     textbox-prompt-colon {
         enabled:                     true;
         expand:                      false;
         str:                         "::";
         background-color:            inherit;
         text-color:                  inherit;
     }
     entry {
         enabled:                     true;
         expand:                      false;
         width:                       350px;
         padding:                     15px 20px;
         border-radius:               100%;
         background-color:            #${palette.base02};
         text-color:                  #${palette.base05};
         cursor:                      text;
         placeholder:                 "Search...";
         placeholder-color:           inherit;
     }

     /*****----- Listview -----*****/
     listview {
         enabled:                     true;
         columns:                     4;
         lines:                       10;
         cycle:                       true;
         dynamic:                     true;
         scrollbar:                   false;
         layout:                      vertical;
         reverse:                     false;
         fixed-height:                true;
         fixed-columns:               true;

         spacing:                     10px;
         margin:                      0px;
         padding:                     0px;
         border:                      0px solid;
         border-radius:               0px;
         border-color:                #${palette.base0E};
         background-color:            transparent;
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
         border-radius:               100%;
         border-color:                #${palette.base0E};
         background-color:            #${palette.base00};
         text-color:                  #${palette.base05};
         cursor:                      pointer;
     }
     element normal.normal {
         background-color:            #${palette.base00};
         text-color:                  #${palette.base05};
     }
     element selected.normal {
         background-color:            #${palette.base02};
         text-color:                  #${palette.base05};
     }
     element-icon {
         padding:                     0px 0px 0px 0px;
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

     /*****----- Message -----*****/
     error-message {
         padding:                     100px;
         border:                      0px solid;
         border-radius:               0px;
         border-color:                #${palette.base0E};
         background-color:            #${palette.base00};
         text-color:                  #${palette.base05};
     }
     textbox {
         background-color:            #${palette.base00};
         text-color:                  #${palette.base05};
         vertical-align:              0.5;
         horizontal-align:            0.0;
         highlight:                   none;
     }
     element.alternate.normal {
     background-color: #${palette.base00};
     text-color:       #${palette.base05};
     }
  '';
  # For running quick commands
  home.file.".config/rofi/run.rasi".text = ''
      /**
     *
     * Author : Aditya Shakya (adi1090x)
     * Github : @adi1090x
     *
     * Rofi Theme File
     * Rofi Version: 1.7.3
     **/

    /*****----- Configuration -----*****/
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
    	modi:                       "drun";
        show-icons:                 true;
        display-drun:               "drun :";
        display-run:                "";
        display-filebrowser:        "";
        display-window:             "";
    	drun-display-format:        "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
    	window-format:              "{w} · {c} · {t}";
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
        placeholder:                 "Type here to run a command";
        placeholder-color:           inherit;
        vertical-align:              0.5;
        horizontal-align:            0.5;
    }

    /*****----- Listview -----*****/
    listview {
        enabled:                     false;
        columns:                     1;
        lines:                       1;
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
  # Styling for the clipboard
  home.file.".config/rofi/clipboard.rasi".text = ''
      /**
     *
     * Author : Aditya Shakya (adi1090x)
     * Github : @adi1090x
     *
     * Rofi Theme File
     * Rofi Version: 1.7.3
     **/

    /*****----- Configuration -----*****/
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
    	modi:                       "drun";
        show-icons:                 true;
        display-drun:               "drun :";
        display-run:                "";
        display-filebrowser:        "";
        display-window:             "";
    	drun-display-format:        "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
    	window-format:              "{w} · {c} · {t}";
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
        enabled:                     false;
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
        enabled:                     false;
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
        enabled:                     false;
        background-color:            transparent;
        text-color:                  inherit;
        cursor:                      text;
        placeholder:                 "Type here to search for apps";
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
  # Search engine thing
  home.file.".config/rofi/websearch.rasi".text = ''
      /**
     *
     * Author : Aditya Shakya (adi1090x)
     * Github : @adi1090x
     *
     * Rofi Theme File
     * Rofi Version: 1.7.3
     **/

    /*****----- Configuration -----*****/
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
    	modi:                       "drun";
        show-icons:                 true;
        display-drun:               "drun :";
        display-run:                "";
        display-filebrowser:        "";
        display-window:             "";
    	drun-display-format:        "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
    	window-format:              "{w} · {c} · {t}";
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
        placeholder:                 "Search";
        placeholder-color:           inherit;
        vertical-align:              0.5;
        horizontal-align:            0.5;
    }

    /*****----- Listview -----*****/
    listview {
        enabled:                     true;
        columns:                     1;
        lines:                       4;
        cycle:                       true;
        dynamic:                     true;
        scrollbar:                   false;
        layout:                      vertical;
        reverse:                     false;
        fixed-height:                false;
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
  # Powermenu
  home.file.".config/rofi/powermenu.rasi".text = ''
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

        prompt-font:                 "JetbrainsMono Nerd Font Bold 48";
        textbox-font:                "JetbrainsMono Nerd Font 12";
        element-text-font:           "JetbrainsMono Nerd Font 48";

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
        font:                        "JetbrainsMono Nerd Font 48";
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
