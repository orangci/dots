{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.desktop.fonts;
in
{
  options.modules.desktop.fonts.enable = mkEnableOption "Enable fonts";
  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
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
}
