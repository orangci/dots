{
  config,
  lib,
  username,
  tailnetName,
  primaryDomain,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.server.cloudflared.ingress."qbittorent.${primaryDomain}" =
      "http://localhost:${toString (cfg.port + 3)}";
    modules.server.caddy.virtualHosts = {
      "qbittorrent.${primaryDomain}".extraConfig = "reverse_proxy localhost:${toString (cfg.port + 3)}";
      "https://qbittorrent.${tailnetName}".extraConfig = ''
        bind tailscale/qbittorrent
        reverse_proxy localhost:${toString (cfg.port + 3)}
      '';
    };
    modules.common.sops.secrets."nixflix/qbittorent/password".path =
      "/var/secrets/nixflix-qbittorent-password";
    nixflix = {
      torrentClients.qbittorrent = {
        enable = true;
        serverConfig.Preferences.WebUI.Username = username;
        serverConfig.Preferences.WebUI.Password_PBKDF2 = "VBkxweoqIQkqk/wdJM+zZQ==:Ym+BMMq1wSzVWsZnRRdN7wtzo9g4f13O53dSZcyNUPZcjToM0lr1AnFBavuxcxVZyOUSIY/sVd/CAyfiJkL9Lg==";
        password._secret = config.modules.common.sops.secrets."nixflix/qbittorent/password".path;
        webuiPort = mkForce (cfg.port + 3);
      };
      downloadarr.qbittorrent = {
        enable = true;
        inherit username;
        password._secret = config.modules.common.sops.secrets."nixflix/qbittorent/password".path;
        port = mkForce (cfg.port + 3);
      };
    };
  };
}
