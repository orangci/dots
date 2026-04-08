{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.common.sops.secrets = {
      "nixflix/jellyfin/apiKey".path = "/var/secrets/nixflix-jellyfin-apiKey";
      "nixflix/jellyfin/admin-password".path = "nixflix-jellyfin-admin-password";
    };
    nixflix.jellyfin = {
      # TODO: plugins ani-sync, animemultisource, in player episode list, powertoys, mediabar, discontinue watching, letterboxd
      enable = true;
      apiKey._secret = config.modules.common.sops.secrets."nixflix/jellyfin/apiKey".path;

      branding.customCss = ''@import url("https://cdn.jsdelivr.net/gh/lscambo13/ElegantFin@main/Theme/ElegantFin-jellyfin-theme-build-latest-minified.css"); @import url("https://cdn.jsdelivr.net/gh/lscambo13/ElegantFin@main/Theme/assets/add-ons/media-bar-plugin-support-latest-min.css");'';

      network = {
        internalHttpPort = 0;
        publicHttpPort = 0;
      };

      users.admin = {
        password._secret = config.modules.common.sops.secrets."nixflix/jellyfin/admin-password".path;
        policy.isAdministrator = true;
      };
    };
  };
}
