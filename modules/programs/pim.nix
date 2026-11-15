# credentials for the pim home-manager module (home/programs/pim.nix)
{
  config,
  lib,
  sysadmin,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    genAttrs
    optionalAttrs
    ;
  cfg = config.modules.programs.pim;
in
{
  options.modules.programs.pim = {
    enable = mkEnableOption "the credentials read by the pim tools (calendar, mail, feeds, forge)";
    linger = mkEnableOption "lingering, so user timers such as the morning brief run without a login";
    ntfy = mkEnableOption "a user-readable copy of the ntfy access token, for the morning brief's failure alerts";
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
        })
      # same secret as the ntfy scripts use, but readable by the user
      // optionalAttrs cfg.ntfy {
        "pim/ntfy-token" = {
          key = "ntfy-access-token";
          owner = sysadmin.username;
        };
      };

    users.users.${sysadmin.username}.linger = mkIf cfg.linger true;
  };
}
