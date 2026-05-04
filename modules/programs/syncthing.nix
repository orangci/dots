{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    singleton
    ;
  cfg = config.modules.programs.syncthing;
in
{
  options.modules.programs.syncthing = {
    enable = mkEnableOption "Syncthing folder syncing";

    exampleOption = mkOption {
      type = types.str;
      default = "example";
      description = "An example option";
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: broken :c
    services.syncthing = {
      enable = true;
      openDefaultPorts = true; # only works for single-user machines btw
      guiAddress = "0.0.0.0:8384";
      settings = {
        devices = {
          evergarden = {
            addresses = singleton "tcp://evergarden:51820";
            id = "CYQYTQP-HMRCWEZ-FDGT4KF-3JPOG3A-K6WUUCP-WKSIH4F-6B7EUIZ-XID4KAP";
            name = "evergarden";
          };
        };
        folders = {
          docs = {
            id = "docs";
            devices = [ "evergarden" ];
            path = "/home/${flakeSettings.username}/docs";
          };
        };
      };
    };
  };
}
