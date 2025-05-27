{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.hmModules.dev.nix;
in {
  options.hmModules.dev.nix = {
    enable = mkEnableOption "Enable Nix development environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [alejandra nix-prefetch];
    hmModules.cli.shell.extraAliases = {
      list-big-pkgs = "nix path-info -hsr /run/current-system/ | sort -hrk2 | head -n 30";
      list-pkgs = "nix-store -q --requisites /run/current-system | cut -d- -f2- | sort | uniq";
      qn = "clear;nix-shell";
    };
  };
}
