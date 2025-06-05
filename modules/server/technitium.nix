{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.server.technitium;
in
{
  options.modules.server.technitium.enable = mkEnableOption "Enable technitium";

  config = mkIf cfg.enable {
    services.technitium-dns-server = {
      enable = true;
    };
  };
}
