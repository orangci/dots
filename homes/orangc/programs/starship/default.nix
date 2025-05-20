{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption types mkIf;
  cfg = config.hmModules.programs.starship;
in {
  options.hmModules.programs.starship = {
    enable = mkEnableOption "Enable starship";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [starship];
    home.file.".config/starship.toml".source = ./starship.toml;
  };
}
