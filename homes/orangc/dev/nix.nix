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
  };
}
