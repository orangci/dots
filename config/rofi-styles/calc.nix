{ config, ... }:
let
  palette = config.stylix.base16Scheme;
in
{
    # For running quick bash commands
  home.file.".config/rofi/calc.rasi".text = ''
       @theme "~/.config/rofi/config.rasi"
            entry {
        enabled:                     true;
        background-color:            transparent;
        text-color:                  inherit;
        cursor:                      text;
        placeholder:                 "Run a calculation";
        placeholder-color:           inherit;
        vertical-align:              0.5;
        horizontal-align:            0.5;
    }
      '';
}