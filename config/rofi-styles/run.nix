{ config, ... }:
let
  palette = config.stylix.base16Scheme;
in
{
    # For running quick bash commands
  home.file.".config/rofi/run.rasi".text = ''
       @theme "~/.config/rofi/config.rasi"
       listview {
            enabled:                     false;
        }
      '';
}