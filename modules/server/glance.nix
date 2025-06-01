{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.server.glance;
in {
  options.modules.server.glance.enable = mkEnableOption "Enable glance";

  config = lib.mkIf cfg.enable {
    services.glance = {
      enable = true;
      openFirewall = true;
      settings = {
        server.port = 4242;
        pages = {
          # TODO: config - https://github.com/glanceapp/glance/blob/main/docs/configuration.md#pages--columns
          # also see https://search.nixos.org/options?channel=unstable&show=services.glance.settings.pages&from=0&size=50&sort=relevance&type=packages&query=services.glance.
        };
      };
    };
  };
}
