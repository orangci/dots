{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.services.databases.couchdb;
in
{
  options.modules.services.databases.couchdb.enable = mkEnableOption "CouchDB Server";
  config = mkIf cfg.enable {
    services.couchdb = {
      enable = true;
      port = 5984;
      bindAddress = "0.0.0.0";
    };
  };
}
