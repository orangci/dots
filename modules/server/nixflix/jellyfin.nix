{
  config,
  lib,
  flakeSettings,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  cfg = config.modules.server.nixflix;
  inherit (inputs.nixflix.lib.jellyfinPlugins) fromRepo;
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
      enable = true;
      apiKey._secret = config.modules.common.sops.secrets."nixflix/jellyfin/apiKey".path;
      branding.customCss = ''@import url("https://cdn.jsdelivr.net/gh/lscambo13/ElegantFin@main/Theme/ElegantFin-jellyfin-theme-build-latest-minified.css"); @import url("https://cdn.jsdelivr.net/gh/lscambo13/ElegantFin@main/Theme/assets/add-ons/media-bar-plugin-support-latest-min.css");'';
      system.uiCulture = "en-GB";

      encoding.hardwareAccelerationType =
        if config.drivers.intel.enable then
          "vaapi"
        else if config.drivers.intel.amdgpu.enable then
          "amf"
        else if config.drivers.nvidia.enable then
          "nvenc"
        else
          "none";

      network = {
        internalHttpPort = mkForce (cfg.port + 1);
        publicHttpPort = mkForce (cfg.port + 1);
      };

      users.${flakeSettings.username} = {
        password._secret = config.modules.common.sops.secrets."nixflix/jellyfin/admin-password".path;
        policy.isAdministrator = true;
      };

      system.pluginRepositories = {
        "Ani-Sync" = {
          url = "https://raw.githubusercontent.com/vosmiic/jellyfin-ani-sync/master/manifest.json";
          hash = "sha256-uGyZbX1HVl19eSCjb/TKr3Cblqi8EMy5rCvcbKGbwPs=";
        };
        "AnimeMultiSource" = {
          url = "https://raw.githubusercontent.com/webbster64/jellyfin-plugin-AnimeMultiSource/main/manifest.json";
          hash = "sha256-b/sWwmkAgj5ZR8C8jvk2QdrkjxKHWScSPmwGMIlpChc=";
        };
        "MediaBar" = {
          # also File Transformation
          url = "https://www.iamparadox.dev/jellyfin/plugins/manifest.json";
          hash = "sha256-4s6h+GbXF3UB5ES3gL+dGNisTPFGvViWvr/14d8E304=";
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
            hash = "sha256-2VUH1kn4v1VZ9jpHzOxzSVJJgGWVTn2vIOXBWelriyE=";
          };
        };
      };
    };
  };
}
