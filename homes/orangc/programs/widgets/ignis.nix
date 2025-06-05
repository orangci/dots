{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.widgets.ignis;
in
{
  options.hmModules.programs.widgets.ignis = {
    enable = mkEnableOption "Enable ignis";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ inputs.ignis.packages.${system}.ignis ];
  };
}
