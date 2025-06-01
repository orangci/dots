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
  options.modules.server.ntfy.enable = mkEnableOption "Enable ntfy";

  config = lib.mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.orangc.net";
        auth-default-access = "deny-all";
      };
    };
  };
}
