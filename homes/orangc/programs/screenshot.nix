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

    SCREENSHOT_DIR="''${XDG_PICTURES_DIR:-$HOME/media}/screenshots"
    mkdir -p "$SCREENSHOT_DIR"
    TIMESTAMP=$(date +"%m %d-%H.%M.%S")
    FILENAME="$SCREENSHOT_DIR/$TIMESTAMP.png"

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
      grim -g "$(slurp)" "$FILENAME"
      tesseract -l eng "$FILENAME" - | wl-copy
      rm "$FILENAME"
      exit 0
    fi

    if (( FULLSCREEN || AREA )); then
      wayfreeze & PID=$!
      sleep 0.1
      if (( FULLSCREEN )); then
        grim "$FILENAME"
      else
        grim -g "$(slurp)" "$FILENAME"
      fi
      kill $PID

      if (( USE_SWAPPY )); then
        swappy -f "$FILENAME" || notify-send "Swappy failed"
      else
        wl-copy < "$FILENAME"       # <-- copy image to clipboard
        notify-send "Screenshot saved and copied" "$FILENAME"
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
