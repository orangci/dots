{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.vencord = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    home.file = {
      ".config/Vencord/themes/orangetweaks.css".source = ../../files/vencordthemes/orangetweaks.css;
      ".config/Vencord/themes/catppuccin.css".source = ../../files/vencordthemes/catppuccin.css;
    };
  };
}
