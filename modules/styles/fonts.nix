{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.styles.fonts.enable =
      lib.mkEnableOption "enables fonts";
  };
  config = lib.mkIf config.modules.styles.fonts.enable {
    fonts = {
      packages = with pkgs; [
        noto-fonts-emoji
        noto-fonts-cjk
        font-awesome
        symbola
        ubuntu-sans
        merriweather-sans
        merriweather
        material-icons
        (nerdfonts.override {fonts = ["JetBrainsMono"];})
      ];
    };
  };
}
