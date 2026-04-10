{
  config,
  lib,
  username,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.server.caddy.virtualHosts = {
      "qbittorrent.orangc.net".extraConfig = "reverse_proxy localhost:${toString (cfg.port + 3)}";
      "https://qbittorrent.cormorant-emperor.ts.net".extraConfig = ''
        bind tailscale/qbittorrent
        reverse_proxy localhost:${toString (cfg.port + 3)}
      '';
    };
    modules.common.sops.secrets."nixflix/qbittorent/password".path =
      "/var/secrets/nixflix-qbittorent-password";
    nixflix = {
      torrentClients.qbittorrent.enable = true;
      downloadarr.qbittorrent = {
        enable = false;
        inherit username;
        password._secret = config.modules.common.sops.secrets."nixflix/qbittorent/password".path;
        port = mkForce (cfg.port + 3);
      };
    };
  };
}
