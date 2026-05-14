{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.misc.gnupg;
in
{
  options.hmModules.misc.gnupg.enable = mkEnableOption "gnupg module";
  config = mkIf cfg.enable {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 31536000; # 6 years
      defaultCacheTtlSsh = 31536000;
      maxCacheTtl = 31536000;
    };
  };
}
