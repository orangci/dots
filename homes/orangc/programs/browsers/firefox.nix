{
  pkgs,
  config,
  lib,
  username,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.browsers.firefox;
in
{
  options.hmModules.programs.browsers.firefox = {
    enable = mkEnableOption "Enable firefox";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bindd = [ "SUPER, W, Launch Firefox, exec, firefox" ];
    programs.firefox = {
      enable = true;
      profiles.${username} = {
        extensions.force = true;
        id = 0;
        isDefault = true;
        search = {
          default = "SearXNG";
          force = true;
          engines = {
            google.metaData.alias = "@g";
            wikipedia.metaData.alias = "@wiki";
            bing.metaData.hidden = true;
            duckduckgo.metaData.hidden = true;

            "SearXNG" = {
              urls = [ { template = "https://search.orangc.net/search?q={searchTerms}"; } ];
              definedAliases = [ "@sx" ];
            };

            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages?type=packages&channel=unstable&query={searchTerms}";
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "NixOS Wiki" = {
              urls = [
                { template = "https://wiki.nixos.org/index.php?search={searchTerms}&title=Special%3ASearch"; }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };

            "Home-manager Options" = {
              definedAliases = [ "@hm" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [
                { template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }
              ];
            };

            "Nix Options" = {
              definedAliases = [ "@no" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
            };

            "Urban Dictionary" = {
              definedAliases = [ "@urban" ];
              urls = [ { template = "https://www.urbandictionary.com/define.php?term={searchTerms}"; } ];
            };

            "Youtube" = {
              definedAliases = [ "@yt" ];
              urls = [ { template = "https://youtube.com/search?q={searchTerms}"; } ];
              iconMapObj."16" = "https://www.youtube.com/s/desktop/606e092f/img/logos/favicon.ico";
            };

            "MyAnimeList" = {
              definedAliases = [
                "@mal"
                "@ani"
              ];
              urls = [
                {
                  template = "https://myanimelist.net/anime.php?cat=anime";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://cdn.myanimelist.net/images/favicon.ico";
            };

            "MyAnimeList Manga" = {
              definedAliases = [ "@manga" ];
              urls = [
                {
                  template = "https://myanimelist.net/manga.php";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://cdn.myanimelist.net/images/favicon.ico";
            };

            "Code Search" = {
              definedAliases = [ "@gh" ];
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "type";
                      value = "code";
                    }
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
          };
        };
        # end of search engines section
        settings = {
          "browser.uiCustomization.state" =
            ''{"placements":{"widget-overflow-fixed-list":["firefox-view-button","alltabs-button","fxa-toolbar-menu-button","history-panelmenu","library-button","bookmarks-menu-button","sync-button","panic-button","preferences-button","developer-button","screenshot-button","logins-button","sidebar-button","print-button","save-page-button","characterencoding-button"],"unified-extensions-area":["userchrome-toggle-extended_n2ezr_ru-browser-action","simple-translate_sienori-browser-action","_c84d89d9-a826-4015-957b-affebd9eb603_-browser-action","firefoxcolor_mozilla_com-browser-action","_7e79d10d-9667-4d38-838d-471281c568c3_-browser-action","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","vpn_proton_ch-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","vertical-spacer","urlbar-container","downloads-button","unified-extensions-button","ublock0_raymondhill_net-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","firefox_tampermonkey_net-browser-action","78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button"],"vertical-tabs":[],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","simple-translate_sienori-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","firefox_tampermonkey_net-browser-action","ublock0_raymondhill_net-browser-action","78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action","_c84d89d9-a826-4015-957b-affebd9eb603_-browser-action","firefoxcolor_mozilla_com-browser-action","userchrome-toggle-extended_n2ezr_ru-browser-action","_7e79d10d-9667-4d38-838d-471281c568c3_-browser-action","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","vpn_proton_ch-browser-action"],"dirtyAreaCache":["nav-bar","vertical-tabs","PersonalToolbar","unified-extensions-area","widget-overflow-fixed-list","toolbar-menubar","TabsToolbar"],"currentVersion":22,"newElementCount":9}'';
          "app.normandy.api_url" = "";
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "app.update.auto" = false;
          "beacon.enabled" = false;
          "breakpad.reportURL" = "";
          "browser.aboutConfig.showWarning" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          "browser.disableResetPrompt" = true;
          "browser.fixup.alternate.enabled" = false;
          "browser.newtab.preload" = true;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.enabled" = false;
          "browser.newtabpage.enhanced" = false;
          "browser.newtabpage.introShown" = true;
          "browser.safebrowsing.appRepURL" = "";
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.enabled" = false;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.search.suggest.enabled" = false;
          "browser.selfsupport.url" = "";
          "browser.sessionstore.privacy_level" = 0;
          "browser.startup.homepage_override.mstone" = ''ignore'';
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.urlbar.groupLabels.enabled" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;
          "browser.urlbar.trimURLs" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "device.sensors.ambientLight.enabled" = false;
          "device.sensors.enabled" = false;
          "device.sensors.motion.enabled" = false;
          "device.sensors.orientation.enabled" = false;
          "device.sensors.proximity.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.event.clipboardevents.enabled" = true;
          "dom.private-attribution.submission.enabled" = false;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = "";
          "experiments.supported" = false;
          "extensions.getAddons.cache.enabled" = false;
          "extensions.pocket.enabled" = false;
          "extensions.shield-recipe-client.api_url" = "";
          "extensions.shield-recipe-client.enabled" = false;
          "media.autoplay.default" = 0;
          "media.autoplay.enabled" = true;
          "media.eme.enabled" = false;
          "media.gmp-widevinecdm.enabled" = false;
          "media.navigator.enabled" = false;
          "media.video_stats.enabled" = false;
          "network.allow-experiments" = false;
          "network.captive-portal-service.enabled" = false;
          "network.cookie.cookieBehavior" = 1;
          "network.dns.disablePrefetch" = true;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.http.referer.spoofSource" = true;
          "network.http.speculative-parallel-limit" = 0;
          "network.predictor.enable-prefetch" = false;
          "network.predictor.enabled" = false;
          "network.prefetch-next" = false;
          "network.trr.mode" = 5;
          "privacy.donottrackheader.enabled" = true;
          "privacy.donottrackheader.value" = 1;
          "privacy.query_stripping" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.pbmode.enabled" = true;
          "privacy.usercontext.about_newtab_segregation.enabled" = true;
          "security.ssl.disable_session_identifiers" = true;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
          "signon.autofillForms" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.cachedClientID" = "";
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "webgl.disabled" = true;
          "webgl.renderer-string-override" = '''';
          "webgl.vendor-string-override" = '''';
          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.download.dir" = "${config.xdg.userDirs.download}";
          "browser.startup.page" = 3; # this is the settings that makes it so that you always open with the tabs you had open when you closed firefox. change to 1 for normalcy
          # below options are for theme thing
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # to make the userChrome below work
          "layers.acceleration.force-enabled" = true;
          "gfx.webrender.all" = true;
          "svg.context-properties.content.enabled" = true;
        };
        userChrome = ''
          #firefox-view-button,
          #alltabs-button,
          .titlebar-close,
          #reader-mode-button-icon,
          #reader-mode-button,
          .tab-close-button,
          #tracking-protection-icon-container,
          #context-sep-navigation,
          #tabs-newtab-button,
          #context-navigation,
          #context-savepage,
          #context-pocket,
          #context-savelinktopocket,
          #context-bookmarklink,
          #context-savelink,
          #context-inspect-a11y,
          #context-undo,
          #context-redo,
          #context-copy,
          #context-paste,
          #context-cut,
          #context-sep-redo,
          #context-delete,
          #context-selectall,
          #context-sep-selectall,
          #spell-check-enabled,
          #context-sep-bidi,
          .bookmark-item .toolbarbutton-icon {
            display: none !important;
          }

          :root {
            --conf-border-radius: 24px;
            --conf-toolbar-border-radius: 24px;
            --toolbarbutton-border-radius: var(--conf-toolbar-border-radius) !important;
            --tab-border-radius: var(--conf-border-radius) !important;
            /* --tab-selected-bgcolor: #1e1e2e !important; */
            --lwt-tab-line-color: $$ !important;
            --tab-selected-outline-color: $$ !important;

            --transition: 0.25s ease-in-out;
          }

          .tab-label {
            padding-left: 5px;
            padding-right: 5px;

            border-radius: var(--conf-border-radius) !important;

            font-size: 14px;
          }

          @media (prefers-color-scheme: dark) {
            .tab-label {
              border-radius: var(--conf-toolbar-border-radius) !important;
            }
          }

          .titlebar-spacer {
            display: none;
          }

          .bookmark-item {
            margin-right: 10px !important;
          }

          .tabbrowser-tab[selected="true"], .tabbrowser-tab[selected="true"] > * {
            font-weight: bold !important;

          }
        '';
      };
      policies = {
        ExtensionSettings = {
          # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # Check about:support for extension/add-on ID strings.
          # Valid strings for installation_mode are "allowed", "blocked",
          # "force_installed" and "normal_installed".

          # ublock-origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };

          # mal-sync:
          "{c84d89d9-a826-4015-957b-affebd9eb603}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/mal-sync/latest.xpi";
            installation_mode = "force_installed";
          };

          # stylus:
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/styl-us/latest.xpi";
            installation_mode = "force_installed";
          };

          # proton-pass:
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
            installation_mode = "force_installed";
          };

          # simple-translate:
          "simple-translate@sienori" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/simple-translate/latest.xpi";
            installation_mode = "force_installed";
          };

          # nighttab:
          "{47bf427e-c83d-457d-9b3d-3db4118574bd}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/nighttab/latest.xpi";
            installation_mode = "force_installed";
          };

          # search with MAL:
          "{68a3835c-43d9-4a23-a153-9d00276a4065}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/search-with-myanimelist/latest.xpi";
            installation_mode = "force_installed";
          };

          # catppuccin github file explorer:
          "{bbb880ce-43c9-47ae-b746-c3e0096c5b76}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-gh-file-explorer/latest.xpi";
            installation_mode = "force_installed";
          };

          # tampermonkey:
          "firefox@tampermonkey.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tampermonkey/latest.xpi";
            installation_mode = "force_installed";
          };

          # canvasblocker:
          "CanvasBlocker@kkapsner.de" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi";
            installation_mode = "force_installed";
          };

          # clearURLs:
          "{74145f27-f039-47ce-a470-a662b129930a}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
            installation_mode = "force_installed";
          };

          # decentraleyes:
          "jid1-BoFifL9Vbdl2zQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
            installation_mode = "force_installed";
          };

          # enhanced github:
          "{72bd91c9-3dc5-40a8-9b10-dec633c0873f}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/enhanced-github/latest.xpi";
            installation_mode = "force_installed";
          };

          # refined github:
          "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
            installation_mode = "force_installed";
          };

          # catppuccin mocha mauve:
          # "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}" = {
          #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-mocha-mauve-git/latest.xpi";
          #   installation_mode = "force_installed";
          # };
        };
      };
    };
  };
}
