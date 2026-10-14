{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.theming.fonts;
in
{
  options.hmModules.theming.fonts.enable =
    mkEnableOption "the fonts bundled in this flake, installed into ~/.local/share/fonts";

  config = mkIf cfg.enable {
    home.file.".local/share/fonts" = {
      source = ./fonts;
      recursive = true;
    };
  };
}
