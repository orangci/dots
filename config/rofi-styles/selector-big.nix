{config, ...}: let
  palette = config.stylix.base16Scheme;
in {
  # For running quick bash commands
  home.file.".config/rofi/selector-big.rasi".text = ''
    // Config //
    configuration {
        modi:                        "drun";
        show-icons:                  true;
        drun-display-format:         "{name}";
    }

    * {
        main-bg:            #${palette.base00}d9;
        main-fg:            #${palette.base05}d9;
        select-bg:          #${palette.base0E}d9;
        select-fg:          #${palette.base01}d9;
        separatorcolor:     transparent;
        border-color:       transparent;
    }


    // Main //
    window {
        enabled:                     true;
        fullscreen:                  false;
        transparency:                "real";
        cursor:                      "default";
        spacing:                     0em;
        padding:                     0em;
        border:                      0em;
        border-radius:               0em;
        border-color:                transparent;
        background-color:            @main-bg;
        width:                       100%;
        height: 80%;
    }
    mainbox {
        enabled:                     true;
        orientation:                 horizontal;
        background-color:            transparent;
    }

    // Lists //
    listview {
        enabled:                     true;
        spacing:                     1em;
        padding:                     2em;
        columns:                     4;
        lines:                       4;
        dynamic:                     false;
        fixed-height:                false;
        reverse:                     true;
        cursor:                      "default";
        background-color:            transparent;
        text-color:                  @main-fg;
        scrollbar:                   false;
    }
    
    mainbox {
        enabled:                     true;
        orientation:                 horizontal;
        children:                    [ "dummy", "frame", "dummy" ];
        background-color:            transparent;
    }
    frame {
        children:                    [ "listview" ];
        background-color:            transparent;
    }

    dummy {
        width:                       2em;
        expand:                      false;
        background-color:            transparent;
    }

    // Elements //
    element {
        enabled:                     true;
        spacing:                     0em;
        padding:                     1em;
        cursor:                      pointer;
        background-color:            transparent;
        text-color:                  @main-fg;
        border-radius:               15px;
        orientation:                 vertical;
    }
    element selected.normal {
        background-color:            @select-bg;
        text-color:                  @select-fg;
    }
    element-icon {
        cursor:                      inherit;
        size:                        10em;
        background-color:            transparent;
        text-color:                  inherit;
        expand:                      true;
        border-radius:               15px;
    }
    element-text {
        vertical-align:              0.5;
        horizontal-align:            0.5;
        cursor:                      inherit;
        background-color:            transparent;
        text-color:                  inherit;
    }
  '';
}
