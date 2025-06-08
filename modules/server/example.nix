{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.example;
in
{
  options.modules.server.example = {
    enable = mkEnableOption "Enable example";

    name = mkOption {
      type = types.str;
      default = "Example";
    };

    port = mkOption {
      type = types.int;
      default = 8810;
      description = "The port for example to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "example.orangc.net";
      description = "The domain for example to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    #
  };
}
