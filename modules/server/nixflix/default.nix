{
  config,
  lib,
  inputs,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.modules.server.nixflix;
in
{
  imports = [
    ./jellyfin.nix
    ./qbittorrent.nix
    ./sonarr.nix
    ./radarr.nix
    ./prowlarr.nix
    # ./seerr.nix
    inputs.nixflix.nixosModules.default
  ];
  options.modules.server.nixflix = {
    enable = mkEnableOption "Enable nixflix";
    port = mkOption {
      type = types.port;
      default = 4520;
      description = "The port 'range' to use. Services in nixflix will use a port starting from here and adding +1";
    };
  };

  config = mkIf cfg.enable {
    nixflix = {
      enable = true;
      mediaUsers = lib.singleton flakeSettings.username;
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
