{ config, ... }:
let
  palette = config.stylix.base16Scheme;
in
{
    # Styling for the clipboard
  home.file.".config/rofi/clipboard.rasi".text = ''
       @theme "~/.config/rofi/config.rasi"
       inputbar {
            enabled:                     false;
        }
      '';
}