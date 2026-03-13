{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.programs.sudo-rs;
in
{
  options.modules.programs.sudo-rs.enable = mkEnableOption "Enable sudo-rs";

  config = lib.mkIf cfg.enable {
    security.sudo-rs.enable = true;
  };
}
