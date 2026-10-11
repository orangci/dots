{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.hmModules.programs.ani-cli;

  aniCliMpv = pkgs.writeShellScriptBin "mpv" ''
    exec ${pkgs.mpv}/bin/mpv --no-video "$@"
  '';

  aniCliAudio = pkgs.writeShellScriptBin "ani-cli-audio" ''
    export PATH="${aniCliMpv}/bin:$PATH"
    exec ${pkgs.ani-cli}/bin/ani-cli "$@"
  '';
in
{
  options.hmModules.programs.ani-cli = {
    enable = mkEnableOption "ani-cli and ani-cli-audio";
  };

  config = mkIf cfg.enable {
    home.packages = [
      aniCliAudio
      pkgs.ani-cli
    ];
  };
}
