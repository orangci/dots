{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.cli.fun;
in {
  options.hmModules.cli.fun = {
    enable = mkEnableOption "Enable fun CLI programs";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [cmatrix lolcat kittysay uwuify];
  };
}
