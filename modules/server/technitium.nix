{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.server.technitium;
in {
  options.modules.server.technitium.enable = mkEnableOption "Enable technitium";

  config = lib.mkIf cfg.enable {
    services.technitium-dns-server = {
      enable = true;
    };
  };
}
