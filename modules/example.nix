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
    enable = mkEnableOption "Example module";

    exampleOption = lib.mkOption {
      type = lib.types.str;
      default = "example";
      description = "An example option";
    };
  };

  config = lib.mkIf cfg.enable {
    # ...
  };
}
