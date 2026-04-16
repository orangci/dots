{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.server.cloudflared.ingress."jf.${flakeSettings.domains.primary}" =
      "http://localhost:${toString (cfg.port + 1)}";
    modules.server.caddy.virtualHosts = {
      "jf.${flakeSettings.domains.primary}".extraConfig =
        "reverse_proxy localhost:${toString (cfg.port + 1)}";
      "https://jf.${flakeSettings.domains.tailnet}".extraConfig = ''
        bind tailscale/jf
        reverse_proxy localhost:${toString (cfg.port + 1)}
      '';
    };

    modules.common.sops.secrets = {
      "nixflix/jellyfin/apiKey".path = "/var/secrets/nixflix-jellyfin-apiKey";
      "nixflix/jellyfin/admin-password".path = "/var/secrets/nixflix-jellyfin-admin-password";
    };

    modules.server.glance.monitoredSites = lib.singleton {
      url = "https://jf.${flakeSettings.domains.tailnet}";
      title = "Jellyfin";
      icon = "sh:jellyfin";
    };

    nixflix.jellyfin = {
      # TODO: plugins ani-sync, animemultisource, in player episode list, powertoys, mediabar, discontinue watching, letterboxd
      enable = true;
      apiKey._secret = config.modules.common.sops.secrets."nixflix/jellyfin/apiKey".path;

      branding.customCss = ''@import url("https://cdn.jsdelivr.net/gh/lscambo13/ElegantFin@main/Theme/ElegantFin-jellyfin-theme-build-latest-minified.css"); @import url("https://cdn.jsdelivr.net/gh/lscambo13/ElegantFin@main/Theme/assets/add-ons/media-bar-plugin-support-latest-min.css");'';

      network = {
        internalHttpPort = mkForce (cfg.port + 1);
        publicHttpPort = mkForce (cfg.port + 1);
      };

      users.${flakeSettings.username} = {
        password._secret = config.modules.common.sops.secrets."nixflix/jellyfin/admin-password".path;
        policy.isAdministrator = true;
      };

      system.uiCulture = "en-GB";
    };
  };
}
