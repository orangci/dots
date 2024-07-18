{
  config,
  lib,
  ...
}: let
  palette = config.stylix.base16Scheme;
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in
  with lib; {
    # Configure & Theme Waybar
    programs.waybar = {
      style = concatStrings [
        ''
          /* >>> ALL MODULES <<< */
            * {
              font-size: 14px;
              font-family: JetBrainsMono NFM, Font Awesome, sans-serif;
              font-weight: bold;
            }
            window#waybar {background-color: rgba(255,0,0,0);}
            tooltip {
              background: #${palette.base00};
              border-radius: 15px;
            }
            tooltip label {color: #${palette.base05};}
              #cpu, #custom-exit, #tray, #network { /* Stuff that needs to be rounded left. */
              border-radius: 15px 0px 0px 15px; margin: 3px 0px 3px 2px;
              padding: 0px 5px 0px 15px;
              background: #${palette.base00};

            }
            #memory, #pulseaudio, #custom-notification { /* Stuff that needs to be rounded right. */
              border-radius: 0px 15px 15px 0px; margin: 3px 2px 3px 0px;
              padding: 0px 10px 0px 5px;
              background: #${palette.base00};

            }
            #window, #clock, #custom-weather, #workspaces { /* Stuff that's rounded both left and right, i.e. standalone pills. */
              border-radius: 15px; margin: 3px 4px;
              padding: 0px 10px;
              background: #${palette.base00};
            }
          #idle_inhibitor, #custom-recorder { /* Stuff that aren't rounded in either direction, i.e. sandwiched pills. */
              border-radius: 0px;
              margin: 3px 0px;
              padding: 0px 14px;
              background: #${palette.base00};
          }


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

            #cpu {color: #${palette.base0D};}
            #memory {color: #${palette.base0D};}
            #disk {color: #${palette.base03};}
            #battery {color: #${palette.base08};}

            /* >>> CENTER MODULES <<< */
            #window * {color: #${palette.base0C};}
            #clock {color: #${palette.base0B};}

            /* >>> RIGHT MODULES <<< */
            #custom-exit {color: #${palette.base0A};}
            #custom-recorder {color: #${palette.base0A}}
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
