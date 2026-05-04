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
      && mod ? subdomain
      && mod.subdomain != null
    ) serverModules
  );

  dynamicMonitoredSites = builtins.map (mod: {
    title = mod.name or mod.subdomain;
    url = "https://${mod.subdomain}.${flakeSettings.domains.tailnet}";
    inherit (mod.glance) icon;
  }) sites;
in
{
  options.modules.server.glance =
    lib.my.mkServerModule {
      name = "Glance";
    }
    // {
      monitoredSites = mkOption {
        type = types.listOf types.attrs;
        default = [ ];
        description = "Collect services definitions from different modules";
      };
    };
  # maybe in the future https://github.com/glanceapp/community-widgets/blob/main/widgets/google-calendar-list-by-anant-j/README.md
  config = mkIf cfg.enable {
    modules.common.sops.secrets = {
      technitium-api-token.path = "/var/secrets/technitium-api-token";
      immich-api-key.path = "/var/secrets/immich-api-key";
      speedtest-api-key.path = "/var/secrets/speedtest-api-key";
    };
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
                    search-engine = "https://${config.modules.server.searxng.subdomain}.${flakeSettings.domains.tailnet}/search?q={QUERY}";
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
                  (mkIf config.modules.server.scrutiny.enable {
                    type = "custom-api";
                    title = "Drive Health";
                    title-url = "https://${config.modules.server.scrutiny.subdomain}.${flakeSettings.domains.tailnet}";
                    url = "https://${config.modules.server.scrutiny.subdomain}.${flakeSettings.domains.tailnet}/api/summary";
                    cache = "1h";
                    method = "GET";
                    options = {
                      filter_archived = true;
                      sort_by = "device.device_name";
                      sort_order = "desc";
                    };
                    template = ''
                      {{- $filterArchived := .Options.filter_archived }}
                      {{- $sortBy := .Options.sort_by }}
                      {{- $sortOrder := .Options.sort_order }}
                      {{- /* Convert summary map into array so we can sort */}}
                      {{- $drives := .JSON.Array "data.summary|@values" }}
                      {{- /* Sort drives by given string field */}}
                      {{- $sorted := $drives }}
                      {{- if or (eq $sortBy "device.capacity") (eq $sortBy "smart.power_on_hours") }}
                        {{- $sorted = sortByInt $sortBy $sortOrder $drives }}
                      {{- else }}
                        {{- $sorted = sortByString $sortBy $sortOrder $drives }}
                      {{- end }}
                      {{- $total := 0 }}
                      {{- range $sorted }}
                        {{- $archived := .Get "device.archived" }}
                        {{- $archivedBool := false }}
                        {{- if $archived }}
                          {{- $archivedBool = eq $archived.Raw "true" }}
                        {{- end }}
                        {{- if and $filterArchived $archivedBool }}{{- continue }}{{- end }}
                        {{- $total = add $total 1 }}
                      {{- end }}
                      {{- /* Output each drive */}}
                      {{- $count := 0 }}
                      {{- range $sorted }}
                        {{- $archived := .Get "device.archived" }}
                        {{- $archivedBool := false }}
                        {{- if $archived }}
                          {{- $archivedBool = eq $archived.Raw "true" }}  {{/* compare raw JSON to string "true" */}}
                        {{- end }}
                        {{- /* Skip archived drives if filter is on */}}
                        {{- if and $filterArchived $archivedBool }}{{- continue }}{{- end }}
                        {{- $count = add $count 1 }}
                        {{- $device := .Get "device" }}
                        {{- $deviceName := $device.String "device_name" }} 
                        {{- $model := $device.String "model_name" }}
                        {{- $wwn := $device.String "wwn" }}
                        {{- $days := printf "%.0f" (div (.Get "smart.power_on_hours").Num 24) }}
                        {{- $capacity_print := printf "%.0f" (div (.Get "device.capacity").Num 1000000000000) }}
                        {{- $status := (.Get "device.device_status").Num }}
                        {{- $tempHistory := .Array "temp_history" }}
                        {{- $latestTemp := index (.Array "temp_history") (sub (len (.Array "temp_history")) 1) }}
                        {{- $latestTempValue := $latestTemp.Int "temp" }}
                        <div style="margin-top: 1rem; display: flex; justify-content: space-between; align-items: center;">
                          <a href="http://${config.modules.server.scrutiny.subdomain}.${flakeSettings.domains.tailnet}/web/device/{{ $wwn }}" target="_blank">
                            <div>
                              <strong class="color-highlight" style="text-transform: uppercase; font-size: 1.5rem;">
                                /DEV/{{ $deviceName }} · {{ $capacity_print }}TB · {{ $latestTempValue }}°C
                              </strong><br>
                              <p class="color-highlight" style="margin: 0;">{{ $model }}</p>
                              <div class="color-primary" style="font-size: 1.2rem;">Powered on for {{ $days }} days</div>
                            </div>
                          </a>
                          <div style="display: flex; align-items: center; gap: 6px;">
                            {{- if eq $status 0.0 }}
                              <span title="Passed Health Checks" style="font-size: 18px;cursor: default;" class="color-positive">●</span>
                            {{- else }}
                              <span title="Failed Health Checks" style="font-size: 18px;cursor:default;" class="color-negative">●</span>
                            {{- end }}
                          </div>
                        </div>
                        {{- if lt $count $total }}
                          <hr class="color-secondary" style="margin: 1rem 0; border: none; border-bottom: 1px solid currentColor;" />
                        {{- end }}
                      {{- end }}
                    '';
                  })
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
