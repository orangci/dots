{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption singleton mkIf;
  cfg = config.hmModules.programs.noctalia;
  enablePlugin = {
    enabled = true;
    sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
  };
in
{
  imports = singleton inputs.noctalia.homeModules.default;
  options.hmModules.programs.noctalia = {
    enable = mkEnableOption "Noctalia shell";
  };

  config = mkIf cfg.enable {
    stylix.targets.noctalia-shell.enable = false;
    home.packages = with pkgs; [
      gpu-screen-recorder
      wtype
    ];
    wayland.windowManager.hyprland.settings = {
      exec-once = singleton "noctalia-shell";
      layerrule = [
        "match:namespace ^noctalia-(?!.*wallpaper).*$, blur on"
        "match:namespace ^noctalia-(?!.*wallpaper).*$, ignore_alpha 0.8"
      ];
      bindd = [
        "SUPER, BACKSLASH, Open Session Menu, exec, noctalia-shell ipc call sessionMenu toggle"
        "SUPER, V, Show Clipboard, exec, noctalia-shell ipc call launcher clipboard"
        "SUPER, PERIOD, Open Emoji Picker, exec, noctalia-shell ipc call launcher emoji"
        "SUPER, K, Open App Launcher, exec, noctalia-shell ipc call launcher toggle"
        "SUPER, A, Open Notifications Panel, exec, noctalia-shell ipc call notifications toggleHistory"
        "SUPERSHIFT, A, Clear Notification History, exec, noctalia-shell ipc call notifications dismissAll"
        "SUPER, APOSTROPHE, Set Random Wallpaper, exec, noctalia-shell ipc call wallpaper random"
        "SUPERSHIFT, APOSTROPHE, Pick Wallpaper, exec, noctalia-shell ipc call wallpaper toggle"
        "SUPER, L, Lock Screen, exec, noctalia-shell ipc call lockScreen lock"
        "SUPER, TAB, Toggle Workspace Overview, exec, noctalia-shell ipc call plugin:workspace-overview toggle"
      ];
    };
    programs.noctalia-shell = {
      enable = true;
      settings = {
        ui.fontDefault = config.stylix.fonts.sansSerif.name;
        ui.fontFixed = config.stylix.fonts.monospace.name;
        appLauncher = {
          autoPasteClipboard = true;
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWrapText = true;
          customLaunchPrefix = "";
          customLaunchPrefixEnabled = false;
          density = "default";
          enableClipPreview = true;
          enableClipboardChips = true;
          enableClipboardHistory = true;
          enableClipboardSmartIcons = true;
          enableSessionSearch = true;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          iconMode = "tabler";
          overviewLayer = false;
          position = "center";
          screenshotAnnotationTool = "";
          showCategories = true;
          sortByMostUsed = true;
          terminalCommand = "${config.hmModules.programs.terminal.emulator} -e";
          viewMode = "list";
        };
        bar = {
          backgroundOpacity = 1;
          barType = "framed";
          capsuleColorKey = "none";
          capsuleOpacity = 1;
          contentPadding = 2;
          density = "default";
          displayMode = "always_visible";
          middleClickAction = "settings";
          middleClickCommand = "";
          middleClickFollowMouse = false;
          mouseWheelAction = "volume";
          mouseWheelWrap = true;
          outerCorners = true;
          position = "top";
          rightClickAction = "controlCenter";
          rightClickFollowMouse = true;
          showCapsule = true;
          showOnWorkspaceSwitch = true;
          showOutline = false;
          useSeparateOpacity = false;
          widgetSpacing = 6;
          widgets = {
            center = [
              {
                colorizeIcons = false;
                hideMode = "hidden";
                id = "ActiveWindow";
                maxWidth = 145;
                scrollingMode = "hover";
                showIcon = true;
                showText = true;
                textColor = "none";
                useFixedWidth = false;
              }
              {
                clockColor = "none";
                customFont = "";
                formatHorizontal = "HH:mm ddd, MMM dd";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH:mm dddd, MMM dd yyyy";
                useCustomFont = false;
              }
            ];
            left = [
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                fontWeight = "bold";
                groupedBorderOpacity = 1;
                hideUnoccupied = false;
                iconScale = 0.9;
                id = "Workspace";
                labelMode = "index";
                occupiedColor = "secondary";
                pillSize = 0.75;
                showApplications = true;
                showApplicationsHover = true;
                showBadge = true;
                showLabelsOnlyWhenOccupied = true;
                unfocusedIconsOpacity = 1;
              }
              {
                defaultSettings = {
                  activeColor = "primary";
                  azanFile = "azan1.mp3";
                  city = "Riyadh";
                  country = "SA";
                  dynamicIcon = false;
                  hidePrayerName = false;
                  hijriDayOffset = 0;
                  iconColor = "none";
                  method = 3;
                  playAzan = false;
                  school = 0;
                  showCountdown = true;
                  showElapsed = false;
                  showNotifications = true;
                  textColor = "none";
                  tune = false;
                  tuneAsr = 0;
                  tuneDhuhr = 0;
                  tuneFajr = 0;
                  tuneIsha = 0;
                  tuneMaghrib = 0;
                  widgetIcon = "building-mosque";
                };
                id = "plugin:mawaqit";
              }
              {
                compactMode = false;
                hideMode = "idle";
                hideWhenIdle = false;
                id = "MediaMini";
                maxWidth = 145;
                panelShowAlbumArt = true;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = true;
                showVisualizer = false;
                textColor = "none";
                useFixedWidth = false;
                visualizerType = "linear";
              }
            ];
            right = [
              {
                blacklist = [ ];
                chevronColor = "none";
                colorizeIcons = false;
                drawerEnabled = true;
                hidePassive = false;
                id = "Tray";
                pinned = [ ];
              }
              {
                defaultSettings = {
                  activeColor = "primary";
                  camFilterRegex = "";
                  enableToast = true;
                  hideInactive = false;
                  iconSpacing = 4;
                  inactiveColor = "none";
                  micFilterRegex = "";
                  removeMargins = false;
                };
                id = "plugin:privacy-indicator";
              }
              {
                deviceNativePath = "__default__";
                displayMode = "graphic";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = false;
                showPowerProfiles = true;
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
                textColor = "none";
              }
              {
                applyToAllMonitors = false;
                displayMode = "onhover";
                iconColor = "none";
                id = "Brightness";
                textColor = "none";
              }
              {
                defaultSettings = {
                  audioCodec = "opus";
                  audioSource = "default_output";
                  colorRange = "limited";
                  copyToClipboard = false;
                  customReplayDuration = "30";
                  directory = "";
                  filenamePattern = "recording_yyyy-MM-dd_HHmmss";
                  frameRate = "60";
                  hideInactive = false;
                  iconColor = "none";
                  quality = "very_high";
                  replayDuration = "30";
                  replayEnabled = false;
                  replayStorage = "ram";
                  resolution = "original";
                  restorePortalSession = false;
                  showCursor = true;
                  videoCodec = "h264";
                  videoSource = "portal";
                };
                id = "plugin:screen-recorder";
              }
              {
                defaultSettings = {
                  compactMode = false;
                  defaultPeerAction = "copy-ip";
                  hideDisconnected = false;
                  hideMullvadExitNodes = true;
                  loginServer = "";
                  pingCount = 5;
                  refreshInterval = 5000;
                  showIpAddress = true;
                  showPeerCount = true;
                  showSearchBar = false;
                  sshUsername = "";
                  taildropDownloadDir = config.xdg.userDirs.download;
                  taildropEnabled = true;
                  taildropReceiveMode = "operator";
                  terminalCommand = "";
                };
                id = "plugin:tailscale";
              }
              {
                hideWhenZero = true;
                hideWhenZeroUnread = false;
                iconColor = "none";
                id = "NotificationHistory";
                showUnreadBadge = true;
                unreadBadgeColor = "primary";
              }
              {
                colorizeDistroLogo = false;
                colorizeSystemIcon = "none";
                colorizeSystemText = "none";
                customIconPath = "";
                enableColorization = false;
                icon = "noctalia";
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
          };
        };
        brightness = {
          brightnessStep = 5;
          enableDdcSupport = false;
          enforceMinimum = true;
        };
        calendar = {
          cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
          ];
        };
        colorSchemes.darkMode = true;
        controlCenter = {
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
          diskPath = "/";
          position = "close_to_bar_button";
          shortcuts = {
            left = [
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "WallpaperSelector";
              }
              {
                defaultSettings = {
                  compactMode = false;
                  defaultDuration = 0;
                  iconColor = "none";
                  textColor = "none";
                };
                id = "plugin:timer";
              }
              {
                id = "Notifications";
              }
            ];
            right = [
              {
                id = "KeepAwake";
              }
              {
                id = "NightLight";
              }
              {
                defaultSettings = {
                  audioCodec = "opus";
                  audioSource = "default_output";
                  colorRange = "limited";
                  copyToClipboard = false;
                  customReplayDuration = "30";
                  directory = "";
                  filenamePattern = "recording_yyyyMMdd_HHmmss";
                  frameRate = "60";
                  hideInactive = false;
                  iconColor = "none";
                  quality = "very_high";
                  replayDuration = "30";
                  replayEnabled = false;
                  replayStorage = "ram";
                  resolution = "original";
                  restorePortalSession = false;
                  showCursor = true;
                  videoCodec = "h264";
                  videoSource = "portal";
                };
                id = "plugin:screen-recorder";
              }
              {
                defaultSettings = {
                  autoMount = false;
                  fileBrowser = "xdg-open";
                  hideWhenEmpty = false;
                  iconColor = "none";
                  showBadge = false;
                  showNotifications = true;
                  terminalCommand = config.hmModules.programs.terminal.emulator;
                };
                id = "plugin:usb-drive-manager";
              }
            ];
          };
        };
        desktopWidgets.enabled = false;
        dock.enabled = false;
        general = {
          allowPanelsOnScreenWithoutBar = true;
          allowPasswordWithFprintd = true;
          animationSpeed = 1;
          autoStartAuth = true;
          avatarImage = "${config.home.homeDirectory}/.face.icon";
          boxRadiusRatio = 1;
          clockFormat = "H\\nmm";
          clockStyle = "custom";
          enableBlurBehind = true;
          enableLockScreenCountdown = true;
          enableLockScreenMediaControls = false;
          enableShadows = true;
          lockOnSuspend = true;
          lockScreenAnimations = true;
          lockScreenBlur = 1;
          lockScreenCountdownDuration = 5000;
          lockScreenTint = 0.1;
          showChangelogOnStartup = true;
          showHibernateOnLockScreen = false;
          showScreenCorners = true;
          showSessionButtonsOnLockScreen = true;
        };
        idle = {
          enabled = true;
          fadeDuration = 5;
          lockTimeout = 660;
          screenOffTimeout = 600;
          suspendTimeout = 1800;
        };
        location.autoLocate = true;
        notifications = {
          backgroundOpacity = 1;
          clearDismissed = true;
          criticalUrgencyDuration = 15;
          density = "default";
          enableBatteryToast = true;
          enableKeyboardLayoutToast = true;
          enableMarkdown = true;
          enableMediaToast = false;
          enabled = true;
          location = "top_right";
          lowUrgencyDuration = 3;
          normalUrgencyDuration = 6;
          overlayLayer = true;
          respectExpireTimeout = false;
          saveToHistory = {
            critical = true;
            low = true;
            normal = true;
          };
        };
        osd = {
          autoHideMs = 2000;
          backgroundOpacity = 1;
          enabled = true;
          enabledTypes = [
            0
            1
            2
            3
          ];
          location = "right";
          overlayLayer = true;
        };
        sessionMenu = {
          countdownDuration = 5000;
          enableCountdown = false;
          largeButtonsLayout = "single-row";
          largeButtonsStyle = true;
          position = "center";
        };
        settingsVersion = 59;
        ui = {
          boxBorderEnabled = false;
          fontDefaultScale = 1;
          fontFixedScale = 1;
          panelBackgroundOpacity = 1;
          panelsAttachedToBar = true;
          scrollbarAlwaysVisible = false;
          settingsPanelMode = "attached";
          settingsPanelSideBarCardStyle = true;
          tooltipsEnabled = true;
          translucentWidgets = true;
        };
        wallpaper = {
          automationEnabled = true;
          directory = "${config.xdg.userDirs.pictures}/walls";
          enableMultiMonitorDirectories = false;
          enabled = true;
          favorites = [ ];
          fillColor = config.lib.stylix.colors.withHashtag.base00;
          fillMode = "crop";
          hideWallpaperFilenames = false;
          linkLightAndDarkWallpapers = true;
          monitorDirectories = [ ];
          overviewBlur = 0.4;
          overviewEnabled = false;
          overviewTint = 0.6;
          panelPosition = "center";
          randomIntervalSec = 300;
          setWallpaperOnAllMonitors = true;
          showHiddenFiles = false;
          skipStartupTransition = false;
          solidColor = config.lib.stylix.colors.withHashtag.base00;
          sortOrder = "name";
          transitionDuration = 1500;
          transitionEdgeSmoothness = 0.05;
          transitionType = [
            "fade"
            "disc"
            "stripes"
            "wipe"
            "pixelate"
            "honeycomb"
          ];
          useOriginalImages = true;
          useSolidColor = false;
          useWallhaven = false;
          viewMode = "browse";
          wallpaperChangeMode = "random";
        };
      };
      plugins = {
        sources = singleton {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        states = {
          tailscale = enablePlugin;
          currency-exchange = enablePlugin;
          usb-drive-manager = enablePlugin;
          workspace-overview = enablePlugin;
          file-search = mkIf config.programs.fd.enable enablePlugin;
          privacy-indicator = enablePlugin;
          mawaqit = enablePlugin;
          dmenu = enablePlugin;
          ntfy-notifications = enablePlugin;
          keybind-cheatsheet = enablePlugin;
          timer = enablePlugin;
          kde-connect = mkIf config.services.kdeconnect.enable enablePlugin;
          polkit-agent = enablePlugin;
          custom-commands = enablePlugin;
          screen-recorder = enablePlugin;
        };
        version = 2;
      };

      pluginSettings = {
        ntfy-notifications = {
          serverUrl = "https://ntfy.orangc.net";
          topics = ["services"];
        };
      };

      colors = with config.lib.stylix.colors.withHashtag; {
        mPrimary = base0D;
        mOnPrimary = base00;
        mSecondary = base0E;
        mOnSecondary = base00;
        mTertiary = base0C;
        mOnTertiary = base00;
        mError = base08;
        mOnError = base00;
        mSurface = base00;
        mOnSurface = base05;
        mHover = base0C;
        mOnHover = base00;
        mSurfaceVariant = base01;
        mOnSurfaceVariant = base04;
        mOutline = base03;
        mShadow = base00;
      };
    };
  };
}
