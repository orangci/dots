{
  config,
  lib,
  pkgs,
  ...
}: let
  palette = config.colorScheme.palette;
in {
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "sleep 1; systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        "label" = "reboot";
        "action" = "sleep 1; systemctl reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
      {
        "label" = "logout";
        "action" = "sleep 1; hyprctl dispatch exit";
        "text" = "Exit";
        "keybind" = "e";
      }
      {
        "label" = "lock";
        "action" = "sleep 1; hyprlock";
        "text" = "Lock";
        "keybind" = "l";
      }
    ];
    style = ''
           * {
             font-family: "JetBrainsMono NF", FontAwesome, sans-serif;
      background-image: none;
      transition: 20ms;
           }
           window {
      background-color: rgba(12, 12, 12, 0.1);
           }
           button {
      color: #${palette.base05};
             font-size:20px;
             background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
      border-style: solid;
      background-color: rgba(12, 12, 12, 0.3);
      border: 3px solid #${palette.base05};
             box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
           }
           button:focus,
           button:active,
           button:hover {
               color: #${palette.base0E};
        background-color: rgba(12, 12, 12, 0.5);
        border: 3px solid #${palette.base0E};
           }
           #logout {
      background-image: image(url("icons/logout.png"));
           }
           #shutdown {
      background-image: image(url("icons/shutdown.png"));
           }
           #reboot {
      background-image: image(url("icons/reboot.png"));
           }
           #lock {
      background-image: image(url("icons/lock.png"));
           }

           #lock, #reboot, #shutdown, #logout {
      margin: 10px;
      border-radius: 24px;
           }
    '';
  };
}
