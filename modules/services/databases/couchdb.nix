{
  config,
  lib,
  sysadmin,
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
      adminUser = sysadmin.username;
      adminPass = "password"; # who cares bro the port isn't gonna be open in le firewall
    };
  };
}
