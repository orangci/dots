{
  pkgs,
  config,
  ...
}: let
  palette = config.colorScheme.palette;
in {
  home.file.".config/rofi/config.rasi".text = ''
    /*****----- Configuration -----*****/
    configuration {
    	modi:                       "drun,run,filebrowser,window";
        show-icons:                 true;
        display-drun:               "";
        display-run:                "";
        display-filebrowser:        "";
        display-window:             "";
    	drun-display-format:        "{name}";
    	window-format:              "{w} · {c} · {t}";
    }

    /*****----- Global Properties -----*****/
    * {
        font:                        "JetBrainsMono Nerd Font 10";
        background:                  #${palette.base00};
        background-alt:              #${palette.base01};
        foreground:                  #${palette.base05};
        selected:                    #${palette.base0E};
        active:                      #${palette.base00};
        urgent:                      #${palette.base08};
    }

    /*****----- Main Window -----*****/
    window {
        /* properties for window widget */
        transparency:                "real";
        location:                    center;
        anchor:                      center;
        fullscreen:                  false;
        width:                       600px;
        x-offset:                    0px;
        y-offset:                    0px;

        /* properties for all widgets */
        enabled:                     true;
        border-radius:               20px;
        cursor:                      "default";
        background-color:            @background;
    }

    /*****----- Main Box -----*****/
    mainbox {
        enabled:                     true;
        spacing:                     0px;
        background-color:            transparent;
        orientation:                 vertical;
        children:                    [ "inputbar", "listbox" ];
    }

    listbox {
        spacing:                     15px;
        padding:                     15px;
        background-color:            transparent;
        orientation:                 vertical;
        children:                    [ "message", "listview" ];
    }

    /*****----- Inputbar -----*****/
    inputbar {
        enabled:                     true;
        spacing:                     10px;
        padding:                     100px 60px;
        background-color:            transparent;
        background-image:            url("~/.config/rofi/rofi.jpg", width);
        text-color:                  @foreground;
        orientation:                 horizontal;
        children:                    [ "textbox-prompt-colon", "entry", "dummy", "mode-switcher" ];
        border-radius:               20px;
    }
    textbox-prompt-colon {
        enabled:                     true;
        expand:                      false;
        str:                         "";
        padding:                     12px 15px;
        border-radius:               12px;
        background-color:            @background-alt;
        text-color:                  inherit;
    }
    entry {
        enabled:                     true;
        expand:                      false;
        width:                       150px;
        padding:                     12px 16px;
        border-radius:               12px;
        background-color:            @background-alt;
        text-color:                  inherit;
        cursor:                      text;
        placeholder:                 "Search";
        placeholder-color:           inherit;
    }
    dummy {
        expand:                      true;
        background-color:            transparent;
    }

    /*****----- Mode Switcher -----*****/
    mode-switcher{
        enabled:                     true;
        spacing:                     10px;
        background-color:            transparent;
        text-color:                  @foreground;
    }
    button {
        width:                       40px;
        padding:                     12px;
        border-radius:               12px;
        background-color:            @background-alt;
        text-color:                  inherit;
        cursor:                      pointer;
    }
    button selected {
        background-color:            @selected;
        text-color:                  @foreground;
    }

    /*****----- Listview -----*****/
    listview {
        enabled:                     true;
        columns:                     1;
        lines:                       8;
        cycle:                       true;
        dynamic:                     true;
        scrollbar:                   false;
        layout:                      vertical;
        reverse:                     false;
        fixed-height:                true;
        fixed-columns:               true;

        spacing:                     10px;
        background-color:            transparent;
        text-color:                  @foreground;
        cursor:                      "default";
    }

    /*****----- Elements -----*****/
    element {
        enabled:                     true;
        spacing:                     10px;
        padding:                     6px;
        border-radius:               10px;
        background-color:            transparent;
        text-color:                  @foreground;
        cursor:                      pointer;
    }
    element normal.normal {
        background-color:            inherit;
        text-color:                  inherit;
    }
    element normal.urgent {
        background-color:            @urgent;
        text-color:                  @foreground;
    }
    element normal.active {
        background-color:            @background;
        text-color:                  @foreground;
    }
    element selected.normal {
        background-color:            @selected;
        text-color:                  @foreground;
    }
    element selected.urgent {
        background-color:            @urgent;
        text-color:                  @foreground;
    }
    element selected.active {
        background-color:            @urgent;
        text-color:                  @foreground;
    }
    element-icon {
        background-color:            transparent;
        text-color:                  inherit;
        size:                        24px;
        cursor:                      inherit;
    }
    element-text {
        background-color:            transparent;
        text-color:                  inherit;
        cursor:                      inherit;
        vertical-align:              0.5;
        horizontal-align:            0.0;
    }

    /*****----- Message -----*****/
    message {
        background-color:            transparent;
    }
    textbox {
        padding:                     10px;
        border-radius:               10px;
        background-color:            @background-alt;
        text-color:                  @foreground;
        vertical-align:              0.5;
        horizontal-align:            0.0;
    }
    error-message {
        padding:                     10px;
        border-radius:               10px;
        background-color:            @background;
        text-color:                  @foreground;
    }
  '';
}
