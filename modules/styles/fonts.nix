{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.styles.fonts;
in {
  options.modules.styles.fonts = {
    enable = mkEnableOption "Enable fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        noto-fonts-emoji
        noto-fonts-cjk-sans
        font-awesome
        ubuntu-sans
        merriweather-sans
        merriweather
        lexend
        material-icons
        (nerdfonts.override {fonts = ["JetBrainsMono"];})
      ];
    };
  };
}
