{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf singleton;
  cfg = config.hmModules.programs.office;
in
{
  options.hmModules.programs.office = {
    enable = mkEnableOption "Enable LibreOffice";
  };

  config = mkIf cfg.enable {
    home.packages = singleton pkgs.libreoffice-qt;
  };
}
