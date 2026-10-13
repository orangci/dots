{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.services.infrastructure.technitium;
in
{
  options.modules.services.infrastructure.technitium.enable = mkEnableOption "technitium";

  config = mkIf cfg.enable {
    services.technitium-dns-server = {
      enable = true;
      openFirewall = true;
    };
  };
}
