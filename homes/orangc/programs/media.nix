{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.media;
in {
  options.hmModules.programs.media = {
    enable = mkEnableOption "Enable MPV media player with scripts";

    gwenview = mkEnableOption "Enable Gwenview image viewer";
    imv = mkEnableOption "Enable imv image viewer";
    feh = mkEnableOption "Enable feh image viewer";
    qimgv = mkEnableOption "Enable qimgv image viewer";
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
        home.packages = [pkgs.libsForQt5.gwenview];
      })

      (mkIf cfg.imv {
        programs.imv.enable = true;
      })

      (mkIf cfg.feh {
        programs.feh.enable = true;
      })

      (mkIf cfg.qimgv {
        home.packages = [pkgs.qimgv];
      })
    ]
  );
}
