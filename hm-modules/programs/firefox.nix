{
  pkgs,
  config,
  lib,
  username,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.firefix = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    programs.firefox = {
      enable = true;
      profiles.${username} = {
        id = 0;
        isDefault = true;
        search = {
          default = "SearX";
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };

            "NixOS Wiki" = {
              urls = [{template = "https://wiki.nixos.org/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://wiki.nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@nw"];
            };

            "Nix Options" = {
              definedAliases = ["@no"];
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "Urban Dictionary" = {
              definedAliases = ["@urban"];
              urls = [
                {
                  template = "https://www.urbandictionary.com/define.php";
                  params = [
                    {
                      name = "term";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "Youtube" = {
              definedAliases = ["@yt"];
              urls = [
                {
                  template = "https://youtube.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "MyAnimeList" = {
              definedAliases = ["@mal"];
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
            };

            "Startpage" = {
              definedAliases = ["@sp"];
              urls = [
                {
                  template = "https://www.startpage.com/sp/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "Code Search" = {
              definedAliases = ["@gh"];
              urls = [
                {
                  template = "https://github.com/search?type=code";
                  params = [
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
          browser.uiCustomization.state = ''{"placements":{"widget-overflow-fixed-list":["fxa-toolbar-menu-button","developer-button","panic-button","bookmarks-menu-button","open-file-button","print-button","screenshot-button","logins-button","sync-button","library-button"],"unified-extensions-area":["firefox_tampermonkey_net-browser-action","simple-translate_sienori-browser-action","browsec_browsec_com-browser-action","_bbb880ce-43c9-47ae-b746-c3e0096c5b76_-browser-action","webextension_metamask_io-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","unified-extensions-button","ublock0_raymondhill_net-browser-action","78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action","_c84d89d9-a826-4015-957b-affebd9eb603_-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","_c84d89d9-a826-4015-957b-affebd9eb603_-browser-action","simple-translate_sienori-browser-action","ublock0_raymondhill_net-browser-action","browsec_browsec_com-browser-action","_bbb880ce-43c9-47ae-b746-c3e0096c5b76_-browser-action","firefox_tampermonkey_net-browser-action","webextension_metamask_io-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","unified-extensions-area","widget-overflow-fixed-list","toolbar-menubar","TabsToolbar"],"currentVersion":20,"newElementCount":4}'';
          app.normandy.api_url = "";
          app.normandy.enabled = false;
          app.shield.optoutstudies.enabled = false;
          app.update.auto = false;
          beacon.enabled = false;
          breakpad.reportURL = "";
          browser.aboutConfig.showWarning = false;
          browser.crashReports.unsubmittedCheck.autoSubmit = false;
          browser.crashReports.unsubmittedCheck.autoSubmit2 = false;
          browser.crashReports.unsubmittedCheck.enabled = false;
          browser.disableResetPrompt = true;
          browser.fixup.alternate.enabled = false;
          browser.newtab.preload = false;
          browser.newtabpage.activity-stream.section.highlights.includePocket = false;
          browser.newtabpage.enabled = false;
          browser.newtabpage.enhanced = false;
          browser.newtabpage.introShown = true;
          browser.safebrowsing.appRepURL = "";
          browser.safebrowsing.blockedURIs.enabled = false;
          browser.safebrowsing.downloads.enabled = false;
          browser.safebrowsing.downloads.remote.enabled = false;
          browser.safebrowsing.downloads.remote.url = "";
          browser.safebrowsing.enabled = false;
          browser.safebrowsing.malware.enabled = false;
          browser.safebrowsing.phishing.enabled = false;
          browser.search.suggest.enabled = false;
          browser.selfsupport.url = "";
          browser.sessionstore.privacy_level = 0;
          browser.startup.homepage_override.mstone = ''ignore'';
          browser.tabs.crashReporting.sendReport = false;
          browser.urlbar.groupLabels.enabled = false;
          browser.urlbar.quicksuggest.enabled = false;
          browser.urlbar.speculativeConnect.enabled = false;
          browser.urlbar.trimURLs = false;
          datareporting.healthreport.service.enabled = false;
          datareporting.healthreport.uploadEnabled = false;
          datareporting.policy.dataSubmissionEnabled = false;
          device.sensors.ambientLight.enabled = false;
          device.sensors.enabled = false;
          device.sensors.motion.enabled = false;
          device.sensors.orientation.enabled = false;
          device.sensors.proximity.enabled = false;
          dom.battery.enabled = false;
          dom.event.clipboardevents.enabled = false;
          dom.private-attribution.submission.enabled = false;
          experiments.activeExperiment = false;
          experiments.enabled = false;
          experiments.manifest.uri = "";
          experiments.supported = false;
          extensions.getAddons.cache.enabled = false;
          extensions.pocket.enabled = false;
          extensions.shield-recipe-client.api_url = "";
          extensions.shield-recipe-client.enabled = false;
          media.autoplay.default = 0;
          media.autoplay.enabled = true;
          media.eme.enabled = false;
          media.gmp-widevinecdm.enabled = false;
          media.navigator.enabled = false;
          media.video_stats.enabled = false;
          network.allow-experiments = false;
          network.captive-portal-service.enabled = false;
          network.cookie.cookieBehavior = 1;
          network.dns.disablePrefetch = true;
          network.dns.disablePrefetchFromHTTPS = true;
          network.http.referer.spoofSource = true;
          network.http.speculative-parallel-limit = 0;
          network.predictor.enable-prefetch = false;
          network.predictor.enabled = false;
          network.prefetch-next = false;
          network.trr.mode = 5;
          privacy.donottrackheader.enabled = true;
          privacy.donottrackheader.value = 1;
          privacy.query_stripping = true;
          privacy.trackingprotection.cryptomining.enabled = true;
          privacy.trackingprotection.enabled = true;
          privacy.trackingprotection.fingerprinting.enabled = true;
          privacy.trackingprotection.pbmode.enabled = true;
          privacy.usercontext.about_newtab_segregation.enabled = true;
          security.ssl.disable_session_identifiers = true;
          services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite = false;
          signon.autofillForms = false;
          toolkit.telemetry.archive.enabled = false;
          toolkit.telemetry.bhrPing.enabled = false;
          toolkit.telemetry.cachedClientID = "";
          toolkit.telemetry.enabled = false;
          toolkit.telemetry.firstShutdownPing.enabled = false;
          toolkit.telemetry.hybridContent.enabled = false;
          toolkit.telemetry.newProfilePing.enabled = false;
          toolkit.telemetry.prompted = 2;
          toolkit.telemetry.rejected = true;
          toolkit.telemetry.reportingpolicy.firstRun = false;
          toolkit.telemetry.server = "";
          toolkit.telemetry.shutdownPingSender.enabled = false;
          toolkit.telemetry.unified = false;
          toolkit.telemetry.unifiedIsOptIn = false;
          toolkit.telemetry.updatePing.enabled = false;
          webgl.disabled = true;
          webgl.renderer-string-override = '''';
          webgl.vendor-string-override = '''';
          browser.download.always_ask_before_handling_new_types = true;
          browser.download.dir = ''/home/${username}/dl'';
          browser.startup.page = 3; # this is the settings that makes it so that you always open with the tabs you had open when you closed firefox. change to 1 for normalcy
          # below options are for theme thing
          toolkit.legacyUserProfileCustomizations.stylesheets = true;
          layers.acceleration.force-enabled = true;
          gfx.webrender.all = true;
          svg.context-properties.content.enabled = true;
        };
        userChrome = ''
          #firefox-view-button,
          #alltabs-button,
          .titlebar-close,
          #reader-mode-button-icon,
          #reader-mode-button,
          #star-button-box,
          .tab-close-button,
          #star-button,
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
            --tab-selected-bgcolor: #1e1e2e !important;
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

          # tampermonkey:
          "{bbb880ce-43c9-47ae-b746-c3e0096c5b76}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-gh-file-explorer/latest.xpi";
            installation_mode = "force_installed";
          };

          # tampermonkey:
          "firefox@tampermonkey.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tampermonkey/latest.xpi";
            installation_mode = "force_installed";
          };

          # catppuccin mocha mauve:
          "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-mocha-mauve-git/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };
  };
}
