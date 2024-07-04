{ config, ... }:
let
  palette = config.stylix.base16Scheme;
in
{
    # Application launcher
  home.file.".config/rofi/launcher.rasi".text = ''
       @theme "~/.config/rofi/config.rasi"
      '';
}