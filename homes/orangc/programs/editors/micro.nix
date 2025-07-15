{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkForce mkEnableOption mkDefault mkIf;
  cfg = config.hmModules.programs.editors.micro;
in
{
  options.hmModules.programs.editors.micro.enable = mkEnableOption "Enable micro";

  config = mkIf cfg.enable {
    programs.micro = {
      enable = true;
      settings.colorscheme = mkForce "cmc-16";
    };
  };
}
