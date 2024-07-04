{ config, ... }:
let
  palette = config.stylix.base16Scheme;
in
{
    # Search engine thing
  home.file.".config/rofi/websearch.rasi".text = ''
       @theme "~/.config/rofi/config.rasi"
      '';
}