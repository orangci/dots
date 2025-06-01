{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.server.uptime-kuma;
in {
  options.modules.server.uptime-kuma.enable = mkEnableOption "Enable uptime-kuma";

  config = lib.mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
    };
  };
}
