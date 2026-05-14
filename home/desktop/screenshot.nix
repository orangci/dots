{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.desktop.screenshot;

  screenshotScript = ''
    #!/usr/bin/env bash
    set -euo pipefail

    usage() {
      echo "Usage: screenshot (--ocr|--fullscreen|--area) [--edit]"
      exit 1
    }

    MODE=""
    EDIT=0

    while (( $# )); do
      case "$1" in
        --ocr|--fullscreen|--area) MODE="$1" ;;
        --edit) EDIT=1 ;;
        *) usage ;;
      esac
      shift
    done

    [[ -n "$MODE" ]] || usage

    if [[ "$MODE" == "--ocr" ]]; then
      grim -g "$(slurp)" - | tesseract -l eng stdin - | wl-copy
      exit 0
    fi

    wayfreeze & PID=$!
    trap 'kill $PID 2>/dev/null || true' EXIT
    sleep 0.1

    if [[ "$MODE" == "--fullscreen" ]]; then
      GRIM_ARGS=()
    else
      GRIM_ARGS=(-g "$(slurp)")
    fi

    if (( EDIT )); then
      kill $PID 2>/dev/null
      grim "''${GRIM_ARGS[@]}" - | satty --filename -
    else
      kill $PID 2>/dev/null
      grim "''${GRIM_ARGS[@]}" - | wl-copy
    fi
  '';
in
{
  options.hmModules.desktop.screenshot.enable = mkEnableOption "Enable screenshot script";
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bindld = [ ",Print, Fullscreen Screenshot, exec, screenshot --fullscreen --edit" ];
      bindd = [
        "Super+Shift,T, Copy Text From Screenshot, exec, screenshot --ocr"
        "SUPER, S, Area Screenshot, exec, screenshot --area"
        "SUPERSHIFT, S, Area Screenshot (With Editor), exec, screenshot --area --edit"
      ];
    };
    home.packages = with pkgs; [
      grim
      slurp
      tesseract
      wayfreeze
      (pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [
          grim
          slurp
          tesseract
          wl-clipboard
          wayfreeze
        ];
        text = screenshotScript;
      })
    ];

    programs.satty = {
      enable = true;
      settings = {
        general = {
          output-filename = "${config.xdg.userDirs.extraConfig.SCREENSHOTS}/%Y-%m-%d_%H:%M:%S.png";
          initial-tool = "brush";
          fullscreen = false;
          floating-hack = true;
          resize.mode = "smart";
          corner-roundness = 12;
          early-exit = true;
          early-exit-save-as = true;
        };
        font.family = config.stylix.fonts.sansSerif.name;
        keybinds = {
          arrow = "a";
          blur = "z";
          highlight = "h";
          line = "l";
        };
      };
    };
  };
}
