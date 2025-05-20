{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.cli.eza;
in {
  options.hmModules.cli.eza = {
    enable = mkEnableOption "Enable eza";
  };

  config = mkIf cfg.enable {
    programs.eza.enable = true;
    hmModules.shell.extraAliases = {
      ls = "eza -la --icons=auto";
      l = "eza -a --icons=auto";
    };
  };
}
