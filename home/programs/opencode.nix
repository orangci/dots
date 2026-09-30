{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.opencode;
in
{
  options.hmModules.programs.opencode = {
    enable = mkEnableOption "Enable OpenCode";

  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      opencode
      ollama
    ];
  };
}
