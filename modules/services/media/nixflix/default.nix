{
  config,
  lib,
  inputs,
  users,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    singleton
    types
    ;
  cfg = config.modules.services.media.nixflix;
in
{
  imports = singleton inputs.nixflix.nixosModules.default;
  options.modules.services.media.nixflix = {
    enable = mkEnableOption "nixflix";
    port = mkOption {
      type = types.port;
      default = 4520;
      description = "The first port of the range nixflix uses. Each service listens on a fixed offset above it, e.g. Jellyfin on `port + 1`, qBittorrent on `port + 3`, Radarr on `port + 4` and Sonarr on `port + 7`.";
    };
  };

  config = mkIf cfg.enable {
    nixflix = {
      enable = true;
      mediaUsers = singleton users.sysadmin.username;
      #mediaDir = "/srv/media";
      #stateDir = "/srv/media/.state";
      nginx.enable = false;

      recyclarr = {
        enable = false;
        cleanupUnmanagedProfiles.enable = true;
      };
    };
  };
}
