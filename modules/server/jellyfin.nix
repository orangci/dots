{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.jellyfin;
in
{
  options.modules.server.jellyfin = {
    enable = mkEnableOption "Enable jellyfin";

    name = mkOption {
      type = types.str;
      default = "Jellyfin";
    };

    port = mkOption {
      type = types.port;
      default = 8920;
      description = "The port for jellyfin to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "jellyfin.orangc.net";
      description = "The domain for jellyfin to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
    };
  };
}
