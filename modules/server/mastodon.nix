{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption;
  cfg = config.modules.server.mastodon;
in
{
  options.modules.server.mastodon = {
    enable = mkEnableOption "Enable mastodon";

    port = mkOption {
      type = lib.types.int;
      default = 8803;
      description = "The port for mastodon to be hosted at";
    };

    domain = mkOption {
      type = lib.types.str;
      default = "mastodon.orangc.net";
      description = "The domain for mastodon to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.mastodon = {
      enable = true;
      localDomain = cfg.domain;
      webPort = cfg.port;
      mediaAutoRemove.olderThanDays = 7;
    };
    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
