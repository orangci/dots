{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.immich;
in
{
  options.modules.server.immich.enable = mkEnableOption "Enable immich";

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      port = 2283;
    };
  };
}
