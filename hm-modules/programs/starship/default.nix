{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.starship = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    home.packages = with pkgs; [starship];
    home.file.".config/starship.toml".source = ./starship.toml;
  };
}
