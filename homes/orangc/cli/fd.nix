{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.cli.fd;
in {
  options.hmModules.cli.fd = {
    enable = mkEnableOption "Enable fd";
  };

  config = mkIf cfg.enable {
    programs.fd.enable = true;
    hmModules.shell.extraAliases = {
      find = "fd";
    };
  };
}
