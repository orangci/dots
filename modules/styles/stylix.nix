{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.styles.stylix;
in {
  imports = [inputs.stylix.nixosModules.stylix];
  options.modules.styles.stylix = {
    enable = mkEnableOption "Enable stylix";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      image = ../../assets/face.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";
      targets.chromium.enable = false;
      targets.grub.enable = false;
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
    };
  };
}
