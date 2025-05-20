{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.cli.fzf;
in {
  options.hmModules.cli.fzf = {
    enable = mkEnableOption "Enable fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf.enable = true;
    hmModules.cli.shell.extraAliases = {
      fuzzy = "fzf";
    };
  };
}
