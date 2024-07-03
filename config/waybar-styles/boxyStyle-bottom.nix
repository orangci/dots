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
        layer = "bottom";
        position = "bottom";

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
            font-size: 16px;
            font-family: JetBrainsMono NFM, Font Awesome, sans-serif;
            font-weight: bold;
            padding: 1px 2px;
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
            transition: ${betterTransition};
          }
          #workspaces button.active {
            color: #${palette.base00};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            transition: ${betterTransition};
            opacity: 1.0;
            min-width: 40px;
          }
          #workspaces button:hover {
            color: #${palette.base05};
            background-size: 300% 300%;
            animation: gradient_horizontal 15s ease infinite;
            opacity: 1.0;
            transition: ${betterTransition};
          }
          @keyframes gradient_horizontal {0% {background-position: 0% 50%;} 50% {background-position: 100% 50%;} 100% {background-position: 0% 50%;}}
          @keyframes swiping {0% {background-position: 0% 200%;} 00% {background-position: 200% 200%;}}

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
