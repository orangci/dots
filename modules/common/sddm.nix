{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (pkgs) stdenv fetchFromGitHub;
  cfg = config.modules.dm.sddm;

  sddm-stray = stdenv.mkDerivation rec {
    pname = "sddm-stray";
    version = "8c7759d9a05ad44f71209914b7223cebf845ccd9";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/theme $out/share/sddm/themes/stray
    '';
    src = fetchFromGitHub {
      owner = "Bqrry4";
      repo = "sddm-stray";
      rev = version;
      sha256 = "sha256-3wsQFbo545SXwfV5P4+S4/wTme/n/yunfeVpmcEmKz4=";
    };
  };

  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      Background = "${cfg.wallpaper}";
      Font = "Open Sans"; # options: ESPACION, pixelon, Thunderman, Electroharmonix, arcadeclassic, Fragile Bombers Attack, Open Sans
      HourFormat = "HH.mm";
      DateFormat = "dddd, MMM d";
      FormPosition = "right";
      HideVirtualKeyboard = "true";
      HideLoginButton = "true";
      HideCompletePassword = "true";
      AllowEmptyPassword = "true";
    };
  };
in
{
  options.modules.dm.sddm = {
    enable = mkEnableOption "Enable SDDM";
    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = ../../assets/sddm-astronaut-wall.jpg;
      description = "Wallpaper to use for the SDDM Astronaut theme";
    };
    theme = lib.mkOption {
      type = lib.types.str;
      default = "sddm-astronaut-theme";
      description = "The SDDM theme to use";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      sddm-stray
      sddm-astronaut
      pkgs.libsForQt5.qt5.qtgraphicaleffects
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = cfg.theme;
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs.kdePackages; [
        qtsvg
        qtmultimedia
        qtvirtualkeyboard
        kpipewire
      ];
    };
  };
}
