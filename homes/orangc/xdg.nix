{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types;
  cfg = config.hmModules.core.xdg;
  browser = ["firefox.desktop"];
  fileManager = ["thunar.desktop"];
  editor = ["codium.desktop"];
  text = ["micro.desktop"];
  home.file."${config.xdg.dataHome}/applications/micro.desktop".text = ''
    [Desktop Entry]
    Name=Micro
    GenericName=Text Editor
    Comment=Edit text files in a terminal

    Icon=micro
    Type=Application
    Categories=Utility;TextEditor;Development;
    Keywords=text;editor;syntax;terminal;

    Exec=micro %F
    StartupNotify=false
    Terminal=true
    MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;
  '';

  associations = {
    "text/html" = browser;
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

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.desktop"];
    "image/*" = ["org.kde.kdegraphics.gwenview.lib"];
    "application/json" = editor;
    "application/pdf" = browser;

    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
    "x-scheme-handler/discord" = ["discord.desktop"];
    "x-scheme-handler/mailto" = browser;
  };
in {
  options.hmModules.core.xdg = {
    enabled = mkEnableOption "Enable XDG";
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
          XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
          XDG_MAIL_DIR = "${config.xdg.userDirs.documents}/mail";
        };
      };

      mimeApps = {
        enable = true;
        associations.added = associations;
        defaultApplications = associations;
      };
    };
  };
}
