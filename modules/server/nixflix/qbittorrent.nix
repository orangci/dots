{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib) mkIf mkForce my;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.server.caddy.virtualHosts = my.mkCaddyEntry "qb" (cfg.port + 3) true;
    modules.common.sops.secrets."nixflix/qbittorent/password".path =
      "/var/secrets/nixflix-qbittorent-password";

    modules.server.glance.monitoredSites = lib.singleton {
      url = "https://qbittorrent.${flakeSettings.domains.tailnet}";
      title = "Qbittorrent";
      icon = "sh:qbittorrent";
    };

    nixflix = {
      torrentClients.qbittorrent = {
        enable = true;
        serverConfig.Preferences.WebUI.Username = flakeSettings.username;
        serverConfig.Preferences.WebUI.Password_PBKDF2 = "VBkxweoqIQkqk/wdJM+zZQ==:Ym+BMMq1wSzVWsZnRRdN7wtzo9g4f13O53dSZcyNUPZcjToM0lr1AnFBavuxcxVZyOUSIY/sVd/CAyfiJkL9Lg==";
        password._secret = config.modules.common.sops.secrets."nixflix/qbittorent/password".path;
        webuiPort = mkForce (cfg.port + 3);
      };
      downloadarr.qbittorrent = {
        enable = true;
        inherit (flakeSettings) username;
        password._secret = config.modules.common.sops.secrets."nixflix/qbittorent/password".path;
        port = mkForce (cfg.port + 3);
      };
    };
  };
}
