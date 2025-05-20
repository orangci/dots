{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.hmModules.cli.fetch;
in {
  options.hmModules.cli.fetch = {
    enable = mkEnableOption "Enable fetch programs";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      microfetch
      nitch
      onefetch
      owofetch
      ipfetch
    ];
  };
}
