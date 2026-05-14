{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib) mkIf singleton;
  cfg = config.modules.services.productivity.vikunja;
in
{
  options.modules.services.productivity.vikunja = lib.my.mkServerModule {
    name = "Vikunja";
    subdomain = "tasks";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.vikunja-env.path = "/var/secrets/vikunja-env";
    services.vikunja = {
      enable = true;
      inherit (cfg) port;
      address = "localhost";
      frontendScheme = "https";
      frontendHostname = "${cfg.subdomain}.${flakeSettings.domains.primary}";
      environmentFiles = singleton config.modules.security.sops.secrets.vikunja-env.path;
      settings.service = {
        motd = "ad astra per aspera";
        enableregistration = false;
        timezone = config.time.timeZone;
      };
    };
  };
}
