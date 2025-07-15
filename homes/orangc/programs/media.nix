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
    mkForce
    mkDefault
    ;
  cfg = config.hmModules.programs.media;
in
{
  options.hmModules.programs.media = {
    enable = mkEnableOption "Enable MPV media player with scripts";

    gwenview = mkEnableOption "Enable Gwenview image viewer";
    imv = mkEnableOption "Enable imv image viewer";
    feh = mkEnableOption "Enable feh image viewer";
    qimgv = mkEnableOption "Enable qimgv image viewer";

    xdg = lib.mkOption {
      type = lib.types.str;
      description = "The .desktop filename to use for XDG";
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
        hmModules.programs.media.xdg = mkForce "org.kde.kdegraphics.gwenview.lib";
        home.packages = [ pkgs.libsForQt5.gwenview ];
      })

      (mkIf cfg.imv {
        programs.imv.enable = true;
        hmModules.programs.media.xdg = mkDefault "imv.desktop";
      })

      (mkIf cfg.qimgv {
        hmModules.programs.media.xdg = "qimgv.desktop";
        home.packages = [ pkgs.qimgv ];
      })
    ]
  );
}
