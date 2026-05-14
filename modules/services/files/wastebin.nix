{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.services.files.wastebin;
in
{
  options.modules.services.files.wastebin = lib.my.mkServerModule {
    name = "Wastebin";
    subdomain = "bin";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.wastebin-env.path = "/var/secrets/wastebin-env";
    services.wastebin = {
      enable = true;
      secretFile = config.modules.security.sops.secrets.wastebin-env.path;
      settings = {
        WASTEBIN_BASE_URL = "https://${flakeSettings.domains.primary}";
        WASTEBIN_ADDRESS_PORT = "0.0.0.0:${toString cfg.port}";
        WASTEBIN_THEME = "catppuccin";
        # WASTEBIN_PASTE_EXPIRATIONS = "";
      };
    };
  };
}
