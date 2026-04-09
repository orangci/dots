{
  config,
  lib,
  username,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.common.sops.secrets."nixflix/qbittorent/password".path =
      "/var/secrets/nixflix-qbittorent-password";
    nixflix = {
      torrentClients.qbittorrent.enable = true;
      downloadarr.qbittorent = {
        enable = true;
        inherit username;
        password._secret = config.modules.common.sops.secrets."nixflix/qbittorent/password".path;
        port = cfg.port + 3;
      };
    };
  };
}
