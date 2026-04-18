{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.changedetection;
in
{
  options.modules.server.changedetection = lib.my.mkServerModule {
    name = "ChangeDetection";
    subdomain = "detect";
  };

  config = mkIf cfg.enable {
    services.changedetection-io = {
      enable = true;
      behindProxy = true;
      port = cfg.port;
      listenAddress = "0.0.0.0";
      baseURL = "https://${cfg.subdomain}";
      environmentFile = pkgs.writeText "changedetection-io.env" "DISABLE_VERSION_CHECK=true";
    };
  };
}
