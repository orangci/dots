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
    mkOption
    mkEnableOption
    types
    singleton
    ;
  cfg = config.modules.server.copyparty;
  commonPerms = {
    access = {
      r = "*";
      A = username;
    };
    flags = {
      scan = 30;
      fk = 4;
    };
  };
in
{
  imports = singleton inputs.copyparty.nixosModules.default;
  options.modules.server.copyparty = {
    enable = mkEnableOption "Enable copyparty";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    httpHome.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

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
    nixpkgs.overlays = singleton inputs.copyparty.overlays.default;
    modules.common.sops.secrets.copyparty-password = {
      path = "/var/secrets/copyparty-password";
      owner = "copyparty";
    };
    services.copyparty = {
      enable = true;
      settings.p = singleton cfg.port;
      openFilesLimit = 4096;
      accounts.${username}.passwordFile = config.modules.common.sops.secrets.copyparty-password.path;
      volumes = {
        "/" = {
          path = "/srv/files";
          access.A = username;
          flags.scan = 60;
          flags.fk = 4; # enable filekeys
        };
        "/books" = commonPerms // {
          path = "/srv/files/books";
        };
        "/juniper-backups" = commonPerms // {
          path = "/srv/files/juniper-backups";
        };
        "/media/walls" = commonPerms // {
          path = "/srv/files/media/walls";
        };
        "/media/walls-catppuccin-mocha" = commonPerms // {
          path = "/srv/files/media/walls-catppuccin-mocha";
        };
        "/media/memes" = commonPerms // {
          path = "/srv/files/media/memes";
        };
      };
    };
  };
}
