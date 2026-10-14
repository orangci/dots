{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.hmModules.programs.media;
in
{
  options.hmModules.programs.media = {
    enable = mkEnableOption "MPV media player with scripts";

    gwenview = mkEnableOption "Gwenview image viewer";
    imv = mkEnableOption "imv image viewer";
    feh = mkEnableOption "feh image viewer";
    qimgv = mkEnableOption "qimgv image viewer";

    xdg = lib.mkOption {
      type = lib.types.str;
      example = "imv.desktop";
      description = "The `.desktop` file of the default image viewer, used for XDG mime associations. The image viewer options above set this themselves, so enable only one of them.";
    };
  };

  config = mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.mpv = {
          enable = true;
          scripts = with pkgs.mpvScripts; [
            mpris
            thumbfast
            modernx-zydezu
            mpv-image-viewer.equalizer
            videoclip
            occivink.crop
          ];
        };
      }

      (mkIf cfg.gwenview {
        hmModules.programs.media.xdg = "org.kde.gwenview.desktop";
        home.packages = [ pkgs.kdePackages.gwenview ];
      })

      (mkIf cfg.imv {
        programs.imv.enable = true;
        hmModules.programs.media.xdg = "imv.desktop";
      })

      (mkIf cfg.feh {
        programs.feh.enable = true;
        hmModules.programs.media.xdg = "feh.desktop";
      })

      (mkIf cfg.qimgv {
        hmModules.programs.media.xdg = "qimgv.desktop";
        home.packages = [ pkgs.qimgv ];
      })
    ]
  );
}
