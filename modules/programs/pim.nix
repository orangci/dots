# credentials for the pim home-manager module (home/programs/pim.nix)
{
  config,
  lib,
  sysadmin,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf genAttrs;
  cfg = config.modules.programs.pim;
in
{
  options.modules.programs.pim = {
    enable = mkEnableOption "the credentials read by the pim tools (calendar, mail, feeds, forge)";
    linger = mkEnableOption "lingering, so user timers such as the morning brief run without a login";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets =
      genAttrs
        [
          "pim/davis-password"
          "pim/mail-password"
          "pim/miniflux-token"
          "pim/forgejo-token"
        ]
        (_: {
          owner = sysadmin.username;
        });

    users.users.${sysadmin.username}.linger = mkIf cfg.linger true;
  };
}
