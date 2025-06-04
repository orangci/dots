{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.ntfy;
in
{
  options.modules.server.ntfy = {
    enable = mkEnableOption "Enable ntfy";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "ntfy.orangc.net";
      description = "The domain for ntfy to be hosted at";
    };
    port = lib.mkOption {
      type = lib.types.str;
      default = "8552";
      description = "The port for ntfy to be hosted at";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${cfg.domain}/";
        auth-default-access = "deny-all";
        listen-http = ":${cfg.port}";
      };
    };
    services.caddy.virtualHosts.${cfg.domain}.extraConfig = "reverse_proxy 127.0.0.1:${cfg.port}";
  };
}
