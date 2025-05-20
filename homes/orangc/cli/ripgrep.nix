{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.cli.ripgrep;
in {
  options.hmModules.cli.ripgrep = {
    enable = mkEnableOption "Enable ripgrep";
  };

  config = mkIf cfg.enable {
    programs.ripgrep.enable = true;
    hmModules.cli.shell.extraAliases = {
      grep = "rg";
    };
  };
}
