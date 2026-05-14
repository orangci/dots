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
