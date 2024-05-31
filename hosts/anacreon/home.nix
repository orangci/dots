{
  config,
  pkgs,
  inputs,
  username,
  host,
  gtkThemeFromScheme,
  ...
}: let
  palette = config.colorScheme.palette;
  inherit
    (import ./variables.nix)
    gitUsername
    gitEmail
    theme
    ;
in {
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Set The Colorscheme
  colorScheme = inputs.nix-colors.colorSchemes."${theme}";

  # Import Program Configurations
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.hyprland.homeManagerModules.default
    ../../config/hyprland.nix
    ../../config/swaync.nix
    ../../config/waybar.nix
  ];

  # Define Settings For Xresources
  xresources.properties = {
    "Xcursor.size" = 24;
  };

  home.file.".local/share/fonts" = {
    source = ../../config/fonts;
    recursive = true;
  };
  home.file.".config/starship.toml".source = ../../config/starship.toml;
  home.file.".config/ascii-neofetch".source = ../../config/ascii-neofetch;
  home.file.".base16-themes".source = ../../config/base16-themes;
  home.file.".emoji".source = ../../config/emoji;
  home.file.".face.icon".source = ../../config/face.jpg;
  home.file.".config/rofi/rofi-prism.sh".source = ../../config/rofi-prism.sh;
  home.file.".config/fastfetch/config.jsonc".text = ''
    {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
        "logo": {
            "padding": {
                "top": 2
            }
        },
        "display": {
            "separator": " -> "
        },
        "modules": [
            {
                "type": "custom",
                "format": "\u001b[90m┌────────────────────────────────────────────────────────────┐"
            },
            {
                "type": "title",
                "keyWidth": 10
            },
            {
                "type": "custom",
                "format": "\u001b[90m└────────────────────────────────────────────────────────────┘"
            },
            {
                "type": "custom",
                "format": " \u001b[90m  \u001b[31m  \u001b[32m  \u001b[33m  \u001b[34m  \u001b[35m  \u001b[36m  \u001b[37m  \u001b[38m  \u001b[39m       \u001b[38m  \u001b[37m  \u001b[36m  \u001b[35m  \u001b[34m  \u001b[33m  \u001b[32m  \u001b[31m  \u001b[90m"
            },
            {
                "type": "custom",
                "format": "\u001b[90m┌────────────────────────────────────────────────────────────┐"
            },
            {
                "type": "os",
                "key": " OS",
                "keyColor": "yellow"
            },
            {
                "type": "packages",
                "key": "│ ├󰏖",
                "keyColor": "yellow"
            },
            {
                "type": "shell",
                "key": "│ └",
                "keyColor": "yellow"
            },
            {
                "type": "wm",
                "key": " DE/WM",
                "keyColor": "blue"
            },
            {
                "type": "lm",
                "key": "│ ├󰧨",
                "keyColor": "blue"
            },
            {
                "type": "wmtheme",
                "key": "│ ├󰉼",
                "keyColor": "blue"
            },
            {
                "type": "icons",
                "key": "│ ├󰀻",
                "keyColor": "blue"
            },
            {
                "type": "terminal",
                "key": "│ ├",
                "keyColor": "blue"
            },
            {
                "type": "host",
                "key": "󰌢 PC",
                "keyColor": "green"
            },
            {
                "type": "cpu",
                "key": "│ ├󰻠",
                "keyColor": "green"
            },
            {
                "type": "gpu",
                "key": "│ ├󰍛",
                "keyColor": "green"
            },
            {
                "type": "disk",
                "key": "│ ├",
                "keyColor": "green"
            },
            {
                "type": "memory",
                "key": "│ ├󰑭",
                "keyColor": "green"
            },
            {
                "type": "uptime",
                "key": "│ ├󰅐",
                "keyColor": "green"
            },
            {
                "type": "display",
                "key": "│ └󰍹",
                "keyColor": "green"
            },
            {
                "type": "custom",
                "format": "\u001b[90m└────────────────────────────────────────────────────────────┘"
            },
            "break",
            {
                "type": "custom",
                "format": " \u001b[90m  \u001b[31m  \u001b[32m  \u001b[33m  \u001b[34m  \u001b[35m  \u001b[36m  \u001b[37m  \u001b[38m  \u001b[39m       \u001b[38m  \u001b[37m  \u001b[36m  \u001b[35m  \u001b[34m  \u001b[33m  \u001b[32m  \u001b[31m  \u001b[90m"
            }
        ]
    }
  '';
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';
  home.file.".config/hypr/hyprlock.conf".text = ''
    # $text_color = rgba(F6DECEFF)
    # $entry_background_color = rgba(1C110811)
    # $entry_border_color = rgba(A48C7B55)
    # $entry_color = rgba(DDC1AEFF)
    $text_color = rgba(FFFFFFFF)
    $entry_background_color = rgba(33333311)
    $entry_border_color = rgba(3B3B3B55)
    $entry_color = rgba(FFFFFFFF)
    $font_family = JetBrainsMono NFM
    $font_family_clock = JetBrainsMono NFM
    $font_material_symbols = Material Symbols Rounded

    general {
        disable_loading_bar = true
        hide_cursor = true
        grace = 0
        no_fade_in = false
    }
    background {
        monitor =
        path = screenshot
        blur_passes = 3
        blur_size = 10
    }
    # Profile picture
    image {
        monitor =
        size = 120
        position = 0, 45

        path = ~/dots/files/face.jpg
        halign = center
        valign = center

        shadow_passes = 1
    }
    input-field {
        monitor =
        size = 250, 50
        outline_thickness = 2
        dots_size = 0.1
        dots_spacing = 0.3
        outer_color = $entry_border_color
        inner_color = $entry_background_color
        font_color = $entry_color
        # fade_on_empty = true

        position = 0, -80
        halign = center
        valign = center
    }

    label { # Clock
        monitor =
        text = $TIME
        shadow_passes = 1
        shadow_boost = 0.5
        color = $text_color
        font_size = 65
        font_family = $font_family_clock

        position = 0, 300
        halign = center
        valign = center
    }
    # Username
    label {
        monitor =
        position = 10, 0

        text =  $USER
        color = $text_color
        font_size = 16
        font_family = $font_family

        valign = top
        halign = left

        shadow_passes = 1
    }
    # Date
    label {
        monitor =
        position = 0, 200

        text = cmd[update:120000] echo "$(date +'%a %d %B')"
        color = $text_color
        font_size = 30
        font_family = $font_family

        valign = center
        halign = center

        shadow_passes = 1
    }
  '';
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
  # Application launcher
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
        no-fading-openclose:        true;
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
  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # Configure Cursor Theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # Theme GTK
  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 12;
      package = pkgs.ubuntu_font_family;
    };
    theme = {
      name = "${config.colorScheme.slug}";
      package = gtkThemeFromScheme {scheme = config.colorScheme;};
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Theme QT -> GTK
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # Scripts
  home.packages = [
    (import ../../scripts/task-waybar.nix {inherit pkgs;})
    (import ../../scripts/squirtle.nix {inherit pkgs;})
    (import ../../scripts/ceaseRecording.nix {inherit pkgs;})
    (import ../../scripts/startRecording.nix {inherit pkgs;})
    (import ../../scripts/clipRecording.nix {inherit pkgs;})
    (import ../../scripts/rofi-powermenu.nix {inherit pkgs;})
    (import ../../scripts/rofi-prism-exec.nix {inherit pkgs;})
    (import ../../scripts/themechange.nix {
      inherit pkgs;
      inherit host;
      inherit username;
    })
    (import ../../scripts/theme-selector.nix {inherit pkgs;})
    (import ../../scripts/nvidia-offload.nix {inherit pkgs;})
    (import ../../scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/web-search.nix {inherit pkgs;})
    (import ../../scripts/rofi-launcher.nix {inherit pkgs;})
    (import ../../scripts/screenshootin.nix {inherit pkgs;})
    (import ../../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
  ];

  programs = {
    gh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        lua-language-server
        gopls
        xclip
        wl-clipboard
        luajitPackages.lua-lsp
        nil
        rust-analyzer
        nodePackages.bash-language-server
        yaml-language-server
        pyright
        marksman
      ];
      plugins = with pkgs.vimPlugins; [
        alpha-nvim
        auto-session
        bufferline-nvim
        dressing-nvim
        indent-blankline-nvim
        nvim-treesitter.withAllGrammars
        lualine-nvim
        nvim-autopairs
        nvim-web-devicons
        nvim-cmp
        nvim-surround
        nvim-lspconfig
        cmp-nvim-lsp
        cmp-buffer
        luasnip
        cmp_luasnip
        friendly-snippets
        lspkind-nvim
        comment-nvim
        nvim-ts-context-commentstring
        {
          plugin = dracula-nvim;
          config = "colorscheme dracula";
        }
        plenary-nvim
        neodev-nvim
        luasnip
        telescope-nvim
        todo-comments-nvim
        nvim-tree-lua
        telescope-fzf-native-nvim
        vim-tmux-navigator
      ];
      extraConfig = ''
        set noemoji
      '';
      extraLuaConfig = ''
        ${builtins.readFile ../../config/nvim/options.lua}
        ${builtins.readFile ../../config/nvim/keymaps.lua}
        ${builtins.readFile ../../config/nvim/plugins/alpha.lua}
        ${builtins.readFile ../../config/nvim/plugins/autopairs.lua}
        ${builtins.readFile ../../config/nvim/plugins/auto-session.lua}
        ${builtins.readFile ../../config/nvim/plugins/comment.lua}
        ${builtins.readFile ../../config/nvim/plugins/cmp.lua}
        ${builtins.readFile ../../config/nvim/plugins/lsp.lua}
        ${builtins.readFile ../../config/nvim/plugins/nvim-tree.lua}
        ${builtins.readFile ../../config/nvim/plugins/telescope.lua}
        ${builtins.readFile ../../config/nvim/plugins/todo-comments.lua}
        ${builtins.readFile ../../config/nvim/plugins/treesitter.lua}
        require("ibl").setup()
        require("bufferline").setup{}
        require("lualine").setup({
          icons_enabled = true,
          theme = 'dracula',
        })
      '';
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      font.name = "JetBrainsMono NFM";
      font.size = 16;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
        background_opacity = "0.9";
      };
      extraConfig = ''
        foreground #${palette.base05}
        background #${palette.base00}
        color0  #${palette.base03}
        color1  #${palette.base08}
        color2  #${palette.base0B}
        color3  #${palette.base09}
        color4  #${palette.base0D}
        color5  #${palette.base0E}
        color6  #${palette.base0C}
        color7  #${palette.base06}
        color8  #${palette.base04}
        color9  #${palette.base08}
        color10 #${palette.base0B}
        color11 #${palette.base0A}
        color12 #${palette.base0C}
        color13 #${palette.base0E}
        color14 #${palette.base0C}
        color15 #${palette.base07}
        color16 #${palette.base00}
        color17 #${palette.base0F}
        color18 #${palette.base0B}
        color19 #${palette.base09}
        color20 #${palette.base0D}
        color21 #${palette.base0E}
        color22 #${palette.base0C}
        color23 #${palette.base06}
        cursor  #${palette.base07}
        cursor_text_color #${palette.base00}
        selection_foreground #${palette.base01}
        selection_background #${palette.base0D}
        url_color #${palette.base0C}
        active_border_color #${palette.base04}
        inactive_border_color #${palette.base00}
        bell_border_color #${palette.base03}
        tab_bar_style fade
        tab_fade 1
        active_tab_foreground   #${palette.base04}
        active_tab_background   #${palette.base00}
        active_tab_font_style   bold
        inactive_tab_foreground #${palette.base07}
        inactive_tab_background #${palette.base08}
        inactive_tab_font_style bold
        tab_bar_background #${palette.base00}
      '';
    };
    starship = {
      enable = true;
      package = pkgs.starship;
    };
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        nitch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
      '';
      shellAliases = {
        sv = "sudo nvim";
        flake-rebuild = "cd $HOME/dots; sudo nixos-rebuild switch --flake .#anacreon";
        flake-update = "nh os switch --hostname ${host} --update";
        gcnix = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -a";
        lal = "lsd -al";
        qq = "clear";
        cat = "bat";
        tr = "trash";
        ".." = "cd ..";
        neofetch = "fastfetch";
        gcrec = "rm -rf ~/Videos/snapshots/*";
        find = "fd";
        ztop = "zfxtop";
        nixpf = "nix-prefetch";
        nixpfu = "nix-prefetch-url";
      };
    };
    home-manager.enable = true;
  };
}
