{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.screenshot;

  screenshotScript = ''
    #!/usr/bin/env bash
    set -euo pipefail

    usage() {
      echo "Usage: screenshot --ocr|--fullscreen [--swappy]|--area [--swappy]"
      exit 1
    }

    SWAPPY_CONFIG_DIR="$HOME/.config/swappy"

    OCR=0
    FULLSCREEN=0
    AREA=0
    USE_SWAPPY=0

    while (( $# )); do
      case "$1" in
        --ocr) OCR=1 ;;
        --fullscreen) FULLSCREEN=1 ;;
        --area) AREA=1 ;;
        --swappy) USE_SWAPPY=1 ;;
        *) usage ;;
      esac
      shift
    done

    if (( OCR )); then
      tmpimg=$(mktemp --suffix=.png)
      grim -g "$(slurp)" "$tmpimg"
      tesseract -l eng "$tmpimg" - | wl-copy
      rm "$tmpimg"
      exit 0
    fi

    if (( FULLSCREEN )); then
      tmpimg="/tmp/screenshot.png"
      wayfreeze & PID=$!
      sleep 0.1
      grim "$tmpimg"
      kill $PID
      if (( USE_SWAPPY )); then
        swappy -f "$tmpimg" --config "$SWAPPY_CONFIG_DIR/config"
      else
        notify-send "Screenshot saved" "$tmpimg"
      fi
      exit 0
    fi

    if (( AREA )); then
      tmpimg="/tmp/screenshot.png"
      wayfreeze & PID=$!
      sleep 0.1
      grim -g "$(slurp)" "$tmpimg"
      kill $PID
      if (( USE_SWAPPY )); then
        swappy -f "$tmpimg" --config "$SWAPPY_CONFIG_DIR/config"
      else
        notify-send "Screenshot saved" "$tmpimg"
      fi
      exit 0
    fi

    usage
  '';
in {
  options.hmModules.programs.screenshot = {
    enable = mkEnableOption "Enable screenshot script";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      slurp
      tesseract
      swappy
      wayfreeze
      (pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [grim slurp tesseract wl-clipboard swappy wayfreeze];
        text = screenshotScript;
      })
    ];

    home.file.".config/swappy/config".text = ''
      [Default]
      save_dir=${config.xdg.userDirs.pictures}/screenshots
      save_filename_format=%M %d-%H.%M.%S.png
      show_panel=false
      line_size=5
      text_size=20
      text_font=${config.stylix.fonts.sansSerif.name}
      paint_mode=brush
      early_exit=true
      fill_shape=false
    '';
  };
}
