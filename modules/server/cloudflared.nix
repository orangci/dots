{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.cloudflared;
in
{
  options.modules.server.cloudflared = {
    enable = mkEnableOption "Enable Cloudflared";
  };

  config = lib.mkIf cfg.enable {
    modules.common.sops.secrets."cloudflared_credentials.json".path = "/run/secrets/cloudflared.json";
    services.cloudflared = {
      enable = true;
      #   certificateFile = ;
      # TODO: complete cloudflared module
    };
  };
}
