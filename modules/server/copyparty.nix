{ config, lib, inputs, username, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    singleton
    ;
  cfg = config.modules.server.copyparty;
  sharedGroup = "copyparty-${username}-shared";
in
{
  imports = singleton inputs.copyparty.nixosModules.default;
  options.modules.server.copyparty = {
    enable = mkEnableOption "Enable copyparty";

    name = mkOption {
      type = types.str;
      default = "Copyparty";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for copyparty to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "copyparty.orangc.net";
      description = "The domain for copyparty to be hosted at";
    };
  };

  config = mkIf cfg.enable {
 	users.groups.${sharedGroup} = {};
    users.users.${username}.extraGroups = singleton sharedGroup;
    users.users.copyparty.extraGroups = singleton sharedGroup;
    # sudo chgrp copyparty-orangc-shared /folder/name
    # chmod 770 /folder/name
    # chmod g+s /folder/name
    # above commands to give yourseulf and copyparty full control over a folder
    nixpkgs.overlays = singleton inputs.copyparty.overlays.default;
    modules.common.sops.secrets.copyparty-password = {
    	path = "/var/secrets/copyparty-password";
    	owner = "copyparty";
    };
    services.copyparty = {
        enable = true;
        settings.p = singleton cfg.port;
        openFilesLimit = 4096; 
        accounts.${username}.passwordFile = "/var/secrets/copyparty-password";
        volumes = {
            "/" = {
                path = "/home/${username}";
                access.A = username;
                flags.scan = 60;
                flags.fk = 4; # enable filekeys
            };
            "/public" = {
                path = "/home/${username}/public";
                access = {
                    r = "*";
                    A = username;
                };
                flags.scan = 30;
                flags.fk = 4; # enable filekeys
            };
        };
    };
  };
}
