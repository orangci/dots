{
  config,
  lib,
  host,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkIf
    mkMerge
    ;
  cfg = config.modules.server.glance;
  serverModules = config.modules.server;

  sites = builtins.attrValues (
    lib.filterAttrs (
      _name: mod:
      (mod ? enable && mod.enable)
      && lib.hasAttrByPath [ "glance" "enable" ] mod
      && mod.glance.enable
      && mod ? domain
      && mod.domain != null
    ) serverModules
  );

  dynamicMonitoredSites = builtins.map (mod: {
    title = mod.name or mod.domain;
    url = "https://${lib.removeSuffix flakeSettings.domains.primary mod.domain}${flakeSettings.domains.tailnet}";
    icon =
      mod.glance.icon
        or "sh:${lib.strings.replaceStrings [ " " ] [ "-" ] (lib.strings.toLower mod.name)}";
  }) sites;
in
{
  options.modules.server.glance = {
    enable = mkEnableOption "Enable glance";

    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Glance";
    };

    domain = mkOption {
      type = types.str;
      default = "glance.${flakeSettings.domains.primary}";
      description = "The domain for glance to be hosted at";
    };
    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for glance to be hosted at";
    };

    monitoredSites = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = "Collect services definitions from different modules";
    };
  };
  # maybe in the future https://github.com/glanceapp/community-widgets/blob/main/widgets/google-calendar-list-by-anant-j/README.md
  config = mkIf cfg.enable {
    modules.common.sops.secrets.technitium-api-token.path = "/var/secrets/technitium-api-token";
    modules.common.sops.secrets.immich-api-key.path = "/var/secrets/immich-api-key";
    modules.common.sops.secrets.hardcover-api-key.path = "/var/secrets/hardcover-api-key";
    modules.common.sops.secrets.speedtest-api-key.path = "/var/secrets/speedtest-api-key";
    environment.etc."glance-style.css".text = ''
      body {font-family: Lexend, "Jetbrains Mono", sans-serif, monospace;}
    '';
    services.glance = {
      enable = true;
      settings = {
        # https://github.com/glanceapp/glance/blob/main/docs/configuration.md
        server.port = cfg.port;
        server.proxied = true;
        branding = {
          app-background-color = "#191724";
          hide-footer = true;
        };
        theme = {
          custom-css-file = "/etc/glance-style.css";
          background-color = "249 22 12";
          primary-color = "2 55 83";
          positive-color = "197 49 38";
          negative-color = "343 76 68";
          contrast-multiplier = 1.2;
          presets.default-dark = {
            background-color = "249 22 12";
            primary-color = "2 55 83";
            positive-color = "197 49 38";
            negative-color = "343 76 68";
            contrast-multiplier = 1.2;
          };
          presets.default-light = {
            light = true;
            background-color = "0 0 95";
            primary-color = "0 0 10";
            negative-color = "0 90 50";
          };
        };
        pages = [
          {
            name = host;
            hide-desktop-navigation = true;
            show-mobile-header = false;
            head-widgets = [ ];
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "search";
                    search-engine = "https://${config.modules.server.searxng.domain}/search?q={QUERY}";
                  }
                  (mkIf config.modules.server.technitium.enable {
                    type = "dns-stats";
                    url = "http://localhost:5380";
                    hour-format = "24h";
                    hide-graph = false;
                    hide-top-domains = false;
                    allow-insecure = true;
                    service = "technitium";
                    token = {
                      _secret = config.modules.common.sops.secrets.technitium-api-token.path;
                    };
                  })
                  {
                    type = "clock";
                    hour-format = "24h";
                    title-url = "https://time.is/Riyadh";
                    timezones = [
                      # https://timeapi.io/documentation/iana-timezones
                      {
                        timezone = "UTC";
                        label = "UTC";
                      }
                      {
                        timezone = "Canada/Eastern";
                        label = "Ottawa";
                      }
                      {
                        timezone = "Asia/Dhaka";
                        label = "Dhaka";
                      }
                      {
                        timezone = "Europe/Bucharest";
                        label = "Romania";
                      }
                      {
                        timezone = "Africa/Cairo";
                        label = "Egypt";
                      }
                      {
                        timezone = "Asia/Kolkata";
                        label = "India";
                      }
                    ];
                  }
                  {
                    type = "custom-api";
                    title = "xkcd";
                    cache = "2m";
                    url = "https://xkcd.com/info.0.json";
                    template = ''
                      <body> {{ .JSON.String "title" }}</body>
                      <img src="{{ .JSON.String "img" }}"></img>
                    '';
                  }
                ];
              }
              {
                size = "full";
                widgets = [
                  {
                    type = "server-stats";
                    servers = [
                      {
                        type = "local";
                        name = host;
                      }
                    ];
                  }
                  {
                    type = "custom-api";
                    title = "Random Qur'an Verse";
                    cache = "1h";
                    url = "https://api.alquran.cloud/v1/ayah/random/editions/quran-uthmani,en.hilali";
                    template = ''
                      <p class="size-h2 color-highlight">
                        Ayah {{ .JSON.Int "data.0.numberInSurah" }} of Surah {{ .JSON.String "data.0.surah.englishName" }} ({{ .JSON.String "data.0.surah.englishNameTranslation" }})
                      </p>
                      <p class="size-h4 color-paragraph">{{ .JSON.String "data.0.text" }}</p>
                      <p class="size-h5 color-paragraph">{{ .JSON.String "data.1.text" }}</p>
                    '';
                  }
                  {
                    type = "monitor";
                    title = "Services";
                    cache = "1m";
                    show-failing-only = false;
                    sites = mkMerge [
                      dynamicMonitoredSites
                      cfg.monitoredSites
                    ];
                  }
                ];
              }
              {
                size = "small";
                widgets = [
                  {
                    type = "weather";
                    location = "Riyadh, Saudi Arabia";
                    units = "metric";
                    hour-format = "24h";
                  }
                  {
                    type = "custom-api";
                    title = "Prayer Times";
                    title-url = "https://aladhan.com/prayer-times-api";
                    cache = "1h";
                    url = "https://api.aladhan.com/v1/timingsByCity?city=Riyadh&country=Saudi+Arabia&method=4";
                    headers = {
                      Accept = "application/json";
                    };
                    template = ''
                      <div class="text-center mb-2">
                        <div class="size-h6 color-highlight">{{ .JSON.String "data.date.hijri.date" }} ({{ .JSON.String "data.date.hijri.month.en" }})</div>
                      </div>
                      <div class="flex justify-between text-center">
                        <div>
                          <div class="color-highlight size-h4">{{ .JSON.String "data.timings.Fajr" }}</div>
                          <div class="size-h6">FAJR</div>
                        </div>
                        <div>
                          <div class="color-highlight size-h4">{{ .JSON.String "data.timings.Dhuhr" }}</div>
                          <div class="size-h6">DHUHR</div>
                        </div>
                        <div>
                          <div class="color-highlight size-h4">{{ .JSON.String "data.timings.Asr" }}</div>
                          <div class="size-h6">ASR</div>
                        </div>
                        <div>
                          <div class="color-highlight size-h4">{{ .JSON.String "data.timings.Maghrib" }}</div>
                          <div class="size-h6">MAGHRIB</div>
                        </div>
                        <div>
                          <div class="color-highlight size-h4">{{ .JSON.String "data.timings.Isha" }}</div>
                          <div class="size-h6">ISHA</div>
                        </div>
                      </div>
                    '';
                  }
                  {
                    type = "custom-api";
                    title = "Fact";
                    cache = "15m";
                    url = "https://uselessfacts.jsph.pl/api/v2/facts/random";
                    template = ''<p class="size-h4 color-paragraph">{{ .JSON.String "text" }}</p>'';
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
