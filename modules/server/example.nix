{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.server.example;
in
{
  options.modules.server.example = lib.my.mkServerModule { name = "Example"; } // {
    # example = mkOption {
    #   type = types.str;
    #   default = "An example value";
    #   description = "An example description";
    # };
  };

  config = mkIf cfg.enable {
    #
  };
}
