{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.dm.sddm;
in
{
  options.modules.dm.sddm = {
    enable = mkEnableOption "Enable SDDM";
    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = ./sddm-astronaut-wall.jpg;
      description = "Wallpaper to use for the SDDM Astronaut theme";
    };
    theme = lib.mkOption {
      type = lib.types.str;
      default = "tokyo-night";
      description = "The SDDM theme to use";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      let
        sddm-themes = pkgs.callPackage ./pkgs.nix { };
        sddm-astronaut = pkgs.sddm-astronaut.override {
          themeConfig = {
            Background = "${cfg.wallpaper}";
            PartialBlur = "true";
            Blur = 0.0;
            FormPosition = "right";
            HideLoginButton = true;
            HideVirtualKeyboard = true;
            RoundCorners = 24;
            Font = "Lexend";
            HourFormat = "HH.mm";
            DateFormat = "dddd, MMM d";
            AllowEmptyPassword = true;
            
            TranslatePlaceholderUsername = "Yer name, captain?";
            TranslatePlaceholderPassword = "Enter thy passkey.";
            TranslateLoginFailedWarning = "Thou may not pass!";
            TranslateCapslockWarning = "Fool! Ye have left yer capslock on!";

            # Colours (Rosé Pine)
            LoginButtonBackgroundColor = "#c4a7e7";
            HoverVirtualKeyboardButtonTextColor = "#eb6f92";
            HoverUserIconColor = "#eb6f92";
            HoverPasswordIconColor = "#eb6f92";
            HoverSystemButtonsIconsColor = "#f6c177";
            HoverSessionButtonTextColor = "#c4a7e7";

            HeaderTextColor = "#e0def4";
            DateTextColor = "#e0def4";
            TimeTextColor = "#e0def4";
            FormBackgroundColor = "#1f1d2e";
            BackgroundColor = "#191724";
            DimBackgroundColor = "#1f1d2e";
            LoginFieldBackgroundColor = "#21202e";
            PasswordFieldBackgroundColor = "#21202e";
            LoginFieldTextColor = "#e0def4";
            PasswordFieldTextColor = "#e0def4";
            UserIconColor = "#f6c177";
            PasswordIconColor = "#f6c177";
            PlaceholderTextColor = "#6e6a86";
            WarningColor = "#403d52";
            LoginButtonTextColor = "#e0def4";
            SystemButtonsIconsColor = "#f6c177";
            SessionButtonTextColor = "#e0def4";
            VirtualKeyboardButtonTextColor = "#e0def4";
            DropdownTextColor = "#e0def4";
            DropdownSelectedBackgroundColor = "#403d52";
            DropdownBackgroundColor = "#1f1d2e";
            HighlightTextColor = "#e0def4";
            HighlightBackgroundColor = "#403d52";
            HighlightBorderColor = "#403d52";
          };
        };
      in
      [
        sddm-themes.sugar-dark
        sddm-themes.tokyo-night
        sddm-themes.stray
        sddm-astronaut
        pkgs.libsForQt5.qt5.qtgraphicaleffects
        pkgs.kdePackages.qtdeclarative
        pkgs.kdePackages.qtmultimedia
        pkgs.kdePackages.qtbase
        pkgs.kdePackages.qtsvg
      ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = cfg.theme;
    };
  };
}
