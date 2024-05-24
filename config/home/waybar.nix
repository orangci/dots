{
  pkgs,
  config,
  lib,
  host,
  ...
}: let
  palette = config.colorScheme.palette;
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  inherit (import ../../hosts/${host}/options.nix) bar-number clock24h username hostname;
in
  with lib; {
    # Configure & Theme Waybar
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = [
        {
          layer = "top";
          position = "top";

          modules-center = ["hyprland/window" "clock"];
          modules-left = ["hyprland/workspaces" "custom/previouspls" "custom/nextpls" "cpu" "memory"];
          modules-right = ["custom/exit" "idle_inhibitor" "pulseaudio" "custom/weather" "network" "tray" "custom/notification"];

          "hyprland/workspaces" = {
            format =
              if bar-number == true
              then "{name}"
              else "{icon}";
            format-icons = {
              default = " ";
              active = " ";
              urgent = " ";
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          "clock" = {
            format =
              if clock24h == true
              then '' {:L%H:%M}''
              else '' {:L%I:%M %p}'';
            tooltip = true;
            tooltip-format = "<big>{:%A, %d.%b.%Y }</big>";
          };
          "hyprland/window" = {
            max-length = 25;
            separate-outputs = false;
            rewrite = {"" = "${username}@${hostname}";};
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
            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
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
              default = ["" "" ""];
            };
            on-click = "sleep 0.1 && pavucontrol";
          };
          "custom/exit" = {
            tooltip = false;
            format = "";
            on-click = "wlogout -b 2";
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
            on-click = "sleep 0.1 && task-waybar";
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
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
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
              font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
              font-weight: bold;
              color: #${palette.base00};
            }
            window#waybar {
              background-color: rgba(255,0,0,0);
              border-radius: 0px;
              color: #${palette.base0F};
            }



          /* >>> LEFT MODULES <<< */
            #workspaces {
              background: #${palette.base00};
              margin: 2px;
              padding: 0px 1px;
              border-radius: 15px;
              border: 0px;
              font-style: normal;
              color: #${palette.base05}; /* Ensure this rule applies */
            }
            #workspaces button {
              padding: 0px 5px;
              margin: 4px 3px;
              border-radius: 15px;
              border: 0px;
              color: #${palette.base05}; /* Ensure this rule applies */
              background: #${palette.base00};
              background-size: 300% 300%;
              animation: gradient_horizontal 15s ease infinite;
              opacity: 0.5;
              transition: ${betterTransition};
            }
            #workspaces button.active {
              padding: 0px 5px;
              margin: 4px 3px;
              border-radius: 15px;
              border: 0px;
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
              color: #${palette.base05}; /* Ensure this rule applies */
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
            tooltip {
              background: #${palette.base00};
              border: 1px solid #${palette.base0E};
              border-radius: 15px;
            }
            tooltip label {
              color: #${palette.base07};
            }


            #custom-previouspls {
              background: #${palette.base0E};
              border-radius: 15px 0px 0px 15px;
              margin: 4px 0px 4px 2px;
              padding: 2px 5px 2px 15px;
            }
            #custom-nextpls {
              background: #${palette.base0E};
              margin: 4px 2px 4px 0px;
              padding: 2px 10px 2px 5px;
              border-radius: 0px 15px 15px 0px;
            }
            #cpu {
              background: #${palette.base0D};
              border-radius: 15px 0px 0px 15px;
              margin: 4px 0px 4px 2px;
              padding: 2px 5px 2px 15px;
            }
            #memory {
              background: #${palette.base0D};
              margin: 4px 2px 4px 0px;
              padding: 2px 10px 2px 5px;
              border-radius: 0px 15px 15px 0px;
            }
            #disk {
              background: #${palette.base03};
              margin: 4px;
              padding: 2px 10px;
              border-radius: 15px;
            }
            #battery {
              background: #${palette.base08};
              margin: 4px;
              padding: 2px 10px;
              border-radius: 15px;
            }



            /* >>> CENTER MODULES <<< */
            #window {
              margin: 4px;
              padding: 2px 10px;
              background: #${palette.base0C};
              border-radius: 15px;
            }
            #clock {
              background: #${palette.base0B};
              margin: 4px;
              padding: 2px 10px;
              border-radius: 15px;
            }



            /* >>> RIGHT MODULES <<< */
            #custom-exit {
              background: #${palette.base0A};
              border-radius: 15px 0px 0px 15px;
              margin: 4px 0px;
              padding: 2px 5px 2px 15px;
            }
            #idle_inhibitor {
              background: #${palette.base0A};
              margin: 4px 0px;
              padding: 2px 14px;
              border-radius: 0px;
            }
            #pulseaudio {
              background: #${palette.base0A};
              margin: 4px 0px;
              padding: 2px 10px 2px 5px;
              border-radius: 0px 15px 15px 0px;
            }
            #custom-weather {
              background: #${palette.base09};
              margin: 4px;
              padding: 2px 10px;
              border-radius: 15px;
            }
            #network {
              background: #${palette.base08};
              border-radius: 15px 0px 0px 15px;
              margin: 4px 0px;
              padding: 2px 5px 2px 15px;
            }
            #tray {
              background: #${palette.base08};
              margin: 4px 0px;
              padding: 2px 14px;
              border-radius: 0px;
            }
            #custom-notification {
              background: #${palette.base08};
              margin: 4px 2px 4px 0px;
              padding: 2px 10px 2px 5px;
              border-radius: 0px 15px 15px 0px;
            }
        ''
      ];
    };
  }
