{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.server.cryptpad;
in {
  options.modules.server.cryptpad.enable = mkEnableOption "Enable cryptpad";

  config = lib.mkIf cfg.enable {
    services.cryptpad = {
      enable = true;
    };
  };
}
