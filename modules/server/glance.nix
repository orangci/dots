{
  config,
  lib,
  host,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkIf
    filterAttrs
    ;
  cfg = config.modules.server.glance;
  serverModules = config.modules.server;

  sites = builtins.attrValues (
    filterAttrs (_name: mod: mod ? enable && mod.enable == true && mod ? domain) serverModules
  );

  siteList = builtins.map (mod: {
    title = mod.name or mod.domain;
    url = "https://${mod.domain}";
  }) sites;
in
{
  options.modules.server.glance = {
    enable = mkEnableOption "Enable glance";

    name = mkOption {
      type = types.str;
      default = "Glance";
    };

    domain = mkOption {
      type = types.str;
      default = "glance.orangc.net";
      description = "The domain for glance to be hosted at";
    };
    port = mkOption {
      type = types.port;
      description = "The port for glance to be hosted at";
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
                    search-engine = "https://search.orangc.net/search?q={QUERY}";
                  }
                  (mkIf config.modules.server.technitium.enable {
                    type = "dns-stats";
                    url = "http://localhost:5380";
                    hour-format = "24h";
                    hide-graph = false;
                    hide-top-domains = false;
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
                    ];
                  }
                  {
                    type = "custom-api";
                    height = "200px";
                    title = "Fox";
                    cache = "2m";
                    url = "https://randomfox.ca/floof/?ref=public_apis&utm_medium=website";
                    template = ''<img src="{{ .JSON.String "image" }}"></img>'';
                  }
                ];
              }
              {
                size = "full";
                widgets = [
                  { type = "to-do"; }
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
                    type = "custom-api";
                    title = "Hardcover";
                    title-url = "https://hardcover.app/@ci";
                    cache = "30m";
                    url = "https://api.hardcover.app/v1/graphql";
                    headers = {
                      content-type = "application/json";
                      authorization = {
                        _secret = config.modules.common.sops.secrets.hardcover-api-key.path;
                      };
                    };
                    body = {
                      query = ''
                        query MyQuery {
                          me {
                            user_books(where: {status_id: {_eq: 2}}, order_by: {first_read_date: desc}) {
                              id
                              user_book_reads(
                                limit: 1,
                                order_by: {started_at: desc_nulls_last}
                              ) {
                                id
                                started_at
                                progress
                                edition {
                                  image {
                                    url
                                  }
                                  cached_contributors
                                }
                              }
                              book {
                                title
                                slug
                              }
                            }
                          }
                        }
                      '';
                    };
                    template = ''
                      <ul class="list list-gap-10 collapsible-container" data-collapse-after="5">
                        {{ range .JSON.Array "data.me.0.user_books" }}
                          <li class="flex items-center gap-10">
                            <div style="border-radius: 5px; max-height: 10rem; max-width: 6rem; overflow: hidden;">
                              <img src="{{ .String "user_book_reads.0.edition.image.url" }}" class="card" style="width: 100%; height: 100%; object-fit: cover; object-position: center;">
                            </div>
                            <div class="flex-1">
                              <a class="size-h4 color-highlight" href="https://hardcover.app/books/{{ .String "book.slug" }}">{{ .String "book.title" }}</a>
                              <ul class="list-horizontal-text size-h5">
                                {{ range .Array "user_book_reads.0.edition.cached_contributors" }}
                                  {{ if not (.String "contribution") }}
                                    <li>{{ .String "author.name" }}</li>
                                  {{ end }}
                                {{ end }}
                              </ul>
                              <ul class="list-horizontal-text" >
                                <li>{{ .String "user_book_reads.0.started_at" }}</li>
                                <li>{{ .Int "user_book_reads.0.progress" }}%</li>
                              </ul>
                            </div>
                          </li>
                        {{ end }}
                      </ul>
                    '';
                  }
                  {
                    type = "monitor";
                    title = "Services";
                    cache = "1m";
                    show-failing-only = false;
                    sites = siteList;
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
                  (mkIf config.modules.server.speedtest.enable {
                    type = "custom-api";
                    cache = "1h";
                    title = "Internet Speedtest";
                    title-url = "https://${config.modules.server.speedtest.domain}";
                    headers = {
                      Authorization = {
                        _secret = config.modules.common.sops.secrets.speedtest-api-key.path;
                      };
                      Accept = "application/json";
                    };
                    subrequests.stats = {
                      url = "https://${config.modules.server.speedtest.domain}/api/v1/stats";
                      headers = {
                        Authorization = {
                          _secret = config.modules.common.sops.secrets.speedtest-api-key.path;
                        };
                        Accept = "application/json";
                      };
                    };
                    options.showPercentageDiff = true;
                    template = ''
                      {{ $showPercentage := .Options.BoolOr "showPercentageDiff" true }}
                      {{ $stats := .Subrequest "stats" }}
                      <div class="flex justify-between text-center margin-block-3">
                      <div>
                          {{ $downloadChange := percentChange ($stats.JSON.Float "data.download.avg_bits") (.JSON.Float "data.download_bits")
                          }}
                          {{ if $showPercentage }}
                          <div
                          class="size-small {{ if gt $downloadChange 0.0 }}color-positive{{ else if lt $downloadChange 0.0 }}color-negative{{ else }}color-primary{{ end }}"
                          style="display: inline-flex; align-items: center;">
                          {{ $downloadChange | printf "%+.1f%%" }}
                          {{ if gt $downloadChange 0.0 }}
                          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor"
                              style="height: 1em; margin-left: 0.25em;" class="size-4">
                              <path fill-rule="evenodd"
                              d="M9.808 4.057a.75.75 0 0 1 .92-.527l3.116.849a.75.75 0 0 1 .528.915l-.823 3.121a.75.75 0 0 1-1.45-.382l.337-1.281a23.484 23.484 0 0 0-3.609 3.056.75.75 0 0 1-1.07.01L6 8.06l-3.72 3.72a.75.75 0 1 1-1.06-1.061l4.25-4.25a.75.75 0 0 1 1.06 0l1.756 1.755a25.015 25.015 0 0 1 3.508-2.85l-1.46-.398a.75.75 0 0 1-.526-.92Z"
                              clip-rule="evenodd" />
                          </svg>
                          {{ else if lt $downloadChange 0.0 }}
                          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor"
                              style="height: 1em; margin-left: 0.25em;" class="size-4">
                              <path fill-rule="evenodd"
                              d="M1.22 4.22a.75.75 0 0 1 1.06 0L6 7.94l2.761-2.762a.75.75 0 0 1 1.158.12 24.9 24.9 0 0 1 2.718 5.556l.729-1.261a.75.75 0 0 1 1.299.75l-1.591 2.755a.75.75 0 0 1-1.025.275l-2.756-1.591a.75.75 0 1 1 .75-1.3l1.097.634a23.417 23.417 0 0 0-1.984-4.211L6.53 9.53a.75.75 0 0 1-1.06 0L1.22 5.28a.75.75 0 0 1 0-1.06Z"
                              clip-rule="evenodd" />
                          </svg>
                          {{ end }}
                          </div>
                          {{ end }}
                          <div class="color-highlight size-h3">{{ .JSON.Float "data.download_bits" | mul 0.000001 | printf "%.1f" }}</div>
                          <div class="size-h6">DOWNLOAD</div>
                      </div>
                      <div>
                          {{ $uploadChange := percentChange ($stats.JSON.Float "data.upload.avg_bits") (.JSON.Float "data.upload_bits") }}
                          {{ if $showPercentage }}
                          <div
                          class="size-small {{ if gt $uploadChange 0.0 }}color-positive{{ else if lt $uploadChange 0.0 }}color-negative{{ else }}color-primary{{ end }}"
                          style="display: inline-flex; align-items: center;">
                          {{ $uploadChange | printf "%+.1f%%" }}
                          {{ if gt $uploadChange 0.0 }}
                          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor"
                              style="height: 1em; margin-left: 0.25em;" class="size-4">
                              <path fill-rule="evenodd"
                              d="M9.808 4.057a.75.75 0 0 1 .92-.527l3.116.849a.75.75 0 0 1 .528.915l-.823 3.121a.75.75 0 0 1-1.45-.382l.337-1.281a23.484 23.484 0 0 0-3.609 3.056.75.75 0 0 1-1.07.01L6 8.06l-3.72 3.72a.75.75 0 1 1-1.06-1.061l4.25-4.25a.75.75 0 0 1 1.06 0l1.756 1.755a25.015 25.015 0 0 1 3.508-2.85l-1.46-.398a.75.75 0 0 1-.526-.92Z"
                              clip-rule="evenodd" />
                          </svg>
                          {{ else if lt $uploadChange 0.0 }}
                          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor"
                              style="height: 1em; margin-left: 0.25em;" class="size-4">
                              <path fill-rule="evenodd"
                              d="M1.22 4.22a.75.75 0 0 1 1.06 0L6 7.94l2.761-2.762a.75.75 0 0 1 1.158.12 24.9 24.9 0 0 1 2.718 5.556l.729-1.261a.75.75 0 0 1 1.299.75l-1.591 2.755a.75.75 0 0 1-1.025.275l-2.756-1.591a.75.75 0 1 1 .75-1.3l1.097.634a23.417 23.417 0 0 0-1.984-4.211L6.53 9.53a.75.75 0 0 1-1.06 0L1.22 5.28a.75.75 0 0 1 0-1.06Z"
                              clip-rule="evenodd" />
                          </svg>
                          {{ end }}
                          </div>
                          {{ end }}
                          <div class="color-highlight size-h3">{{ .JSON.Float "data.upload_bits" | mul 0.000001 | printf "%.1f" }}</div>
                          <div class="size-h6">UPLOAD</div>
                      </div>
                      <div>
                          {{ $pingChange := percentChange ($stats.JSON.Float "data.ping.avg") (.JSON.Float "data.ping") }}
                          {{ if $showPercentage }}
                          <div
                          class="size-small {{ if gt $pingChange 0.0 }}color-negative{{ else if lt $pingChange 0.0 }}color-positive{{ else }}color-primary{{ end }}"
                          style="display: inline-flex; align-items: center;">
                          {{ $pingChange | printf "%+.1f%%" }}
                          {{ if lt $pingChange 0.0 }}
                          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor"
                              style="height: 1em; margin-left: 0.25em;" class="size-4">
                              <path fill-rule="evenodd"
                              d="M1.22 4.22a.75.75 0 0 1 1.06 0L6 7.94l2.761-2.762a.75.75 0 0 1 1.158.12 24.9 24.9 0 0 1 2.718 5.556l.729-1.261a.75.75 0 0 1 1.299.75l-1.591 2.755a.75.75 0 0 1-1.025.275l-2.756-1.591a.75.75 0 1 1 .75-1.3l1.097.634a23.417 23.417 0 0 0-1.984-4.211L6.53 9.53a.75.75 0 0 1-1.06 0L1.22 5.28a.75.75 0 0 1 0-1.06Z"
                              clip-rule="evenodd" />
                          </svg>
                          {{ else if gt $pingChange 0.0 }}
                          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor"
                              style="height: 1em; margin-left: 0.25em;" class="size-4">
                              <path fill-rule="evenodd"
                              d="M9.808 4.057a.75.75 0 0 1 .92-.527l3.116.849a.75.75 0 0 1 .528.915l-.823 3.121a.75.75 0 0 1-1.45-.382l.337-1.281a23.484 23.484 0 0 0-3.609 3.056.75.75 0 0 1-1.07.01L6 8.06l-3.72 3.72a.75.75 0 1 1-1.06-1.061l4.25-4.25a.75.75 0 0 1 1.06 0l1.756 1.755a25.015 25.015 0 0 1 3.508-2.85l-1.46-.398a.75.75 0 0 1-.526-.92Z"
                              clip-rule="evenodd" />
                          </svg>
                          {{ end }}
                          </div>
                          {{ end }}
                          <div class="color-highlight size-h3">{{ .JSON.Float "data.ping" | printf "%.0f ms" }}</div>
                          <div class="size-h6">PING</div>
                      </div>
                      </div>
                    '';
                  })
                  {
                    type = "custom-api";
                    title = "Juniper";
                    url = "https://api.mcstatus.io/v2/status/java/mc.orangc.net";
                    template = ''
                      <div style="display:flex; align-items:center; gap:12px;">
                        <div style="width:40px; height:40px; flex-shrink:0;  border-radius:4px; display:flex; justify-content:center; align-items:center; overflow:hidden;">
                          {{ if .JSON.Bool "online" }}
                            <img src="{{ .JSON.String "icon" | safeURL }}" width="64" height="64" style="object-fit:contain;">
                          {{ else }}
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" style="width:32px; height:32px; opacity:0.5;">
                              <path fill-rule="evenodd" d="M1 5.25A2.25 2.25 0 0 1 3.25 3h13.5A2.25 2.25 0 0 1 19 5.25v9.5A2.25 2.25 0 0 1 16.75 17H3.25A2.25 2.25 0 0 1 1 14.75v-9.5Zm1.5 5.81v3.69c0 .414.336.75.75.75h13.5a.75.75 0 0 0 .75-.75v-2.69l-2.22-2.219a.75.75 0 0 0-1.06 0l-1.91 1.909.47.47a.75.75 0 1 1-1.06 1.06L6.53 8.091a.75.75 0 0 0-1.06 0l-2.97 2.97ZM12 7a1 1 0 1 1-2 0 1 1 0 0 1 2 0Z" clip-rule="evenodd" />
                            </svg>
                          {{ end }}
                        </div>

                        <div style="flex-grow:1; min-width:0;">
                          <a class="size-h4 block text-truncate color-highlight">
                            {{ .JSON.String "host" }}
                            {{ if .JSON.Bool "online" }}
                            <span
                              style="width: 8px; height: 8px; border-radius: 50%; background-color: var(--color-positive); display: inline-block; vertical-align: middle;"
                              data-popover-type="text"
                              data-popover-text="Online"
                            ></span>
                            {{ else }}
                            <span
                              style="width: 8px; height: 8px; border-radius: 50%; background-color: var(--color-negative); display: inline-block; vertical-align: middle;"
                              data-popover-type="text"
                              data-popover-text="Offline"
                            ></span>
                            {{ end }}
                          </a>

                          <ul class="list-horizontal-text">
                            <li>
                              {{ if .JSON.Bool "online" }}
                              <span>{{ .JSON.String "version.name_clean" }}</span>
                              {{ else }}
                              <span>Offline</span>
                              {{ end }}
                            </li>
                            {{ if .JSON.Bool "online" }}
                            <li data-popover-type="html">
                              <div data-popover-html>
                                {{ range .JSON.Array "players.list" }}{{ .String "name_clean" }}<br>{{ end }}
                              </div>
                              <p style="display:inline-flex;align-items:center;">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6" style="height:1em;vertical-align:middle;margin-right:0.5em;">
                                  <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
                                </svg>
                                {{ .JSON.Int "players.online" | formatNumber }}/{{ .JSON.Int "players.max" | formatNumber }} players
                              </p>
                            </li>
                            {{ else }}
                            <li>
                              <p style="display:inline-flex;align-items:center;">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6" style="height:1em;vertical-align:middle;margin-right:0.5em;opacity:0.5;">
                                  <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
                                </svg>
                                0 players
                              </p>
                            </li>
                            {{ end }}
                          </ul>
                        </div>
                      </div>
                    '';
                  }
                  (mkIf config.modules.server.immich.enable {
                    type = "custom-api";
                    title = "Immich stats";
                    title-url = "https://${config.modules.server.immich.domain}";
                    cache = "12h";
                    url = "https://${config.modules.server.immich.domain}/api/server/statistics";
                    headers = {
                      x-api-key = {
                        _secret = config.modules.common.sops.secrets.immich-api-key.path;
                      };
                      Accept = "application/json";
                    };
                    template = ''
                      <div class="flex justify-between text-center">
                        <div>
                            <div class="color-highlight size-h3">{{ .JSON.Int "photos" | formatNumber }}</div>
                            <div class="size-h6">PHOTOS</div>
                        </div>
                        <div>
                            <div class="color-highlight size-h3">{{ .JSON.Int "videos" | formatNumber }}</div>
                            <div class="size-h6">VIDEOS</div>
                        </div>
                        <div>
                            <div class="color-highlight size-h3">{{ div (.JSON.Int "usage" | toFloat) 1073741824 | toInt | formatNumber }}GB</div>
                            <div class="size-h6">USAGE</div>
                        </div>
                      </div>
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
