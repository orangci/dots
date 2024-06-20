{
  pkgs,
  config,
  lib,
  host,
  username,
  ...
}:
let
  palette = config.stylix.base16Scheme;
in
with lib;
{
 programs.firefox = {
    enable = true;
    profiles.orangc = {

      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

      "MyAnimeList" = {
      urls = [{
        template = "https://myanimelist.net/search/all?q=";
      }];
      definedAliases = [ "@mal" ];
    };

      "YouTube" = {
      urls = [{
        template = "https://www.youtube.com/results?search_query=";
      }];
      definedAliases = [ "@yt" ];
    };

      };
      search.force = true;

      settings = {
        "accessibility.browsewithcaret_shortcut.enabled" = false;	
        "accessibility.typeaheadfind.flashBar" = 0;
        "app.normandy.first_run" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.editDialog.confirmationHintShowCount" = 3;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.showMobileBookmarks" = false;
        "browser.contentblocking.category" = "standard";
        "browser.discovery.enabled" = false;
        "browser.download.panel.shown" = true;
        "browser.download.useDownloadDir" = false;
        "browser.engagement.ctrlTab.has-used" = true;
        "browser.engagement.downloads-button.has-used" = true;
        "browser.engagement.fxa-toolbar-menu-button.has-used" = true;
        "browser.firefox-view.feature-tour" = "{"message":"FIREFOX_VIEW_FEATURE_TOUR","screen":"","complete":true}";
        "browser.newtab.extensionControlled" = true;
        "browser.newtab.privateAllowed" = false;
        "browser.policies.applied" = true;
        "browser.protections_panel.infoMessage.seen" = true;
        "browser.startup.page" = 3;
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "browser.uiCustomization.state" = "{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_bbb880ce-43c9-47ae-b746-c3e0096c5b76_-browser-action","support_premid_app-browser-action"],"nav-bar":["back-button","forward-button","urlbar-container","downloads-button","unified-extensions-button","78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action","ublock0_raymondhill_net-browser-action","browsec_browsec_com-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","firefox_tampermonkey_net-browser-action","_c84d89d9-a826-4015-957b-affebd9eb603_-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action","browsec_browsec_com-browser-action","ublock0_raymondhill_net-browser-action","_bbb880ce-43c9-47ae-b746-c3e0096c5b76_-browser-action","firefox_tampermonkey_net-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","_c84d89d9-a826-4015-957b-affebd9eb603_-browser-action","support_premid_app-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","unified-extensions-area"],"currentVersion":20,"newElementCount":4}";
        "browser.urlbar.quicksuggest.scenario" = "offline";
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.topsites" = false;
        "devtools.everOpened" = true;
        "devtools.toolsidebar-height.inspector" = 350;
        "devtools.toolsidebar-width.inspector" = 700;
        "devtools.toolsidebar-width.inspector.splitsidebar" = 350;
        "distribution.iniFile.exists.appversion" = 127.0;
        "distribution.iniFile.exists.value" = true;
        "distribution.nixos.bookmarksProcessed" = true;
        "doh-rollout.doneFirstRun" = true;
        "dom.disable_open_during_load" = false;
        "dom.forms.autocomplete.formautofill" = true;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "dom.security.https_only_mode_ever_enabled_pbm" = true;
        "extensions.activeThemeID" = "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}";
        "extensions.blocklist.pingCountVersion" = -1;
        "extensions.databaseSchema" = 36;
        "extensions.pendingOperations" = false;
        "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
        "extensions.quarantinedDomains.list" = "autoatendimento.bb.com.br,ibpf.sicredi.com.br,ibpj.sicredi.com.br,internetbanking.caixa.gov.br,www.ib12.bradesco.com.br,www2.bancobrasil.com.br";
        "general.autoScroll" = true;
        "pref.downloads.disable_button.edit_actions" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.formdata" = false;
        "privacy.clearOnShutdown.sessions" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.globalprivacycontrol.was_ever_enabled" = true;
        "privacy.userContext.enabled" = true;

      };

      # userChrome = ''                         
      #   /* some css */                        
      # '';                                      

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        proton-pass
        ublock-origin
        sponsorblock
        mal-sync
        nighttab
        istilldontcareaboutcookies
        flagfox
        ff2mpv
        github-file-icons
        modrinthify
        refined-github-
        return-youtube-dislikes
        simple-translate
        styl-us
        tampermonkey
        youtube-addon
      ];

    };
  };
}
