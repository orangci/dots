{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.category.name;
in {
  options.modules.category.name = {
    enable = mkEnableOption "Enable name";
  };

  config = lib.mkIf cfg.enable {
    # ...
  };
}
