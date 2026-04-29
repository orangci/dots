{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
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
        gitAuthor = "Renovate <renovate@${flakeSettings.domains.primary}>";
        platform = "forgejo";
        autodiscover = true;
        timezone = config.time.timeZone;
      };
      credentials.RENOVATE_TOKEN = config.modules.common.sops.secrets.renovate-token.path;
    };
  };
}
