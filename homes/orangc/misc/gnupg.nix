{
  config,
  lib,
  pkgs,
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
      defaultCacheTtl = 31536000; # 1 year
      defaultCacheTtlSsh = 31536000; # 1 year
    };
  };
}
