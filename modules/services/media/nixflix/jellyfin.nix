{
  config,
  lib,
  flakeSettings,
  inputs,
  sysadmin,
  ...
}:
let
  inherit (lib) mkIf mkForce my;
  cfg = config.modules.services.media.nixflix;
  inherit (config.modules.hardware) drivers;
  inherit (inputs.nixflix.lib.jellyfinPlugins) fromRepo;
in
{
  config = mkIf cfg.enable {
    modules.services.infrastructure.cloudflared.ingress = my.mkCloudflaredIngress "jf" (cfg.port + 1);
    modules.services.infrastructure.caddy.virtualHosts = my.mkCaddyEntry "jf" (cfg.port + 1) true;
    modules.security.sops.secrets = {
      "nixflix/jellyfin/apiKey".path = "/var/secrets/nixflix-jellyfin-apiKey";
      "nixflix/jellyfin/admin-password".path = "/var/secrets/nixflix-jellyfin-admin-password";
    };

    modules.services.monitoring.glance.monitoredSites = lib.singleton {
      url = "https://jf.${flakeSettings.domains.tailnet}";
      title = "Jellyfin";
      icon = "sh:jellyfin";
    };

    nixflix.jellyfin = {
      enable = true;
      apiKey._secret = config.modules.security.sops.secrets."nixflix/jellyfin/apiKey".path;
      branding.customCss = ''@import url("https://cdn.jsdelivr.net/gh/lscambo13/ElegantFin@main/Theme/ElegantFin-jellyfin-theme-build-latest-minified.css"); @import url("https://cdn.jsdelivr.net/gh/lscambo13/ElegantFin@main/Theme/assets/add-ons/media-bar-plugin-support-latest-min.css");'';
      system.uiCulture = "en-GB";

      # amf is windows-only, jellyfin uses vaapi for amd gpus on linux
      encoding.hardwareAccelerationType =
        if drivers.nvidia.enable then
          "nvenc"
        else if drivers.intel.enable || drivers.amd.enable then
          "vaapi"
        else
          "none";

      network = {
        internalHttpPort = mkForce (cfg.port + 1);
        publicHttpPort = mkForce (cfg.port + 1);
      };

      users.${sysadmin.username} = {
        password._secret = config.modules.security.sops.secrets."nixflix/jellyfin/admin-password".path;
        policy.isAdministrator = true;
      };

      system.pluginRepositories = {
        "Ani-Sync" = {
          url = "https://raw.githubusercontent.com/vosmiic/jellyfin-ani-sync/master/manifest.json";
          hash = "sha256-1iksIdj18kAS1OYuP3IGHwtdmVYs7itzl65Dvmev47s=";
        };
        "AnimeMultiSource" = {
          url = "https://raw.githubusercontent.com/webbster64/jellyfin-plugin-AnimeMultiSource/main/manifest.json";
          hash = "sha256-RgFtOyGv61THaW6/bjpPxZV4Mh2YXi8Sp/csizs2lt4=";
        };
        "MediaBar" = {
          # also File Transformation
          url = "https://www.iamparadox.dev/jellyfin/plugins/manifest.json";
          hash = "sha256-93n3Ehh6hWts8ONd6Dp/GYZd0g1Wb2lbHz4Kn6fhrwg=";
        };
        "letterboxd-sync" = {
          url = "https://raw.githubusercontent.com/hrqmonteiro/jellyfin-plugin-letterboxd-sync/master/manifest.json";
          hash = "sha256-aRIaNDhJhKY6dbo1k1+CW9AcU6NOuQaLqf1rjYkuHTc=";
        };
      };

      plugins = {
        "Ani-Sync" = {
          package = fromRepo {
            version = "4.1.0.0";
            hash = "sha256-VFH4JFBcIV/aW8TtSUOiEexJUTBLcA05QqsgVTa9F/w=";
          };
        };
        "Anime Multi Source" = {
          package = fromRepo {
            version = "1.0.4.8";
            hash = "sha256-J6U0FOsQ/0CG+G/ScxsVC94H1xQ1psXjWm0dYo8r1FQ=";
          };
        };
        "File Transformation" = {
          package = fromRepo {
            version = "2.5.9.0";
            hash = "sha256-tc3lJ5IPASy/nR1QzubBQ2zoPKodd/DfloNsMpHDjas=";
          };
        };
        "LetterboxdSync" = {
          package = fromRepo {
            version = "1.3.0.0";
            hash = "sha256-2VUH1kn4v1VZ9jpHzOxzSVJJgGWVTn2vIOXBWelriyE=";
          };
        };
        "Media Bar" = {
          package = fromRepo {
            version = "2.4.10.0";
            hash = "sha256-HQD7SNlBLNKHMXLh+ruJmfCnkEPt58u+30T4bmN1Ee8=";
          };
        };
      };
    };
  };
}
