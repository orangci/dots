{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.services.category.example;
in
{
  options.modules.services.category.example = lib.my.mkServerModule { name = "Example"; } // {
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
