{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption types mkIf;
  cfg = config.hmModules.styles.stylix;
in {
  imports = [inputs.stylix.homeManagerModules.stylix];
  options.hmModules.styles.stylix = {
    enable = mkEnableOption "Enable Stylix";
  };
  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      image = ../../assets/face.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Original-Classic"; # use Bibata-Original-Ice for a white cusor or Amber for orange
        size = 24;
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
        vscode.enable = false;
      };
    };
  };
}
