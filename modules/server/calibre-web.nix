{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.calibre-web;
in
{
  options.modules.server.calibre-web.enable = mkEnableOption "Enable calibre-web";

  config = lib.mkIf cfg.enable {
    services.calibre-web = {
      enable = true;
      options = {
        enableBookConversion = true;
        enableBookUploading = true;
      };
    };
  };
}
