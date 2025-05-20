{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.hmModules.cli.zoxide;
in {
  options.hmModules.cli.zoxide = {
    enable = mkEnableOption "Enable zoxide";
  };

  config = mkIf cfg.enable {
    programs.zoxide.enable = true;
    hmModules.shell.extraAliases = {
      cd = "z";
      ".." = "z ..";
    };
  };
}
