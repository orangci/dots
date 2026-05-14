{
  config,
  lib,
  flakeSettings,
  users,
  ...
}:
let
  inherit (lib) mkIf mkForce my;
  cfg = config.modules.services.media.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.services.infrastructure.caddy.virtualHosts = my.mkCaddyEntry "qb" (cfg.port + 3) true;
    modules.security.sops.secrets."nixflix/qbittorent/password".path =
      "/var/secrets/nixflix-qbittorent-password";

    modules.services.monitoring.glance.monitoredSites = lib.singleton {
      url = "https://qbittorrent.${flakeSettings.domains.tailnet}";
      title = "Qbittorrent";
      icon = "sh:qbittorrent";
    };

    nixflix = {
      torrentClients.qbittorrent = {
        enable = true;
        serverConfig.Preferences.WebUI.Username = users.sysadmin.username;
        serverConfig.Preferences.WebUI.Password_PBKDF2 = "VBkxweoqIQkqk/wdJM+zZQ==:Ym+BMMq1wSzVWsZnRRdN7wtzo9g4f13O53dSZcyNUPZcjToM0lr1AnFBavuxcxVZyOUSIY/sVd/CAyfiJkL9Lg==";
        password._secret = config.modules.security.sops.secrets."nixflix/qbittorent/password".path;
        webuiPort = mkForce (cfg.port + 3);
      };
      downloadarr.qbittorrent = {
        enable = true;
        inherit (users.sysadmin) username;
        password._secret = config.modules.security.sops.secrets."nixflix/qbittorent/password".path;
        port = mkForce (cfg.port + 3);
      };
    };
  };
}
