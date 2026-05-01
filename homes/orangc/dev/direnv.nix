{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.dev.direnv;
in
{
  options.hmModules.dev.direnv.enable = mkEnableOption "Enable the direnv module";
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
