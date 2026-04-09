{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.server.caddy.virtualHosts = { };
  };
}
