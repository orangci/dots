{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.services.monitoring.beszel;
in
{
  options.modules.services.monitoring.beszel = lib.my.mkServerModule { name = "Beszel"; } // {
    # example = mkOption {
    #   type = types.str;
    #   default = "An example value";
    #   description = "An example description";
    # };
  };

  config = mkIf cfg.enable {
    services.beszel = {
      hub = {
        enable = true;
        inherit (cfg) port;
      };
      agent = {
        enable = true;
        smartmon.enable = true;
      };
    };
  };
}
