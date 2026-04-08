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
    inputs.nixflix.nixosModules.default
  ];
  options.modules.server.nixflix = {
    enable = mkEnableOption "Enable nixflix";
  };

  config = mkIf cfg.enable {
    nixflix = {
      enable = true;
      mediaUsers = singleton username;
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
