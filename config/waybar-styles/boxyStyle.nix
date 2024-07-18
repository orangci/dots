{
  config,
  lib,
  ...
}:
let
  palette = config.stylix.base16Scheme;
in {
  # Configure & Theme Waybar
  programs.waybar = {
    style = concatStrings [
      ''
        /* >>> ALL MODULES <<< */
          * {
            font-size: 14px;
            font-family: JetBrainsMono NFM, Font Awesome, sans-serif;
            font-weight: bold;
            padding: 0px 2px;
            border-radius: 0px; margin: 0px;
            background-color: #${palette.base00};
          }
          tooltip label {color: #${palette.base05};}

        /* >>> LEFT MODULES <<< */
          #workspaces * {color: #${palette.base05};}
          #workspaces button {
            color: #${palette.base05};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            opacity: 0.5;
          }
          #workspaces button.active {
            color: #${palette.base00};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            opacity: 1.0;
            min-width: 30px;
          }
          #workspaces button:hover {
            color: #${palette.base05};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            opacity: 1.0;
          }

          #cpu {color: #${palette.base0D};}
          #memory {color: #${palette.base0D};}
          #disk {color: #${palette.base03};}
          #battery {color: #${palette.base08};}

          /* >>> CENTER MODULES <<< */
          #window {color: #${palette.base0C};}
          #clock {color: #${palette.base0B};}

          /* >>> RIGHT MODULES <<< */
          #custom-exit {color: #${palette.base0A};}
          #custom-recorder {color: #${palette.base0A};}
          #idle_inhibitor {color: #${palette.base0A};}
          #pulseaudio {color: #${palette.base0A};}
          #custom-weather {color: #${palette.base09};}
          #network {color: #${palette.base08};}
          #tray {color: #${palette.base08};}
          #custom-notification  {color: #${palette.base08};}
      ''
    ];
  };
}
