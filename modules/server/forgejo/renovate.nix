{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption singleton;
  cfg = config.modules.server.forgejo;
in
{
  options.modules.server.forgejo.renovate.enable = mkEnableOption "Renovate bot";
  config = mkIf cfg.renovate.enable {
    # https://docs.renovatebot.com/configuration-options/
    modules.common.sops.secrets.renovate-token.path = "/var/secrets/renovate-token";
    services.renovate = {
      enable = true;
      settings = {
        endpoint = "https://${cfg.subdomain}.${flakeSettings.domains.tailnet}";
        gitAuthor = "renovate <renovate@${flakeSettings.domains.primary}>";
        platform = "forgejo";
        autodiscover = true;
        timezone = config.time.timeZone;
        groupName = "all dependencies";
        groupSlug = "all";
        packageRules = singleton {
          groupName = "all dependencies";
          groupSlug = "all";
          matchPackageNames = singleton "*";
        };
        separateMajorMinor = true;
      };
      credentials.RENOVATE_TOKEN = config.modules.common.sops.secrets.renovate-token.path;
    };
  };
}
