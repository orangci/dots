{
  config,
  lib,
  ...
}:
let
  palette = config.stylix.base16Scheme;
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in
with lib;
{
  # Configure & Theme Waybar
  programs.waybar = {
    style = concatStrings [
      ''
        /* >>> ALL MODULES <<< */
          * {
            font-size: 14px;
            font-family: JetBrainsMono NFM, Font Awesome, sans-serif;
            font-weight: bold;
            color: #${palette.base00};
          }
          window#waybar {background-color: rgba(255,0,0,0);}
          tooltip {background: #${palette.base00}; border-radius: 15px;}
          tooltip label {color: #${palette.base05};}
          #cpu, #custom-exit, #tray, #network {border-radius: 15px 0px 0px 15px; margin: 3px 0px 3px 2px; padding: 0px 5px 0px 15px;} /* Stuff that needs to be rounded left. */
          #memory, #pulseaudio, #custom-notification {border-radius: 0px 15px 15px 0px; margin: 3px 2px 3px 0px; padding: 0px 10px 0px 5px;} /* Stuff that needs to be rounded right. */
          #window, #clock, #custom-weather, #workspaces {border-radius: 15px; margin: 3px 4px; padding: 0px 10px;} /* Stuff that's rounded both left and right, i.e. standalone pills. */
          #idle_inhibitor, #custom-recorder {border-radius: 0px; margin: 3px 0px; padding: 0px 14px;} /* Stuff that aren't rounded in either direction, i.e. sandwiched pills. */

        /* >>> LEFT MODULES <<< */
          #workspaces {
            background: #${palette.base00};
            padding: 0px 1px;
          }
          #workspaces * {color: #${palette.base05};}
          #workspaces button {
            padding: 0px 5px;
            border-radius: 15px; margin: 4px 3px;
            background: #${palette.base00};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            opacity: 0.5;
            transition: ${betterTransition};
          }
          #workspaces button.active {
            padding: 0px 5px;
            border-radius: 15px; margin: 4px 3px;
            color: #${palette.base00};
            background: #${palette.base0E};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            transition: ${betterTransition};
            opacity: 1.0;
            min-width: 40px;
          }
          #workspaces button:hover {
            border-radius: 15px;
            background: #${palette.base03};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            opacity: 0.8;
            transition: ${betterTransition};
          }
          @keyframes gradient_horizontal {0% {background-position: 0% 50%;} 50% {background-position: 100% 50%;} 100% {background-position: 0% 50%;}}
          @keyframes swiping {0% {background-position: 0% 200%;} 00% {background-position: 200% 200%;}}

          #cpu {background: #${palette.base0D};}
          #memory {background: #${palette.base0D};}
          #disk {background: #${palette.base03};}
          #battery {background: #${palette.base08};}

          /* >>> CENTER MODULES <<< */
          #window {background: #${palette.base0C};}
          #clock {background: #${palette.base0B};}

          /* >>> RIGHT MODULES <<< */
          #custom-exit {background: #${palette.base0A};}
          #custom-recorder {background: #${palette.base0A};}
          #idle_inhibitor {background: #${palette.base0A};}
          #pulseaudio {background: #${palette.base0A};}
          #custom-weather {background: #${palette.base09};}
          #network {background: #${palette.base08};}
          #tray {background: #${palette.base08};}
          #custom-notification {background: #${palette.base08};}
      ''
    ];
  };
}
