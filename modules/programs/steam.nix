{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.programs.steam.enable =
      lib.mkEnableOption "enables steam";
  };
  config = lib.mkIf config.modules.programs.steam.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
