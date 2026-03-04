{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf singleton;
  cfg = config.modules.server.technitium;
  stateDir = "/var/lib/technitium-dns-server";
in
{
  options.modules.server.technitium.enable = mkEnableOption "Enable technitium";

  config = mkIf cfg.enable {
    services.technitium-dns-server = {
      enable = true;
      openFirewall = true;
    };
  };
}
