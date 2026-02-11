{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.misc.xdg;
  browser = [ "firefox.desktop" ];
  fileManager = [ "thunar.desktop" ];
  editor = [ "${config.hmModules.programs.editors.xdg}.desktop" ];

  associations = {
    "text/html" = browser;
    "text/markdown" = editor;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;

    "inode/directory" = fileManager;
    "application/x-xz-compressed-tar" = fileManager;

    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
    "image/*" = [ config.hmModules.programs.media.xdg ];

    "application/json" = editor;
    "application/pdf" = browser;

    "x-scheme-handler/tg" = [ "telegramdesktop.desktop" ];
    "x-scheme-handler/discord" =
      if config.hmModules.programs.discord.enable then [ "discord.desktop" ] else browser;
    "x-scheme-handler/mailto" = browser;
  };

  removedAssociations = {
    "image/*" = [ "chromium.desktop" ];
  };
in
{
  options.hmModules.misc.xdg = {
    enable = mkEnableOption "Enable XDG";
  };
  config = mkIf cfg.enable {
    xdg = {
      configFile."mimeapps.list".force = true;
      enable = true;
      cacheHome = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      stateHome = "${config.home.homeDirectory}/.local/state";

      userDirs = {
        enable = pkgs.stdenv.isLinux;
        createDirectories = true;

        download = "${config.home.homeDirectory}/dl";
        desktop = null;
        documents = "${config.home.homeDirectory}/docs";

        publicShare = null;
        templates = null;

        music = "${config.home.homeDirectory}/media/audio";
        pictures = "${config.home.homeDirectory}/media";
        videos = "${config.home.homeDirectory}/media/videos";

        extraConfig = {
          SCREENSHOTS = "${config.xdg.userDirs.pictures}/screenshots";
          MAIL = "${config.xdg.userDirs.documents}/mail";
        };
      };

      mimeApps = {
        enable = true;
        associations.added = associations;
        associations.removed = removedAssociations;
        defaultApplications = associations;
      };
    };
  };
}
