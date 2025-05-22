{
  pkgs,
  config,
  lib,
  inputs,
  username,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.hmModules.styles.stylix;
in {
  imports = [inputs.stylix.homeModules.stylix];
  options.hmModules.styles.stylix = {
    enable = mkEnableOption "Enable Stylix";
    theme = mkOption {
      type = types.str;
      default = "catppuccin-mocha";
      description = "The name of the theme to set Stylix too. Choose from https://github.com/tinted-theming/schemes";
    };
  };
  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      image = ../../../assets/face.png;
      base16Scheme = lib.importJSON (pkgs.runCommand "base16-scheme.json" {buildInputs = [pkgs.yq pkgs.jq];} ''
        yq '.palette' ${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml | \
          jq '.' > $out'');

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
          package = pkgs.noto-fonts-emoji;
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
        firefox.profileNames = ["${username}"];
      };
    };
  };
}
