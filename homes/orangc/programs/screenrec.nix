{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.screenrec;

  screenrecPackage = pkgs.writeShellScriptBin "screenrec" ''
    output_file="/tmp/screenrec.mov"
    detect_system_audio_sink() {
        sink=$(pactl info | awk -F': ' '/Default Sink:/ {print $2}')
        monitor_source=$(pactl list sources short | awk -v sink="$sink.monitor" '$2 == sink {print $2; exit}')
        if [[ -n "$monitor_source" ]]; then
            echo "$monitor_source"
            return
        fi
        pactl list sources short | grep monitor | head -n1 | awk '{print $2}'
    }

    audio_sink="$(detect_system_audio_sink)"

    if [[ -z "$audio_sink" ]]; then
        notify-send "Screen Recording" "Error: Could not detect system audio sink."
        exit 1
    fi

    # Check for --area flag
    area_mode=false
    for arg in "$@"; do
        [[ "$arg" == "--area" ]] && area_mode=true
    done

    # Start recording
    notify-send "Screen Recording" "Recording started..."
    if $area_mode; then
        geometry="$(slurp)"
        [[ -z "$geometry" ]] && notify-send "Screen Recording" "Area selection canceled." && exit 1
        wl-screenrec -g "$geometry" -f "$output_file" --audio --audio-device "$audio_sink" &
    else
        wl-screenrec -f "$output_file" --audio --audio-device "$audio_sink" &
    fi

    recorder_pid=$!
    wait "$recorder_pid"

    if [[ ! -f "$output_file" ]]; then
        notify-send "Screen Recording" "Recording failed: Output file not created."
        exit 1
    fi

    save_location=$(yad --file --save --title="Save Recording As" --filename="$HOME/media/vids/$(date +'%B %d %H.%M').mov")
    if [[ -z "$save_location" ]]; then
        notify-send "Screen Recording" "Recording canceled."
        rm -f "$output_file"
        exit 1
    fi

    mv "$output_file" "$save_location"
    notify-send "Screen Recording" "Recording saved to $save_location"
  '';
in {
  options.hmModules.programs.screenrec.enable = mkEnableOption "Enable screenrec script";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER, O, Start Screen Recording, exec, screenrec"
      "SUPERALT, O, Start Screen Recording (Area), exec, screenrec --area"
      "SUPERSHIFT, O, Stop Screen Recording, exec, pkill wl-screenrec"
    ];
    home.packages = [screenrecPackage pkgs.wl-screenrec pkgs.yad];
  };
}
