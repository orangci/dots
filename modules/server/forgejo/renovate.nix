{
  config,
  lib,
  flakeSettings,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    singleton
    getExe
    ;
  cfg = config.modules.server.forgejo;
in
{
  options.modules.server.forgejo.renovate.enable = mkEnableOption "Renovate bot";
  config = mkIf cfg.renovate.enable {
    # https://docs.renovatebot.com/configuration-options/
    modules.common.sops.secrets = {
      "renovate/forgejo-token".path = "/var/secrets/renovate-forgejo-token";
      "renovate/github-token".path = "/var/secrets/renovate-github-token";
    };
    services.renovate = {
      enable = true;
      schedule = "*:0"; # run every hour
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
        separateMajorMinor = false;
      };
      runtimePackages = with pkgs; [ uv ];
      credentials = {
        RENOVATE_TOKEN = config.modules.common.sops.secrets."renovate/forgejo-token".path;
        RENOVATE_GITHUB_COM_TOKEN = config.modules.common.sops.secrets."renovate/github-token".path;
      };
    };
  };
}
