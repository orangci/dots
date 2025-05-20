{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.cli.bat;
in {
  options.hmModules.cli.bat = {
    enable = mkEnableOption "Enable bat";
  };

  config = mkIf cfg.enable {
    programs.bat.enable = true;
    hmModules.cli.shell.extraAliases = {
      cat = "bat";
    };
  };
}
