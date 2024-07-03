{
  pkgs,
  config,
  lib,
  host,
  username,
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
          format = " {:L%I:%M %p}";
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
        #idle_inhibitor { /* Stuff that aren't rounded in either direction, i.e. sandwiched pills. */
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