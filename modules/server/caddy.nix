{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.server.caddy;
in
{
  options.modules.server.caddy.enable = mkEnableOption "Enable the Caddy web server";

  config = mkIf cfg.enable {
    services.caddy.enable = true;
    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
    };
  };
}
