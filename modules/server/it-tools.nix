{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.it-tools;
in
{
  options.modules.server.it-tools = lib.my.mkServerModule {
    name = "IT-Tools";
    subdomain = "tools";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."it-tools" = {
      image = "sharevb/it-tools:latest"; # corentinth is the original, sharevb is a guy who forked it-tools
      ports = [ "127.0.0.1:${toString cfg.port}:8080" ];
    };
  };
}
