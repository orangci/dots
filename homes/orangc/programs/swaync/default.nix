{
  pkgs,
  config,
  lib,
  host,
  ...
}: let
  inherit (lib) mkEnableOption types mkIf;
  cfg = config.hmModules.programs.swaync;
  colours = config.stylix.base16Scheme;
in {
  options.hmModules.programs.swaync = {
    enable = mkEnableOption "Enable swaync";
  };
  config = mkIf cfg.enable {
    home.packages = [pkgs.swaynotificationcenter];
    home.file.".config/swaync/config.json".source = ./swaync.json;
    home.file.".config/swaync/style.css".source = ./swaync.css;
  };
}
