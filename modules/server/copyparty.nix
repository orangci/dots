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
    singleton
    ;
  cfg = config.modules.server.copyparty;
  commonPerms = {
    access = {
      r = "*";
      A = flakeSettings.username;
    };
    flags = {
      scan = 30;
      fk = 4;
    };
  };
in
{
  imports = singleton inputs.copyparty.nixosModules.default;
  options.modules.server.copyparty = lib.my.mkServerModule {
    name = "Copyparty";
    subdomain = "files";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = singleton inputs.copyparty.overlays.default;
    users.users.${flakeSettings.username}.extraGroups = singleton "copyparty";
    modules.common.sops.secrets.copyparty-password = {
      path = "/var/secrets/copyparty-password";
      owner = "copyparty";
    };
    services.copyparty = {
      enable = true;
      settings = {
        # https://copyparty.eu/helptext.txt
        # above has all the options
        p = singleton cfg.port;
        rproxy = -1;
        # public URL to assume when creating links
        site = "https://${cfg.subdomain}.${flakeSettings.domains.primary}";

        # enable ftp server
        # future me: ftps server option is also available
        ftp = cfg.port - 1000;

        # use system time instead of UTC
        localtime = true;

        # change the boring loading spinner to something other than a tree emoji
        spinner = ",padding:0;border-radius:9em;border:.2em solid #444;border-top:.2em solid #fc0";

        theme = 2; # pm-monokai

        # to make the dirs accessible to members of copyparty group
        chmod-d = "775";
        chmod-f = "664";

        # hide some UI elements by default
        # ctrl F for "ui options" in the helptext to learn what these do
        ui-noacci = true;
        ui-nosrvi = true;
        ui-nocpla = true;
        ui-nolbar = true;
        ui-norepl = true;
        ui-noctxb = true;
      };
      openFilesLimit = 4096;
      accounts.${flakeSettings.username}.passwordFile =
        config.modules.common.sops.secrets.copyparty-password.path;
      volumes = {
        "/" = {
          path = "/srv/files";
          access.A = flakeSettings.username;
          flags.scan = 60;
          flags.fk = 4; # enable filekeys
          flags.chmod_d = "775";
          flags.chmod_f = "664";
        };
        "/public" = commonPerms // {
          path = "/srv/files/public";
        };
        "/books" = commonPerms // {
          path = "/srv/files/books";
        };
        "/manga" = commonPerms // {
          path = "/srv/files/manga";
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
