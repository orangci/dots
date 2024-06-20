{
  pkgs,
  config,
  host,
  ...
}:
let
  palette = config.stylix.base16Scheme;
  inherit (import ../hosts/${host}/variables.nix) boxyStyle;
in
{
  home.file.".config/swaync/config.json".text = ''
        {
            "$schema": "/etc/xdg/swaync/configSchema.json",
            "positionX": "right",
            "positionY": "top",
            "control-center-margin-top": 10,
            "control-center-margin-bottom": 10,
            "control-center-margin-right": 13,
            "control-center-margin-left": 10,
            "notification-icon-size": 64,
            "notification-body-image-height": 100,
            "notification-body-image-width": 200,
            "timeout": 10,
            "timeout-low": 5,
            "timeout-critical": 0,
            "fit-to-screen": false,
            "control-center-width": 500,
            "control-center-height": 1025,
            "notification-window-width": 500,
            "keyboard-shortcuts": true,
            "image-visibility": "when-available",
            "transition-time": 200,
            "hide-on-clear": true,
            "hide-on-action": true,
            "script-fail-notify": true,
            "widgets": [
                "mpris",
                "title",
                "dnd",
                "notifications"
            ],
            "widget-config": {
                "title": {
                    "text": "Notifications",
                    "clear-all-button": true,
                    "button-text": "󰆴 Clear All"
                },
                "dnd": {
                    "text": "Do Not Disturb"
                },
                "label": {
                    "max-lines": 1,
                    "text": "Notifications"
                },
                "mpris": {
                    "image-size": 96,
                    "image-radius": 7
                }
        }
    }
  '';

  home.file.".config/swaync/style.css".text = ''
    * {
        font-family: Ubuntu;
        font-weight: bolder;
    }

    .control-center .notification-row:focus,
    .control-center .notification-row:hover {
    ${if boxyStyle == true then ''opacity: 1;'' else ''opacity: 0.9;''}
        background: #${palette.base00};
    }

    .notification-row {
        outline: none;
        margin: 10px;
        padding: 0;
    }

    .notification {
        background: transparent;
        padding: 0;
        margin: 0px;
    }

    .notification-content {
        background: #${palette.base00};
        padding: 10px;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
        border: 1px solid #${palette.base01};
        margin: 0;
    }

    .notification-default-action {
        margin: 0;
        padding: 0;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }

    .close-button {
        background: #${palette.base08};
        color: #${palette.base00};
        text-shadow: none;
        padding: 0;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
        margin-top: 5px;
        margin-right: 5px;
    }

    .close-button:hover {
        box-shadow: none;
        background: #${palette.base0E};
        transition: all .15s ease-in-out;
        border: none;
    }


    .notification-action {
        border-top: none;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }


    .notification-default-action:hover,
    .notification-action:hover {
        color: #${palette.base0E};
        background: #${palette.base0E};
    }

    .notification-default-action {
        border-bottom-left-radius: 15px;
        border-bottom-right-radius: 15px;
        margin: 0px;
    }

    .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 15px;
        border-bottom-right-radius: 15px;
    }

    .notification-action:first-child {
        border-bottom-left-radius: 15px;
        background: #${palette.base00};
    }

    .notification-action:last-child {
        border-bottom-right-radius: 15px;
        background: #${palette.base00};
    }

    .inline-reply {
        margin-top: 8px;
    }

    .inline-reply-entry {
        background: #${palette.base00};
        color: #${palette.base05};
        caret-color: #${palette.base05};
        border: 1px solid #${palette.base09};
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }

    .inline-reply-button {
        margin-left: 4px;
        background: #${palette.base00};
        border: 1px solid #${palette.base09};
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
        color: #${palette.base05};
    }

    .inline-reply-button:disabled {
        background: initial;
        color: #${palette.base03};
        border: 1px solid transparent;
    }

    .inline-reply-button:hover {
        background: #${palette.base00};
    }

    .body-image {
        margin-top: 6px;
        background-color: #${palette.base05};
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 5px;''}
    }

    .summary {
        font-size: 16px;
        font-weight: 700;
        background: transparent;
        color: rgba(158, 206, 106, 1);
        text-shadow: none;
    }

    .time {
        font-size: 16px;
        font-weight: 700;
        background: transparent;
        color: #${palette.base05};
        text-shadow: none;
        margin-right: 18px;
    }

    .body {
        font-size: 15px;
        font-weight: 400;
        background: transparent;
        color: #${palette.base05};
        text-shadow: none;
    }

    .control-center {
        background: #${palette.base00};
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }

    .control-center-list {
        background: transparent;
    }

    .control-center-list-placeholder {
        opacity: .5;
    }

    .floating-notifications {
        background: transparent;
    }

    .blank-window {
        background: alpha(black, 0);
    }

    .widget-title {
        color: #${palette.base0E};
        background: #${palette.base00};
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        font-size: 1.5rem;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }

    .widget-title>button {
        font-size: 1rem;
        color: #${palette.base05};
        text-shadow: none;
        background: #${palette.base00};
        box-shadow: none;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }

    .widget-title>button:hover {
        background: #${palette.base08};
        color: #${palette.base00};
    }

    .widget-dnd {
        background: #${palette.base00};
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
        font-size: large;
        color: #${palette.base0E};
    }

    .widget-dnd>switch {
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
        /* border: 1px solid #${palette.base0E}; */
        background: #${palette.base0E};
    }

    .widget-dnd>switch:checked {
        background: #${palette.base08};
        border: 1px solid #${palette.base08};
    }

    .widget-dnd>switch slider {
        background: #${palette.base00};
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }

    .widget-dnd>switch:checked slider {
        background: #${palette.base00};
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }

    .widget-label {
        margin: 10px 10px 5px 10px;
    }

    .widget-label>label {
        font-size: 1rem;
        color: #${palette.base05};
    }

    .widget-mpris {
        color: #${palette.base05};
        background: #${palette.base00};
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }

    .widget-mpris > box > button {
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }

    .widget-mpris-player {
        padding: 5px 10px;
        margin: 10px;
    }

    .widget-mpris-title {
        font-weight: 700;
        font-size: 1.25rem;
    }

    .widget-mpris-subtitle {
        font-size: 1.1rem;
    }

        .widget-buttons-grid {
        font-size: x-large;
        padding: 5px;
        margin: 10px 10px 5px 10px;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
        background: #${palette.base01};
    }

    .widget-buttons-grid>flowbox>flowboxchild>button {
        margin: 3px;
        background: #${palette.base00};
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
        color: #${palette.base05};
    }

    .widget-buttons-grid>flowbox>flowboxchild>button:hover {
        background: rgba(122, 162, 247, 1);
        color: #${palette.base00};
    }

    .widget-menubar>box>.menu-button-bar>button {
        border: none;
        background: transparent;
    }

    .topbar-buttons>button {
        border: none;
        background: transparent;
    }

        .widget-volume {
        background: #${palette.base01};
        padding: 5px;
        margin: 10px 10px 5px 10px;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
        font-size: x-large;
        color: #${palette.base05};
    }

    .widget-volume>box>button {
        background: #${palette.base0B};
        border: none;
    }

    .per-app-volume {
        background-color: #${palette.base00};
        padding: 4px 8px 8px;
        margin: 0 8px 8px;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
    }

    .widget-backlight {
        background: #${palette.base01};
        padding: 5px;
        margin: 10px 10px 5px 10px;
        ${if boxyStyle == true then ''border-radius: 0px;'' else ''border-radius: 15px;''}
        font-size: x-large;
        color: #${palette.base05}
    }
  '';
}
