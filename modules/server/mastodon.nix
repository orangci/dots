{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.mastodon;
in
{
  options.modules.server.mastodon = {
    enable = mkEnableOption "Enable mastodon";

    name = mkOption {
      type = types.str;
      default = "Mastodon";
    };

    port = mkOption {
      type = types.int;
      default = 8803;
      description = "The port for mastodon to be hosted at";
    };

    domain = mkOption {
      type = types.str;
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
      streamingProcesses = 2; # TODO
      smtp.fromAddress = "mastodon@orangc.net";
    };
  };
}
