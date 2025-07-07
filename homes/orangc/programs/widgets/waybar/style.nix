{
  config,
  lib,
  ...
}:
let
  colours = config.stylix.base16Scheme;
  workspaceTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in
with lib;
{
  programs.waybar = {
    style = concatStrings [
      ''
        /* >>> ALL MODULES <<< */
        * {
          font-size: 16px;
          font-family: Lexend, UbuntuMono Nerd Font Propo, Font Awesome, sans-serif;
        }
        window#waybar {background-color: ${colours.base00} }
        tooltip {
          background: ${colours.base00};
          border-radius: 15px;
        }
        tooltip label {color: ${colours.base05};}
        #cpu, #custom-exit, #tray, #network { padding: 0px 5px 0px 15px; }
        #memory, #pulseaudio, #custom-notification { padding: 0px 10px 0px 5px; }
        #window, #clock, #custom-weather, #workspaces, #custom-salah { padding: 0px 10px; }

        /* >>> LEFT MODULES <<< */
        #workspaces {
          background: ${colours.base00};
          padding: 0px 1px;
        }
        #workspaces button {
          padding: 0px 5px;
          border-radius: 15px; margin: 4px 3px;
          background: ${colours.base00};
          background-size: 300% 300%;
          animation: gradient_horizontal 15s ease infinite;
          opacity: 0.5;
          transition: ${workspaceTransition};
        }
        #workspaces button.active {
          padding: 0px 5px;
          border-radius: 15px; margin: 4px 3px;
          color: ${colours.base00};
          background: ${colours.base0E};
          background-size: 300% 300%;
          animation: gradient_horizontal 15s ease infinite;
          transition: ${workspaceTransition};
          opacity: 1.0;
          min-width: 40px;
        }
        #workspaces button:hover {
          border-radius: 15px;
          background: ${colours.base03};
          background-size: 300% 300%;
          animation: gradient_horizontal 15s ease infinite;
          opacity: 0.8;
          transition: ${workspaceTransition};
        }
        @keyframes gradient_horizontal {0% {background-position: 0% 50%;} 50% {background-position: 100% 50%;} 100% {background-position: 0% 50%;}}
        @keyframes swiping {0% {background-position: 0% 200%;} 00% {background-position: 200% 200%;}}

        #cpu {color: ${colours.base0D};}
        #memory {color: ${colours.base0D};}
        #custom-salah {color: ${colours.base0D};}
        #disk {color: ${colours.base03};}
        #battery {color: ${colours.base08};}

        /* >>> CENTER MODULES <<< */
        #window * {color: ${colours.base0C};}
        #clock {color: ${colours.base0B};}

        /* >>> RIGHT MODULES <<< */
        #custom-exit {color: ${colours.base0A};}
        #custom-recorder {color: ${colours.base0A}}
        #idle_inhibitor {color: ${colours.base0A};}
        #pulseaudio {color: ${colours.base0A};}
        #custom-weather {color: ${colours.base09};}
        #network {color: ${colours.base08};}
        #tray {color: ${colours.base08};}
        #custom-notification  {color: ${colours.base08};}
      ''
    ];
  };
}
