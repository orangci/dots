{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.hmModules.desktop.screenrec;

  screenrecPackage = pkgs.writeShellScriptBin "screenrec" ''
    # === Configurable Variables ===
    timestamp="$(date +'${cfg.timestampFormat}')"
    output_file="${config.xdg.userDirs.videos}/$timestamp.${cfg.fileFormat}"
    common_args=(-f "${toString cfg.framerate}" -q "${cfg.quality}" -k "${cfg.codec}" -encoder "${cfg.encoder}" -cursor "${cfg.showCursor}" -o "$output_file" -a "default_output")

    # === Argument Handling ===
    portal=false
    mic=false

    # Parse arguments
    for arg in "$@"; do
        case $arg in
            --portal)
                portal=true
                ;;
            --mic)
                mic=true
                ;;
        esac
    done

    # Add mic input if needed
    if $mic; then
        common_args+=(-a "default_input")
    fi

    # === Determine Window Target ===
    notify-send "Started recording." "Don't doxx yerself!" -t 1000 -a gpu-screen-recorder
    if $portal; then
        gpu-screen-recorder -w portal "''${common_args[@]}"
    else
        gpu-screen-recorder -w screen "''${common_args[@]}"
    fi

  '';
in
{
  options.hmModules.desktop.screenrec = {
    # For more information about gpu-screen-recorder, see https://git.dec05eba.com/gpu-screen-recorder/about/.
    enable = mkEnableOption "screenrec script";

    timestampFormat = mkOption {
      type = types.str;
      default = "%y-%b-%d_%H.%M.%S";
      example = "%Y-%m-%d_%H.%M.%S";
      description = "The `date` format string used to name recordings.";
    };

    fileFormat = mkOption {
      type = types.str;
      default = "mkv";
      example = "mp4";
      description = "The container format of the recording. This is also used as the file extension.";
    };

    quality = mkOption {
      type = types.enum [
        "medium"
        "high"
        "very_high"
        "ultra"
      ];
      default = "very_high";
      description = "Recording quality, as understood by gpu-screen-recorder's `-q` flag. Higher qualities make larger files.";
    };

    encoder = mkOption {
      type = types.enum [
        "gpu"
        "cpu"
      ];
      default = "gpu";
      description = "Whether to encode the video on the GPU or the CPU.";
    };

    showCursor = mkOption {
      type = types.enum [
        "yes"
        "no"
      ];
      default = "yes";
      description = "Whether the mouse cursor is visible in recordings.";
    };

    framerate = mkOption {
      type = types.int;
      default = 60;
      example = 30;
      description = "The framerate to record at, in frames per second.";
    };

    codec = mkOption {
      type = types.str;
      default = "auto";
      example = "h264";
      description = "The video codec to encode with, as understood by gpu-screen-recorder's `-k` flag. `auto` lets it pick one.";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = lib.my.hyprlandLua.bindd [
      "SUPER, O, Start Screen Recording, exec, screenrec"
      "SUPERALT, O, Start Screen Recording (Mic), exec, screenrec --mic"
      # "SUPERCONTROL, O, Start Screen Recording (Area), exec, screenrec --portal"
      "SUPERCONTROL, O, Pause Screen Recording, exec, pkill -SIGUSR2 -f gpu-screen-recorder; notify-send 'Paused screen recording.' -t 1000 -a gpu-screen-recorder"
      "SUPERSHIFT, O, Stop Screen Recording, exec, pkill -SIGINT -f gpu-screen-recorder; notify-send 'Stopped screen recording.' 'Saved to ${config.xdg.userDirs.videos}' -t 1000 -a gpu-screen-recorder"
    ];
    wayland.windowManager.niri.settings.binds = {
      "Mod+O" = {
        _props.hotkey-overlay-title = "Start Screen Recording";
        spawn = [ "screenrec" ];
      };
      "Mod+Alt+O" = {
        _props.hotkey-overlay-title = "Start Screen Recording (Mic)";
        spawn = [
          "screenrec"
          "--mic"
        ];
      };
      "Mod+Ctrl+O" = {
        _props.hotkey-overlay-title = "Pause Screen Recording";
        spawn-sh = "pkill -SIGUSR2 -f gpu-screen-recorder; notify-send 'Paused screen recording.' -t 1000 -a gpu-screen-recorder";
      };
      "Mod+Shift+O" = {
        _props.hotkey-overlay-title = "Stop Screen Recording";
        spawn-sh = "pkill -SIGINT -f gpu-screen-recorder; notify-send 'Stopped screen recording.' 'Saved to ${config.xdg.userDirs.videos}' -t 1000 -a gpu-screen-recorder";
      };
    };
    home.packages = [
      screenrecPackage
      pkgs.gpu-screen-recorder
      pkgs.gpu-screen-recorder-gtk
    ];
  };
}
