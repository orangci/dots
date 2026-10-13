{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.hardware.btrfs;
in
{
  options.modules.hardware.btrfs = {
    enable = mkEnableOption "btrfs autoscrub";
  };

  config = lib.mkIf cfg.enable {
    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };
  };
}
