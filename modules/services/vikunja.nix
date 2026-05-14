{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib) mkIf singleton;
  cfg = config.modules.server.vikunja;
in
{
  options.modules.server.vikunja = lib.my.mkServerModule {
    name = "Vikunja";
    subdomain = "tasks";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.vikunja-env.path = "/var/secrets/vikunja-env";
    services.vikunja = {
      enable = true;
      inherit (cfg) port;
      address = "localhost";
      frontendScheme = "https";
      frontendHostname = "${cfg.subdomain}.${flakeSettings.domains.primary}";
      environmentFiles = singleton config.modules.common.sops.secrets.vikunja-env.path;
      settings.service = {
        motd = "ad astra per aspera";
        enableregistration = false;
        timezone = config.time.timeZone;
      };
    };
  };
}
