{
  pkgs,
  config,
  lib,
  host,
  ...
}: let
  inherit (lib) mkOption types;
  palette = config.stylix.base16Scheme;
in {
  options.hmModules.programs.swaync = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    home.packages = [pkgs.swaynotificationcenter];
    home.file.".config/swaync/config.json".source = ./swaync.json;
    home.file.".config/swaync/style.css".source = ./swaync.css;
  };
}
