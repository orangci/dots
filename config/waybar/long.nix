{
  config,
  lib,
  ...
}:
let
  palette = config.stylix.base16Scheme;
in
with lib;
{
  # Configure & Theme Waybar
  programs.waybar = {
    style = concatStrings [
      ''
        /* >>> ALL MODULES <<< */
          * {
            font-size: 16px;
            font-family: JetBrainsMono NFM, Font Awesome, sans-serif;
            font-weight: bold;
            padding: 1px 4px; 
            background-color: rgba(30, 30, 46, .85);
            border-radius: 15px;
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
            color: rgba(30, 30, 46, .85);
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
