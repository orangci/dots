{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.hmModules.theming.stylix;
in
{
  imports = [ inputs.stylix.homeModules.stylix ];
  options.hmModules.theming.stylix = {
    enable = mkEnableOption "Stylix";
    theme = mkOption {
      type = types.str;
      default = "catppuccin-mocha";
      example = "rose-pine";
      description = "The base16 scheme Stylix should use. This is the name of a file in <https://github.com/tinted-theming/schemes>, without the extension.";
    };
  };
  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      image = ../../assets/face.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";

      polarity = "dark";
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic"; # use Bibata-Modern-Ice for a white cusor or Amber for orange
        size = 20;
      };
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.ubuntu-mono;
          name = "UbuntuMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.lexend;
          name = "Lexend";
        };
        serif = {
          package = pkgs.merriweather;
          name = "Merriweather";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 12;
          terminal = 16;
          desktop = 12;
          popups = 12;
        };
      };
      targets = {
        waybar.enable = false;
        rofi.enable = false;
        hyprland.enable = false;
        kde.enable = false;
        firefox.colorTheme.enable = true;
        # firefox.enable = false;
        firefox.profileNames = [ config.home.username ];
      };
    };
  };
}
