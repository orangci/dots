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
  inherit (import ../../hosts/${host}/variables.nix) waybarBottom;
in
with lib;
{
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = if waybarBottom then "bottom" else "top";
        position = if waybarBottom then "bottom" else "top";
        margin-right = 10;
        margin-left = 10;
        margin-top = 10;

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
          format = " {:%H:%M}";
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
          on-click = "logout-exit";
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
