{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf singleton;
  cfg = config.modules.server.radicale;
in
{
  options.modules.server.radicale = lib.my.mkServerModule {
    name = "Radicale";
    subdomain = "cal";
  };

  config = mkIf cfg.enable {
    services.radicale = {
      enable = true;
      settings = {
        server.hosts = singleton "0.0.0.0:${toString cfg.port}";
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/etc/radicale/users";
          htpasswd_encryption = "bcrypt";
        };
      };
    };
  };
}
