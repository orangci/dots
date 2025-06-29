{
  config,
  lib,
  system,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.pelican;
in
{
  imports = [
    inputs.pelican.nixosModules.wings
    inputs.pelican.nixosModules.panel
  ];
  options.modules.server.pelican = {
    enable = mkEnableOption "Enable pelican";

    name = mkOption {
      type = types.str;
      default = "Pelican Panel";
    };

    port = mkOption {
      type = types.int;
      default = 8818;
      description = "The port for pelican to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "pelican.orangc.net";
      description = "The domain for pelican to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.pterodactyl = {
      enable = true;
      appName = cfg.name;
      panel = "pelican-dev";
      database.mysql = {
        createLocally = true;
        options = {
          port = cfg.port - 1000;
          host = "127.0.0.1";
          username = "pterodactyl";
          password = "very_funky_password_fumofumo";
          database = "panel";
          strict = false;
        };
      };
      database.redis = {
        createLocally = true;
        options = {
          username = "pterodactyl";
          database = "panel";
          host = "127.0.0.1";
          port = cfg.port - 2000;
          password = "very_funky_password_fumofumo";
        };
      };
    };
    services.wings = {
      enable = true;
      package = inputs.pelican.packages.${system}.pelican-wings;
    };
  };
}
