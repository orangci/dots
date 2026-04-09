{
  config,
  lib,
  inputs,
  username,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.modules.server.nixflix;
in
{
  imports = [
    ./jellyfin.nix
    ./qbittorent.nix
    ./sonarr.nix
    ./radarr.nix
    ./prowlarr.nix
    ./seerr.nix
    ./networking.nix
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
      mediaUsers = lib.singleton username;
      mediaDir = "/srv/media";
      stateDor = "/srv/media/.state";
      nginx.enable = false;

      recyclarr = {
        enable = true;
        cleanupUnmanagedProfiles.enable = true;
      };
    };
  };
}
