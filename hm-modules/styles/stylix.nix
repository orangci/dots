{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.styles.stylix = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    stylix = {
      enable = true;
      image = ../../files/face.png;
      base16Scheme = {
        base00 = "1e1e2e";
        base01 = "181825";
        base02 = "313244";
        base03 = "45475a";
        base04 = "585b70";
        base05 = "cdd6f4";
        base06 = "f5e0dc";
        base07 = "b4befe";
        base08 = "f38ba8";
        base09 = "fab387";
        base0A = "f9e2af";
        base0B = "a6e3a1";
        base0C = "94e2d5";
        base0D = "89b4fa";
        base0E = "cba6f7";
        base0F = "f2cdcd";
      };
      polarity = "dark";
      cursor = {
        package = pkgs.oreo-cursors-plus;
        name = "oreo_spark_orange_cursors";
        size = 24;
      };
      fonts = {
        monospace = {
          package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
          name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.raleway;
          name = "Raleway";
        };
        serif = {
          package = pkgs.merriweather;
          name = "Merriweather";
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
      };
    };
  };
}
