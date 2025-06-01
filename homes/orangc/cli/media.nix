{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.cli.media;
in
{
  options.hmModules.cli.media.enable = mkEnableOption "Enable the media module";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      imagemagick
      catimg
      ffmpeg
      yt-dlp
    ];
  };
}
