{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.ntfy;
in
{
  options.modules.server.ntfy = {
    enable = mkEnableOption "Enable ntfy";
    domain = mkOption {
      type = types.str;
      default = "ntfy.orangc.net";
      description = "The domain for ntfy to be hosted at";
    };
    port = mkOption {
      type = types.int;
      default = 8810;
      description = "The port for ntfy to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${cfg.domain}/";
        auth-default-access = "deny-all";
        listen-http = ":${toString cfg.port}";
      };
    };
  };
}
