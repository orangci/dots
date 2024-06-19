{
  pkgs,
  config,
  lib,
  host,
  username,
  ...
}:
let
  palette = config.colorScheme.palette;
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  inherit (import ../hosts/${host}/variables.nix) clock24h boxyStyle;
in
with lib;
{
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";

        modules-center = [
          "hyprland/window"
          "clock"
        ];
        modules-left = [
          "hyprland/workspaces"
          "cpu"
          "memory"
        ];
        modules-right = [
          "custom/exit"
          "idle_inhibitor"
          "pulseaudio"
          "custom/weather"
          "tray"
          "custom/notification"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "clock" = {
          format = if clock24h == true then '' {:L%H:%M}'' else '' {:L%I:%M %p}'';
          tooltip = true;
          tooltip-format = "<big>{:%A, %d.%b.%Y }</big>";
        };
        "hyprland/window" = {
          max-length = 25;
          separate-outputs = false;
          rewrite = {
            "" = "${username}@${host}";
          };
        };
        "custom/previouspls" = {
          format = "⏮";
          on-click = "playerctl previous";
          tooltip = false;
        };
        "custom/nextpls" = {
          format = "⏭";
          on-click = "playerctl next";
          tooltip = false;
        };
        "memory" = {
          interval = 5;
          format = " {}%";
          tooltip = true;
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
        };
        "disk" = {
          format = " {free}";
          tooltip = true;
        };
        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "tray" = {
          spacing = 12;
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "rofi-powermenu";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = "true";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t";
          escape = true;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-click = "";
          tooltip = false;
        };
        "custom/weather" = {
          interval = 3600;
          exec = "wttrbar";
          format = "{}℃";
          format-alt = "{on-click-right}℉";
          format-alt-click = "click-right";
          on-click = "exec";
          on-click-middle = "xdg-open https://wttr.in/";
          on-click-right = "exec wttrbar --fahrenheit";
          return-type = "json";
          tooltip = true;
        };
      }
    ];
    style = concatStrings [
      ''
        /* >>> ALL MODULES <<< */
          * {
            font-size: 14px;
            font-family: JetBrainsMono NFM, Font Awesome, sans-serif;
            font-weight: bold;
            color: #${palette.base00};
          }
          window#waybar {
            ${
              if boxyStyle == false then
                ''background-color: rgba(255,0,0,0);''
              else
                ''background-color: #${palette.base00};''
            }
            color: #${palette.base0F};
          }
          tooltip {
            background: #${palette.base00};
            border: 1px solid #${palette.base0E};
            border-radius: 15px;
          }
          tooltip label {
            color: #${palette.base05};
          }
          #custom-previouspls, #cpu, #custom-exit, #tray, #network { /* Stuff that needs to be rounded left. */
            ${
              if boxyStyle == true then
                ''border-radius: 0px; margin: 0px;''
              else
                ''border-radius: 15px 0px 0px 15px; margin: 4px 0px 4px 2px;''
            }
          padding: 2px 5px 2px 15px;

          }
          #custom-nextpls, #memory, #pulseaudio { /* Stuff that needs to be rounded right. */
            ${
              if boxyStyle == true then
                ''border-radius: 0px; margin: 0px;''
              else
                ''border-radius: 0px 15px 15px 0px; margin: 4px 2px 4px 0px;''
            }
          padding: 2px 10px 2px 5px;

          }
          #window, #clock, #custom-weather { /* Stuff that's rounded both left and right, i.e. standalone pills. */
            ${
              if boxyStyle == true then
                ''border-radius: 0px; margin: 0px;''
              else
                ''border-radius: 15px; margin: 4px;''
            }
          padding: 2px 10px;
          }
        #idle_inhibitor, #custom-notification { /* Stuff that aren't rounded in either direction, i.e. sandwiched pills. */
            border-radius: 0px;
            ${if boxyStyle == true then ''margin: 0px;'' else ''margin: 4px 0px;''}
            padding: 2px 14px;
        }




        /* >>> LEFT MODULES <<< */
          #workspaces {
            background: #${palette.base00};
            padding: 0px 1px;
            ${
              if boxyStyle == true then
                ''border-radius: 0px; margin: 0px;''
              else
                ''border-radius: 0px 15px 15px 0px; margin: 4px 2px 4px 0px;''
            }
            color: #${palette.base05};
          }
          #workspaces button {
            padding: 0px 5px;
            ${
              if boxyStyle == true then
                ''border-radius: 0px; margin: 0px;''
              else
                ''border-radius: 15px; margin: 4px 3px;''
            }
            color: #${palette.base05};
            background: #${palette.base00};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            opacity: 0.5;
            transition: ${betterTransition};
          }
          #workspaces button.active {
            padding: 0px 5px;
            ${
              if boxyStyle == true then
                ''border-radius: 0px; margin: 0px;''
              else
                ''border-radius: 15px; margin: 4px 3px;''
            }
            color: #${palette.base00};
            background: #${palette.base0E};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            transition: ${betterTransition};
            opacity: 1.0;
            min-width: 40px;
          }
          #workspaces button:hover {
            ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
            color: #${palette.base05};
            background: #${palette.base03};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            opacity: 0.8;
            transition: ${betterTransition};
          }
          @keyframes gradient_horizontal {
            0% {
              background-position: 0% 50%;
            }
            50% {
              background-position: 100% 50%;
            }
            100% {
              background-position: 0% 50%;
            }
          }
          @keyframes swiping {
            0% {
              background-position: 0% 200%;
            }
            100% {
              background-position: 200% 200%;
            }
          }

          #custom-previouspls {
            ${
              if boxyStyle == true then
                ''color: #${palette.base0E}; background: #${palette.base00};''
              else
                ''background: #${palette.base0E};''
            }
          }
          #custom-nextpls {
            ${
              if boxyStyle == true then
                ''color: #${palette.base0E}; background: #${palette.base00};''
              else
                ''background: #${palette.base0E};''
            }
          }
          #cpu {
            ${
              if boxyStyle == true then
                ''color: #${palette.base0D}; background: #${palette.base00};''
              else
                ''background: #${palette.base0D};''
            }
          }
          #memory {
            ${
              if boxyStyle == true then
                ''color: #${palette.base0D}; background: #${palette.base00};''
              else
                ''background: #${palette.base0D};''
            }
          }
          #disk {
            ${
              if boxyStyle == true then
                ''color: #${palette.base03}; background: #${palette.base00};''
              else
                ''background: #${palette.base03};''
            }
          }
          #battery {
            ${
              if boxyStyle == true then
                ''color: #${palette.base08}; background: #${palette.base00};''
              else
                ''background: #${palette.base08};''
            }
          }



          /* >>> CENTER MODULES <<< */
          #window {
            ${
              if boxyStyle == true then
                ''color: #${palette.base0C}; background: #${palette.base00};''
              else
                ''background: #${palette.base0C};''
            }
          }
          #clock {
            ${
              if boxyStyle == true then
                ''color: #${palette.base0B}; background: #${palette.base00};''
              else
                ''background: #${palette.base0B};''
            }
          }



          /* >>> RIGHT MODULES <<< */
          #custom-exit {
            ${
              if boxyStyle == true then
                ''color: #${palette.base0A}; background: #${palette.base00};''
              else
                ''background: #${palette.base0A};''
            }
          }
          #idle_inhibitor {
            ${
              if boxyStyle == true then
                ''color: #${palette.base0A}; background: #${palette.base00};''
              else
                ''background: #${palette.base0A};''
            }
          }
          #pulseaudio {
            ${
              if boxyStyle == true then
                ''color: #${palette.base0A}; background: #${palette.base00};''
              else
                ''background: #${palette.base0A};''
            }
          }
          #custom-weather {
            ${
              if boxyStyle == true then
                ''color: #${palette.base09}; background: #${palette.base00};''
              else
                ''background: #${palette.base09};''
            }
          }
          #network {
            ${
              if boxyStyle == true then
                ''color: #${palette.base08}; background: #${palette.base00};''
              else
                ''background: #${palette.base08};''
            }
          }
          #tray {
            ${
              if boxyStyle == true then
                ''color: #${palette.base08}; background: #${palette.base00};''
              else
                ''background: #${palette.base08};''
            }
          }
          #custom-notification {
            ${
              if boxyStyle == true then
                ''color: #${palette.base08}; background: #${palette.base00};''
              else
                ''background: #${palette.base08};''
            }
          }
      ''
    ];
  };
}
