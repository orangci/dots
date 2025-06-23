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
  cfg = config.hmModules.misc.screenrec;

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
  options.hmModules.misc.screenrec = {
    # For more information about gpu-screen-recorder, see https://git.dec05eba.com/gpu-screen-recorder/about/.
    enable = mkEnableOption "Enable screenrec script";

    timestampFormat = mkOption {
      type = types.str;
      default = "%B %d %H.%M";
      description = "Timestamp format for filenames";
    };

    fileFormat = mkOption {
      type = types.str;
      default = "mkv";
    };

    quality = mkOption {
      type = types.enum [
        "medium"
        "high"
        "very_high"
        "ultra"
      ];
      default = "very_high";
    };

    encoder = mkOption {
      type = types.enum [
        "gpu"
        "cpu"
      ];
      default = "gpu";
    };

    showCursor = mkOption {
      type = types.enum [
        "yes"
        "no"
      ];
      default = "yes";
    };

    framerate = mkOption {
      type = types.int;
      default = 60;
      description = "Framerate to record at";
    };

    codec = mkOption {
      type = types.str;
      default = "auto";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER, O, Start Screen Recording, exec, screenrec"
      "SUPERALT, O, Start Screen Recording (Mic), exec, screenrec --mic"
      # "SUPERCONTROL, O, Start Screen Recording (Area), exec, screenrec --portal"
      "SUPERCONTROL, O, Pause Screen Recording, exec, pkill -SIGUSR2 -f gpu-screen-recorder; notify-send 'Paused screen recording.' -t 1000 -a gpu-screen-recorder"
      "SUPERSHIFT, O, Stop Screen Recording, exec, pkill -SIGINT -f gpu-screen-recorder; notify-send 'Stopped screen recording.' 'Saved to ${config.xdg.userDirs.videos}' -t 1000 -a gpu-screen-recorder"
    ];
    home.packages = [
      screenrecPackage
      pkgs.gpu-screen-recorder
      pkgs.gpu-screen-recorder-gtk
    ];
  };
}
