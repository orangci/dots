{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.styles.fonts;
in
{
  options.modules.styles.fonts = {
    enable = mkEnableOption "Enable fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        noto-fonts-cjk-sans
        ubuntu-sans
        raleway
        maple-mono.truetype
        merriweather
        lexend
        material-icons
        material-symbols
        nerd-fonts.ubuntu-mono
      ];
    };
  };
}
